#### 

```console
```

#### 

```console
```

#### 

```console
```

#### 

```console
```

#### 

```console
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

