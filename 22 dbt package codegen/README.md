### Подключение пакета codegen к проекту
#### packages.yml

```yml
packages:
  - package: dbt-labs/dbt_utils
    version: 1.3.0
  - package: dbt-labs/codegen
    version: 0.13.1
```

```console
dbt deps
```

### Использование codegen.generate_base_model
#### analyses/generate_base_model.sql

```sql
{{ codegen.generate_base_model(
    source_name='demo_src',
    table_name='aircrafts',
    materialized='table'
) }}
```

```console
dbt compile --select generate_base_model
```

#### Сохранение сгенерированного кода модели в файл
```console
dbt run-operation codegen.generate_base_model --args "{source_name: 'demo_src', table_name: 'aircrafts', materialized: 'table'}" | grep -v '\[' > models/staging/flights/stg_flights__aircrafts_generated.sql
```


### Использование 
#### 

```sql
```

### Использование 
#### 

```sql
```

### Использование 
#### 

```sql
```

### Использование 
#### 

```sql
```

### Использование 
#### 

```sql
```
