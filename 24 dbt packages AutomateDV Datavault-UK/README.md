### Подключение пакета
#### packages.yml

```yml
packages:
  - package: dbt-labs/dbt_utils
    version: 1.3.0
  - package: dbt-labs/codegen
    version: 0.13.1
  - package: dbt-labs/dbt_project_evaluator
    version: 1.0.0
  - package: Datavault-UK/automate_dv
    version: 0.11.2
```

### Модель с сырыми данными из источника
#### models/raw_stage/raw_airports.sql

```sql
{{
    config(
        materialized = 'table'
    )
}}
SELECT
    airport_code,
    airport_name,
    city,
    coordinates,
    timezone,
    'bookings' as RECORD_SOURCE,
    now() as LOAD_DATE
FROM
    {{ source('demo_src', 'airports') }}
```

### Генерируем модель stg слоя для datavault
#### models/stage/v_stg_flights__airports.sql

```sql
{{ config(materialized='view') }}

{%- set yaml_metadata -%}
source_model: "raw_airports"
derived_columns:
  SOURCE: "!1"
  LOAD_DATETIME: "LOAD_DATE"
  EFFECTIVE_FROM: "LOAD_DATE::date"
hashed_columns:
  AIRPORT_HK: "airport_code"
  AIRPORT_HASHDIFF:
    is_hashdiff: true
    columns:
      - "airport_name"
      - "city"
      - "coordinates"
      - "timezone"
{%- endset -%}

{% set metadata_dict = fromyaml(yaml_metadata) %}

{{ automate_dv.stage(include_source_columns=true,
                     source_model=metadata_dict['source_model'],
                     derived_columns=metadata_dict['derived_columns'],
                     null_columns=none,
                     hashed_columns=metadata_dict['hashed_columns'],
                     ranked_columns=none) }}
```

### Генерируем hub
#### models/raw_vault/hubs/hub_airports.sql

```sql
{{ config(materialized='incremental')    }}

{%- set source_model = "v_stg_flights__airports"   -%}
{%- set src_pk = "AIRPORT_HK"          -%}
{%- set src_nk = "airport_code"          -%}
{%- set src_ldts = "LOAD_DATE"      -%}
{%- set src_source = "RECORD_SOURCE"    -%}

{{ automate_dv.hub(src_pk=src_pk, src_nk=src_nk, src_ldts=src_ldts,
                   src_source=src_source, source_model=source_model) }}
```
