### Cross-database macros
### macros/limit_data_dev.sql

```sql
{% macro limit_data_dev(column_name, days=5000) %}
{% if target.name == 'dev' %}
WHERE
    {{ column_name }} >= {{ dbt.dateadd(datepart="day", interval=-days, from_date_or_timestamp="current_date") }}
{% endif %}
{% endmacro %}
```

### Exceptions
### macros/kopeck_to_ruble.sql

```sql
{% macro kopeck_to_ruble(column_name, scale=2) %}
    {% if scale < 0 %}
        {# {{ exceptions.raise_compiler_error("Invalid `scale` of numeric. Got: " ~ scale) }} #}
        {% do exceptions.warn("Invalid `scale`. Got: " ~ scale) %}
    {% endif %}
    ({{ column_name }} / 100)::numeric(16, {{ scale }})
{% endmacro %}
```

### Execute + Graph
### models/staging/flights/stg_flights__bookings_append.sql

```sql
{% if execute %}
-- {{ graph.nodes.values() }}
  {% for node in graph.nodes.values() -%}
    {% if node.resource_type == 'model' or node.resource_type == 'seed' %}
-- {{ node.name }}
---------------------
-- {{ node.depends_on }}
---------------------
    {% endif %}
  {% endfor %}
{% endif %}
```

### Model

### dbt_project.yml

```yml
models:
  +post_hook: "
        CREATE SCHEMA IF NOT EXISTS logs;

        CREATE TABLE IF NOT EXISTS {{ target.database }}.logs.dbt_logs (
            event_date timestamp,
            event_name varchar(100),
            node_name varchar(256)
        );

        INSERT INTO {{ target.database }}.logs.dbt_logs
        (event_date, event_name, node_name)
        VALUES (
            CURRENT_TIMESTAMP, 'finish run model', '{{ model.name }}'
        )
      "
```

```sql
SELECT event_date, event_name, node_name
FROM logs.dbt_logs;
```
