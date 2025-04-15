#### Запуск обновления модели fct_bookings

```console
dbt run --select fct_bookings
```

#### Запуск обновления моделей fct_bookings и fct_fligths и всех их предков

```console 
dbt run --select "+fct_bookings +fct_fligths"
```

#### Обновление tickets_per_flights и его непосредственных родителей

```console
dbt run --select "1+tickets_per_flights"
```

#### Обновление сида airline_worker и его непосредственных детей

```console
dbt build --select "airline_worker+1"
```

#### Обновление сида airline_worker всех его потомков и всех предков всех потомков

```console
dbt build --select "@airline_worker"
```

#### Получение цепочки всех моделей, начинающейся с stg_flights__flights и заканчивающейся tickets_per_flights

```console
dbt run -s "stg_flights__flights+,+tickets_per_flights"
```
#### Поиск всех элементов, которые были изменены

```console
dbt ls --select "state:modified" --state /Users/amelinvd/workdir/dbt_course_git/state
```

#### Поиск всех тестов, упавших при последнем выполнении

```console
dbt ls --select "result:fail" --state target
```

#### Поиск всех тестов с проверкой на уникальность

```console
dbt test --select "test_name:unique"
```

#### Обновление моделей, по которым упали тесты, вместе с выполнением их тестов. Используется select

```console
dbt ls --select "1+result:fail" --state target
```

#### Задание selectors в selectors.yml

```yml
selectors:
  - name: failed_tests_with_their_models
    definition: '1+result:fail'
```

#### Обновление моделей, по которым упали тесты, вместе с выполнением их тестов. Используется selector

```console
dbt build --selector failed_tests_with_their_models --state target
```

