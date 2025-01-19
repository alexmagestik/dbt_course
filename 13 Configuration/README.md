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

models/intermediate/fligths/_int_fligths__models.yml
```yml
models:
  - name: fct_bookings
    description: Факты бронирований
    docs:
      show: true
      node_color: red
    latest_version: 1
    versions:
      - v: 1
    config:
      contract: {enforced: true}
    meta:
      owner: "amelinvd@gmail.com"
      contact_tg: vladamelin
      status: in_dev
    
    columns:
      - name: book_ref
        description: Идентификатор бронирования
        data_type: varchar(8)
        constraints:
          - type: not_null
        tags:
          - "fact"
          - "fligths"
      - name: book_date
        description: Дата Бронирования
        data_type: timestamptz
      - name: total_amount
        description: Сумма бронирования
        data_type: numeric(10, 2)
        constraints:
        - type: check
          expression: "total_amount > 0"
        tests:
          - not_null
        meta:
          owner: finance_team
        quote: false
```

```yml
name: 'dbt_course_practice'
version: '1.0.0'

profile: 'dbt_course_practice'

model-paths: ["models"]
analysis-paths: ["analyses"]
test-paths: ["tests"]
seed-paths: ["seeds"]
macro-paths: ["macros"]
snapshot-paths: ["snapshots"]

clean-targets:        
  - "target"
  - "dbt_packages"

models:
  dbt_course_practice:
    +meta:
      owner: "@vladamelin"
      year_created: 2025

seeds:
  dbt_course_practice:
    schema: seeds
```
