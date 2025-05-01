### Добавляем логику в модель
#### models/intermediate/fligths/fct_fligths.sql

```sql
{{
    config(
        materialized = 'table'
    )
}}
select
    flight_id, 
    flight_no, 
    scheduled_departure, 
    scheduled_arrival, 
    departure_airport, 
    arrival_airport, 
    status, 
    aircraft_code, 
    actual_departure, 
    actual_arrival,

    case
        when actual_departure is not null and scheduled_departure < actual_departure
        then actual_departure - scheduled_departure
        else INTERVAL '0 seconds'
    end as flight_departure_delay
from
    {{ ref('stg_flights__flights') }}
```

#### tests/intermediate/fligths/unit_fct_fligths.yml
```yml
unit_tests:
  - name: test_fact_departure_after_scheduled_departure
    description: "Время фактического отправления позже запланированного. В поле задержки отправления должно быть положительное число"
    model: fct_fligths
    given:
      - input: ref('stg_flights__flights')
        rows:
          - {scheduled_departure: 2017-09-01T09:25:00+00:00, actual_departure: 2017-09-01T09:27:00+00:00}
    expect:
      rows:
          - {scheduled_departure: 2017-09-01T09:25:00+00:00, actual_departure: 2017-09-01T09:27:00+00:00, flight_departure_delay: 0:02:00}
  - name: test_fact_departure_equal_scheduled_departure
    description: "Время фактического отправления равно запланированному. В поле задержки отправления должен быть 0"
    model: fct_fligths
    given:
      - input: ref('stg_flights__flights')
        rows:
          - {scheduled_departure: 2017-09-01T09:25:00+00:00, actual_departure: 2017-09-01T09:25:00+00:00}
    expect:
      rows:
          - {scheduled_departure: 2017-09-01T09:25:00+00:00, actual_departure: 2017-09-01T09:25:00+00:00, flight_departure_delay: 0:00:00}
  - name: test_fact_departure_less_scheduled_departure
    description: "Время фактического отправления раньше запланированного. В поле задержки отправления должен быть 0"
    model: fct_fligths
    given:
      - input: ref('stg_flights__flights')
        rows:
          - {scheduled_departure: 2017-09-01T09:25:00+00:00, actual_departure: 2017-09-01T09:23:00+00:00}
    expect:
      rows:
          - {scheduled_departure: 2017-09-01T09:25:00+00:00, actual_departure: 2017-09-01T09:23:00+00:00, flight_departure_delay: 0:00:00}
  - name: test_fact_departure_is_null
    description: "Время фактического отправления пустое. В поле задержки отправления должен быть 0"
    model: fct_fligths
    given:
      - input: ref('stg_flights__flights')
        format: csv
        rows: |
          scheduled_departure,actual_departure
          2017-09-01T09:25:00+00:00,
    expect:
      rows:
          - {scheduled_departure: 2017-09-01T09:25:00+00:00, actual_departure: , flight_departure_delay: 0:00:00}
```
#### Запуск только unit тестов по модели fct_fligths

```console
dbt test -s "fct_fligths,test_type:unit"
```

### Тестирование инкрементальной модели
#### models/staging/flights/stg_flights__bookings_append.sql

```sql
{{
    config(
        materialized = 'incremental',
        incremental_strategy = 'append', 
        tags = ['bookings']
    )
}}
SELECT
    book_ref,
    book_date,
    {{ kopeck_to_ruble('total_amount') }} as total_amount
FROM
    {{ source('demo_src', 'bookings') }}
{% if is_incremental() %}
WHERE 
    {{ bookref_to_bigint('book_ref') }} > (SELECT MAX({{ bookref_to_bigint('book_ref') }}) FROM {{ this }})
{% endif %} 
```

#### tests/staging/flights/unit_stg_flights__bookings_append.yml

```yml
unit_tests:
  - name: test_append_one_new_row
    description: "1 строка загружена в модель ранее. Во время обновления должна подгрузиться 1 новая строка с бОльшим bookref"
    model: stg_flights__bookings_append
    overrides:
      macros:
        is_incremental: true
    given:
      - input: source('demo_src', 'bookings')
        rows:
          - {book_ref: 00001F, book_date: 2017-01-02}
      - input: this
        rows:
          - {book_ref: 00000F, book_date: 2017-01-01}
    expect:
      rows:
        - {book_ref: 00001F, book_date: 2017-01-02}
  - name: test_init_load_one_row
    description: "загрузка одной строки при первой загрузке"
    model: stg_flights__bookings_append
    overrides:
      macros:
        is_incremental: false
    given:
      - input: source('demo_src', 'bookings')
        rows:
          - {book_ref: 00001F, book_date: 2017-01-02}
    expect:
      rows:
        - {book_ref: 00001F, book_date: 2017-01-02}
```

#### Запуск тестов по модели stg_flights__bookings_append

```console
dbt test -s "stg_flights__bookings_append"
```
