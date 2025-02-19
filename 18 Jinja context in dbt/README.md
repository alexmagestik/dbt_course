### Оригинальный код analyses/fligths_last_ten_years.sql

```sql
{% set current_date = run_started_at | string | truncate(10, True, "")   %}
{% set current_year = run_started_at | string | truncate(4, True, "") | int  %}
{% set prev_year = current_year - 10 %}

SELECT 
    COUNT(*)
FROM
    {{ ref('fct_fligths') }}
WHERE 
    scheduled_departure BETWEEN '{{ current_date }}' AND '{{ current_date | replace(current_year, prev_year) }}'
```

### adapter.get_relation

```sql
{% set source_relation = adapter.get_relation(
      database="dwh_flight",
      schema="intermediate",
      identifier="fct_fligths")
%}

{{ source_relation }}
{{ source_relation.database  }}
{{ source_relation.schema  }}
{{ source_relation.identifier  }}
{{ source_relation.is_table  }}
{{ source_relation.is_view  }}
{{ source_relation.is_cte  }}
```

### load_relation

```sql
{% set relation_exists = load_relation(ref('fct_fligths')) is not none %}
{% if relation_exists %}
      {{ "my_model has already been built" }}
{% else %}
      {{ "my_model doesn't exist in the warehouse. Maybe it was dropped?" }}
{% endif %}


{% set relation = load_relation(ref('fct_fligths')) %}
{{ relation }}
{{ relation.is_table }}
```

### adapter.get_columns_in_relation

```sql
{% set fligths_relation = load_relation(ref('fct_fligths')) %}
{%- set columns = adapter.get_columns_in_relation(fligths_relation) -%}

{% for column in columns -%}
  {{ "Column: " ~ column }}
{% endfor %}
```

### api.Relation.create

```sql
{% set relation = api.Relation.create(
      database="dwh_flight",
      schema="intermediate",
      identifier="fct_fligths",
      type="table"
    ) 
%}

{% for column in adapter.get_columns_in_relation(relation) -%}
  {{ "Column: " ~ column }}
{% endfor %}
```

### adapter.create_schema

```sql
{% do adapter.create_schema(api.Relation.create(database=target.database, schema="my_schema")) %}
```

### adapter.drop_schema

```sql
{% do adapter.drop_schema(api.Relation.create(database=target.database, schema="my_schema")) %}
```

### adapter.get_missing_columns

```sql
{% set fct_fligths = api.Relation.create(
      database="dwh_flight",
      schema="intermediate",
      identifier="fct_fligths",
      type="table"
    ) 
%}

{% set stg_flights__flights = api.Relation.create(
      database="dwh_flight",
      schema="intermediate",
      identifier="stg_flights__flights",
      type="table"
    ) 
%}

{% for column in adapter.get_missing_columns(stg_flights__flights, fct_fligths) -%}
  {{ "Column: " ~ column }}
{% endfor %} 
```

### adapter.expand_target_column_types

```sql
{% set fct_fligths = api.Relation.create(
        database = 'dwh_flight',
        schema = 'intermediate',
        identifier = 'fct_fligths',
        type = 'table'
    ) 
%}

{% set stg_flights__flights = api.Relation.create(
        database = 'dwh_flight',
        schema = 'intermediate',
        identifier = 'stg_flights__flights',
        type = 'table'
    ) 
%}

{% do adapter.expand_target_column_types(stg_flights__flights, fct_fligths) %}

{% for column in adapter.get_columns_in_relation(stg_flights__flights) %}
    {{ 'Column: ' ~ column }}
{%- endfor %} 

{% for column in adapter.get_columns_in_relation(fct_fligths) %}
    {{ 'Column: ' ~ column }}
{%- endfor %} 
```

### adapter.drop_relation и adapter.rename_relation

```sql
{{
    config(
        materialized = 'table',
        post_hook = '
            {% set backup_relation = api.Relation.create(
                    database = this.database,
                    schema = this.schema,
                    identifier = this.identifier ~ "_dbt_backup_new",
                    type = "table"
                ) 
            %}
            {% do adapter.drop_relation(backup_relation) %}
            {% do adapter.rename_relation(this, backup_relation) %}
        '
    )
}}
SELECT
    airport_code,
    airport_name,
    city,
    coordinates,
    timezone
FROM
    {{ source('demo_src', 'airports') }}


```

### 

```sql
```

### 

```sql
```

### 

```sql
```

### 

```sql
```

### 

```sql
```

### 

```sql
```

### 

```sql
```
