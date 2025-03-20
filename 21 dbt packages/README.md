### Использование generic теста dbt_utils.not_empty_string
#### models/staging/flights/_fligths__sources.yml

```yml
      - name: airports
        description: Аэропорты
        columns: 
          - name: airport_code
            description: Код аэропорта
            tests:
              - dbt_utils.not_empty_string
```

### Использование интроспективного макроса dbt_utils.get_relations_by_prefix
#### models/staging/flights/stg_flights__seats.sql

```sql
{% for rel in dbt_utils.get_relations_by_prefix(target.schema, 'stg_flights') %}
    --{{ rel }}
{% endfor %}
```

### Использование интроспективного макроса dbt_utils.get_column_values
#### analyses/aircrafts_with_flights.sql

```sql
{% set aircrafts_codes_with_flights = dbt_utils.get_column_values(
    table=ref('stg_flights__flights'),
    column='aircraft_code'
) %}

SELECT
    *
FROM
    {{ ref('stg_flights__aircrafts') }}
WHERE 
    aircraft_code IN ('{{ aircrafts_codes_with_flights | join("', '") }}')
```

```console
dbt compile --select aircrafts_with_flights
```

### Генерация последовательности дат с помощью dbt_utils.date_spine
#### analyses/generate_series.sql

```sql
{{ dbt_utils.date_spine(
    datepart="day",
    start_date="cast('2019-01-01' as date)",
    end_date="cast('2020-01-01' as date)"
   )
}}
```

### Генерация последжовательности чисел с помощью dbt_utils.generate_series
#### analyses/generate_series.sql

```sql
{{ dbt_utils.generate_series(upper_bound=50) }}
```

### Получение текущего времени и даты с помощью dbt_utils.pretty_time()
#### analyses/generate_series.sql

```sql
{{ dbt_utils.pretty_time() }}
{{ dbt_utils.pretty_time(format='%Y-%m-%d %H:%M:%S') }}
```

###  Вывод в логи отформатированного сообщения с помощью dbt_utils.log_info
#### analyses/generate_series.sql

```sql
{{ dbt_utils.log_info("my pretty message") }}
```

### 

```sql
```

### 

```sql
```
