### Оригинальный код модели stg_flights__bookings.sql

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
