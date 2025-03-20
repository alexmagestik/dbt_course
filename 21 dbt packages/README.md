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
