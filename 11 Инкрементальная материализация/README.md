#### Оригинальный код модели staging/fligths/stg_flights__bookings.sql

```sql
{{
    config(
        materialized = 'table',
        tags = ['bookings']
    )
}}
SELECT
    book_ref,
    book_date,
    total_amount
FROM
    {{ source('demo_src', 'bookings') }}
```

#### Код модели с инкрементальным обновлением по стратегии append staging/fligths/stg_flights__bookings_append.sql

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
    total_amount
FROM
    {{ source('demo_src', 'bookings') }}
{% if is_incremental() %}
WHERE 
    ('0x' || book_ref)::bigint > (SELECT MAX(('0x' || book_ref)::bigint) FROM {{ this }})
{% endif %}
```

#### Код модели с инкрементальным обновлением по стратегии append staging/fligths/stg_flights__bookings_merge.sql

```sql
{{
    config(
        materialized = 'incremental',
        incremental_strategy = 'merge',
        unique_key = ['book_ref'],
        tags = ['bookings'],
        merge_update_columns = ['total_amount'],
        on_schema_change = 'sync_all_columns'
    )
}}
SELECT
    book_ref,
    book_date,
    total_amount
FROM
    {{ source('demo_src', 'bookings') }}
{% if is_incremental() %}
WHERE 
    book_date > (SELECT MAX(book_date) FROM {{ source('demo_src', 'bookings') }}) - interval '97 day'
{% endif %}
```
