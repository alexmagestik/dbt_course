#### Первоначальное содержимое файла seeds/dictionaries/city_region.csv

```
city,region
Анапа,Краснодарский край
Геленджик,Краснодарский край
Грозный,Чеченская Республика
Казань,Республика Татарстан
Калуга,Калужская область
```

#### Запуск загрузки seed
```console
dbt seed
```

#### Дополнительные команды
```console
dbt run --select city_region # обновление всех моделей, зависящих от сида city_region
dbt build --select city_region # обновление всех моделей, зависящих от сида city_region, вместе с сидом
dbt seed --select city_region # обновление только сида city_region
```

#### Замена разделителя в файле seeds/dictionaries/city_region.csv на ;

```csv
city;region
Анапа;Краснодарский край
Геленджик;Краснодарский край
Грозный;Чеченская Республика
Казань;Республика Татарстан
Калуга;Калужская область
Москва;Москва
```

#### Файл со свойствами сида seeds/dictionaries/_dictionaries__seeds.yml
```yaml
seeds:
  - name: city_region
    description: Сопоставление регионов и городов 
    config:
      column_types:
        city: varchar(50)
        region: varchar(50)
      delimiter: ";"
    columns:
      - name: city
        tests:
          - not_null
          - unique
```

#### Код модели models/staging/dictionaries/stg_dict__city_region.sql, получающей данные из сида
```sql
{{
    config(
        materialized = 'table',
    )
}}
SELECT
    city,
    region
FROM
    {{ ref('city_region') }}
```

#### Дополнение файла dbt_project.yml
```yml
seeds:
  dbt_course_practice:
    schema: seeds
```
