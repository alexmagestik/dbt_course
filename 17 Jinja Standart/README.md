### Оригинальный код analyses/flights_by_aircraft.sql

```sql
{% set aircraft_query %}
SELECT DISTINCT
    aircraft_code
FROM
    {{ ref('fct_fligths') }}
{% endset %}  

{% set aircraft_query_result = run_query(aircraft_query) %}
{% if execute %}
    {% set important_aircrafts = aircraft_query_result.columns[0].values() %}
{% else %}
    {% set important_aircrafts = [] %}
{% endif %}

SELECT 
    {% for aircraft in important_aircrafts %}
    SUM(CASE WHEN aircraft_code = '{{ aircraft }}' THEN 1 ELSE 0 END) as fligths_{{ aircraft }} 
        {%- if not loop.last %},{% endif %}
    {%- endfor %}
FROM
    {{ ref('fct_fligths') }}
```

### Variables

```sql
loop.last
loop['last']
```

### Filters

```sql
as fligths_{{ aircraft }} 
as fligths_{{ aircraft|title|replace('73', 'oo') }} 
```

### Tests

```sql
    {% for aircraft in important_aircrafts %}
    SUM(CASE WHEN aircraft_code = '{{ aircraft }}' THEN 1 ELSE 0 END) as fligths_{{ aircraft|title|replace('73', 'oo') }} 
        {%- if not loop['last'] %},{% endif %}
        -- {% if aircraft is lower %} {{ aircraft }} — Да! ✅ {% else %} {{ aircraft }} — Нет! ❌ {% endif %}
        -- {% if aircraft is upper %} {{ aircraft }} — Да! ✅ {% else %} {{ aircraft }} — Нет! ❌ {% endif %}
        -- {% if aircraft is string %} {{ aircraft }} — Да! ✅ {% else %} {{ aircraft }} — Нет! ❌ {% endif %}
        -- {% if aircraft is number %} {{ aircraft }} — Да! ✅ {% else %} {{ aircraft }} — Нет! ❌ {% endif %}
    {%- endfor %}
```

### Escaping

```sql
{% set aircraft_query %}
SELECT DISTINCT
    aircraft_code
FROM
    {{ ref('fct_fligths') }}
{% endset %}  

{% set aircraft_query_result = run_query(aircraft_query) %}
{% if execute %}
    {% set important_aircrafts = aircraft_query_result.columns[0].values() %}
{% else %}
    {% set important_aircrafts = [] %}
{% endif %}

SELECT 
{{ '{{' }}
{% raw %}
    {% for aircraft in important_aircrafts %}
    SUM(CASE WHEN aircraft_code = '{{ aircraft }}' THEN 1 ELSE 0 END) as fligths_{{ aircraft|title|replace('73', 'oo') }} 
        {%- if not loop['last'] %},{% endif %}
        -- {% if aircraft is string %} {{ aircraft }} — Да! ✅ {% else %} {{ aircraft }} — Нет! ❌ {% endif %}
    {%- endfor %}
{% endraw %}
FROM
    {{ ref('fct_fligths') }}


```

### For Loop

```sql
    {% for aircraft in important_aircrafts %}
    SUM(CASE WHEN aircraft_code = '{{ aircraft }}' THEN 1 ELSE 0 END) as fligths_{{ aircraft|title|replace('73', 'oo') }} 
        {%- if not loop['last'] %},{% endif %}
        -- {{ loop.index }}
        -- {{ loop.index0 }}
        -- {{ loop.previtem }}
        -- {{ loop.nextitem }}
        -- {{ loop.cycle('-', '+') }}
    {%- endfor %}
```
