models/staging/flights/stg_flights__ticket_flights.sql:
```sql
{{
    config(
        materialized = 'table',
    )
}}
SELECT 
    ticket_no, 
    flight_id, 
    fare_conditions,
    amount
FROM
    {{ source('demo_src', 'ticket_flights') }}
{% if target.name == 'dev' -%}
limit 100000
{%- endif %}
```

1 вариант analyses/flights_by_aircraft.sql:
```sql
{% set important_aircrafts = ['CN1', 'CR2', '763'] %}

SELECT 
    {% for aircraft in important_aircrafts -%}
    SUM(CASE WHEN aircraft_code = '{{ aircraft }}' THEN 1 ELSE 0 END) as fligths_{{ aircraft }} 
        {%- if not loop.last %},{% endif %}
    {% endfor %}
FROM
    {{ ref('fct_fligths') }}
```

2 вариант analyses/flights_by_aircraft.sql:
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
