### Создаем первый Singular тест
#### tests/staging/flights/stg_flights__bookings__bookref__length.sql

```sql
SELECT
    book_ref
FROM
    {{ ref('stg_flights__bookings') }}
WHERE
    length(book_ref) > 7
```

#### Запускаем тест

```console
dbt build -s stg_flights__bookings         # сборка модели + выполнение теста по модели stg_flights__bookings
dbt test -s stg_flights__bookings          # выполнение теста по модели stg_flights__bookings без сборки модели
```

### Когда Singular тест зависит от нескольких моделей
#### tests/staging/flights/stg_flights__bookings__bookref__length.sql

```sql
SELECT
    b.book_ref
FROM
    "dwh_flight"."intermediate"."stg_flights__bookings" b
    JOIN "dwh_flight"."intermediate"."stg_fligths__tickets" t
        ON b.book_ref = t.book_ref
WHERE
    length(b.book_ref) > 5
```

#### Выполняем команды

```console
dbt test -s stg_flights__bookings                                 # запускаем тест по первой модели, от которой зависит тест
dbt test -s stg_fligths__tickets                                  # запускаем тест по второй модели, от которой зависит тест
dbt test -s "stg_fligths__tickets stg_flights__bookings"          # запускаем выполнение тестов по обеим моделям, от которых зависит тест
dbt build -s "stg_fligths__tickets stg_flights__bookings"         # собираем одной командой обе модели, от которых зависит тест
```

### Скомпилированный SQL код теста находится в файле tests/staging/flights/stg_flights__bookings__bookref__length.sql

```sql
SELECT
    b.book_ref
FROM
    "dwh_flight"."intermediate"."stg_flights__bookings" b
    JOIN "dwh_flight"."intermediate"."stg_fligths__tickets" t
        ON b.book_ref = t.book_ref
WHERE
    length(b.book_ref) > 5
```

### Запуск тест с сохранением результата в таблице в случае, если тест упадет

```console
dbt build -s stg_flights__bookings --store-failures
```

#### Получение упавших записей

```sql
select * from "dwh_flight"."intermediate_dbt_test__audit"."stg_flights__bookings__bookref__length"
```

### В конфигурации теста указываем, что в случае отрицательного результата должна быть не ошибка, а предупреждение

```sql
{{
    config(
        severity = 'warn',
    )
}}
SELECT
    b.book_ref
FROM
    {{ ref('stg_flights__bookings') }} b
    JOIN {{ ref('stg_fligths__tickets') }} t
        ON b.book_ref = t.book_ref
WHERE
    length(b.book_ref) > 5
```

### У всех тестов проекта должно быть предупреждение, а не ошибка, в случае не отрицательного результата
#### dbt_project.yml

```sql
tests:
  +severity: 'warn'
```
