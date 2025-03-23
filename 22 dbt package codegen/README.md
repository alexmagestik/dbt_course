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


### Генерация кода модели и сохранение в файл

```console
dbt run-operation codegen.create_base_models --args '{source_name: "demo_src", tables: ["airports","aircrafts"]}'                               
```

### Генерация yml файла с конфигурированием модели
#### analyses/generate_model_yaml.sql

```sql
{{ codegen.generate_model_yaml(
    model_names=['fct_bookings', 'fct_fligths']
) }}
```

```console
dbt compile --select generate_model_yaml 
```
