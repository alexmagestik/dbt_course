#### Изменение файла seeds/dictionaries/city_region.csv

```
city;region;updated_at
Анапа;Краснодарский край;2017-01-01T00:00:00+00:00
Геленджик;Краснодарский край;2017-01-01T00:00:00+00:00
Грозный;Чеченская Республика;2017-01-01T00:00:00+00:00
Казань;Республика Татарстан;2017-01-01T00:00:00+00:00
Калуга;Калужская область;2017-01-01T00:00:00+00:00
Москва;Москва;2017-01-01T00:00:00+00:00
```

#### Изменение файла seeds/dictionaries/_dictionaries__seeds.yml

```yml
seeds:
  - name: city_region
    description: Сопоставление регионов и городов 
    config:
      column_types:
        city: varchar(50)
        region: varchar(50)
        updated_at: timestamp
      delimiter: ";"
    columns:
      - name: city
        tests:
          - not_null
          - unique
```

#### Код сборки seed
```console
dbt seed
```

#### Создает snapshot с сопоставлением регионов и городов snapshots/dictionaries/snap_city_region.sql

```sql
{% snapshot snap_city_region %}

{{
   config(
       target_schema='snapshot',
       unique_key='city',

       strategy='timestamp',
       updated_at='updated_at',
       dbt_valid_to_current="'9999-01-01'::date"
   )
}}

SELECT 
    city,
    region,
    updated_at
FROM 
    {{ ref('city_region') }}

{% endsnapshot %}
```

#### Код создания Snapshot snapshots/fligths/dim_fligths__airports.sql

```sql
{% snapshot dim_fligths__airports %}

{{
    config(
        target_schema='snapshot',
        unique_key='airport_code',

        strategy='check',
        check_cols = ['airport_name', 'city', 'coordinates', 'timezone'],

        snapshot_meta_column_names={
            "dbt_valid_from": "dbt_effective_date_from",
            "dbt_valid_to": "dbt_effective_date_to"
        }
   )
}}

SELECT
    airport_code,
    airport_name,
    city,
    coordinates,
    timezone
FROM
    {{ ref('stg_flights__airports') }}

{% endsnapshot %}
```
