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

### 

```sql
```

### 

```sql
```

### 

```sql
```
