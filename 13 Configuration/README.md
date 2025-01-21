models/intermediate/fligths/fct_bookings.sql
```sql
{{
    config(
        materialized = 'table',
        meta = {
            'owner': 'sql_file_owner@gmail.com'
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
        owner: "yml_file_owner@gmail.com"
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

dbt_project.yml
```yml
# Name your project! Project names should contain only lowercase characters
# and underscores. A good package name should reflect your organization's
# name or the intended use of these models
name: 'dbt_course_practice'
version: '1.0.0'

# This setting configures which "profile" dbt uses for this project.
profile: 'dbt_course_practice'

# These configurations specify where dbt should look for different types of files.
# The `model-paths` config, for example, states that models in this project can be
# found in the "models/" directory. You probably won't need to change these!
model-paths: ["models"]
analysis-paths: ["analyses"]
test-paths: ["tests"]
seed-paths: ["seeds"]
macro-paths: ["macros"]
snapshot-paths: ["snapshots"]

clean-targets:         # directories to be removed by `dbt clean`
  - "target"
  - "dbt_packages"


# Configuring models
# Full documentation: https://docs.getdbt.com/docs/configuring-models

# In this example config, we tell dbt to build all models in the example/
# directory as views. These settings can be overridden in the individual model
# files using the `{{ config(...) }}` macro.
models:
  dbt_course_practice:
    +meta:
      owner: "dbt_project_yml@gmail.com"
      year_created: 2025

seeds:
  dbt_course_practice:
    schema: seeds
```
