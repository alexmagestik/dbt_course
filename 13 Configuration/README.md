models/intermediate/fligths/fct_bookings.sql
```sql
{{
    config(
        materialized = 'table',
        tags=['flights'],
        meta={
            'owner': 'amelinvd@gmail.com'
        },
        persist_docs={
            "relation": true,
            "columns": true
        }
    )
}}
select
    book_ref,
    book_date,
    total_amount
from
    {{ ref('stg_flights__bookings') }}
```
