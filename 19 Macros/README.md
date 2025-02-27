# Пример 1: преобразование копеек к рублям

### macros/kopeck_to_ruble.sql

```sql
{% macro kopeck_to_ruble(column_name, scale=2) %}
    ({{ column_name }} / 100)::numeric(16, {{ scale }})
{% endmacro %}
```

### models/staging/flights/stg_flights__bookings_append.sql

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
    {{ kopeck_to_ruble(column_name='total_amount') }} as total_amount
FROM
    {{ source('demo_src', 'bookings') }}
{% if is_incremental() %}
WHERE 
    ('0x' || book_ref)::bigint > (SELECT MAX(('0x' || book_ref)::bigint) FROM {{ this }})
{% endif %}
```

# Пример 2: сокращение обрабатываемых данных при разработке

### macros/limit_data_dev.sql

```sql
{% macro limit_data_dev(column_name, days=5000) %}
{% if target.name == 'dev' %}
WHERE
    {{ column_name }} >= current_date - interval '{{ days }} days'
{% endif %}
{% endmacro %}
```

### models/staging/flights/stg_flights__bookings.sql

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
{{ limit_data_dev('book_date') }}
```

# Пример 3: соединение значений из нескольких полей в одну строку

### macros/utils.sql

```sql
{%- macro concat_columns(columns, delim = ', ') %}
    {%- for column in columns -%}
        {{ column }} {% if not loop.last %} || '{{ delim }}' || {% endif %}
    {%- endfor -%}
{% endmacro %}
```

### models/intermediate/fligths/fct_fligths.sql

```sql
{{
    config(
        materialized = 'table'
    )
}}
select
    flight_id, 
    flight_no, 
    scheduled_departure, 
    scheduled_arrival, 
    departure_airport, 
    arrival_airport, 
    status, 
    aircraft_code, 
    actual_departure, 
    actual_arrival,
    {{ concat_columns([ 'flight_id', 'flight_no' ]) }} as fligth_info
from
    {{ ref('stg_flights__flights') }}
```

# Пример 4: удаление таблиц и представлений в БД, которым нет соответствующих model, seed и snapshot в dbt проекте

### macros/utils.sql

```sql
{% macro drop_old_relations(dryrun=False) %}

    {% if execute %}
    
        {# находим все модели, seed, snapshot проекта dbt #}
        
        {% set current_models = [] %}
        
        {% for node in graph.nodes.values() | selectattr("resource_type", "in", ["model", "snapshot", "seed"]) %}
            {% do current_models.append(node.name) %}
        {% endfor %}
        
        {# формирование скрипта удаления всез таблиц и вьюх, которым не соответствует ни одна модель, сид и снэпшот #}
        
        {% set cleanup_query %}
        WITH MODELS_TO_DROP AS (
            SELECT
                CASE
                    WHEN TABLE_TYPE = 'BASE TABLE' THEN 'TABLE'
                    WHEN TABLE_TYPE = 'VIEW' THEN 'VIEW'
                END AS RELATION_TYPE,
                CONCAT_WS('.', TABLE_CATALOG, TABLE_SCHEMA, TABLE_NAME) as RELATION_NAME
            FROM
                {{ target.database }}.INFORMATION_SCHEMA.TABLES
            WHERE
                TABLE_SCHEMA = '{{ target.schema }}'
                AND UPPER(TABLE_NAME) NOT IN (
                    {%- for model in current_models -%}
                        '{{ model.upper() }}'
                        {%- if not loop.last -%}
                            ,
                        {%- endif %}
                    {%- endfor -%}
                )
        )
        SELECT
            'DROP ' || RELATION_TYPE || ' ' || RELATION_NAME || ';' as DROP_COMMANDS
        FROM
            MODELS_TO_DROP;
        {% endset %}
        
        {% do log(cleanup_query) %}
        
        {% set drop_commands = run_query(cleanup_query).columns[0].values() %}
        
        {# удаление лишних таблиц и вьюх / вывод скрипта удаления #}
        
        
        {% if drop_commands %}
            {% if dryrun | as_bool == False %}
                {% do log('Executing DROP commands ...', True) %}
            {% else %}
                {% do log('Printing DROP commands ...', True) %}
            {% endif %}
        
            {% for drop_command in drop_commands %}
                {% do log(drop_command, True) %}
                {% if  dryrun | as_bool == False %}
                    {% do run_query(drop_command) %}
                {% endif %}
            {% endfor %}
        {% else %}
             {% do log('No relations to clean', True) %}
        {% endif %}
    
    {% endif %}

{% endmacro %}
    
```

### Вызов макроса без удаления таблиц и представлений

```console
dbt run-operation drop_old_relations --args '{"dryrun": True}'
```

### Вызов макроса с удалением таблиц и представлений

```console
dbt run-operation drop_old_relations
```
