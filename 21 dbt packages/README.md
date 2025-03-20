### Использование generic теста dbt_utils.not_empty_string
#### models/staging/flights/_fligths__sources.yml

```yml
      - name: airports
        description: Аэропорты
        columns: 
          - name: airport_code
            description: Код аэропорта
            tests:
              - dbt_utils.not_empty_string
```

### Использование интроспективного макроса dbt_utils.get_relations_by_prefix
#### models/staging/flights/stg_flights__seats.sql

```sql
{% for rel in dbt_utils.get_relations_by_prefix(target.schema, 'stg_flights') %}
    --{{ rel }}
{% endfor %}
```

### Использование интроспективного макроса dbt_utils.get_column_values
#### analyses/aircrafts_with_flights.sql

```sql
{% set aircrafts_codes_with_flights = dbt_utils.get_column_values(
    table=ref('stg_flights__flights'),
    column='aircraft_code'
) %}

SELECT
    *
FROM
    {{ ref('stg_flights__aircrafts') }}
WHERE 
    aircraft_code IN ('{{ aircrafts_codes_with_flights | join("', '") }}')
```

```console
dbt compile --select aircrafts_with_flights
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
