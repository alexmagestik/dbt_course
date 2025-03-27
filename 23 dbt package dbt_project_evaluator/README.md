### Подключение пакета dbt_project_evaluator к проекту
#### packages.yml

```yml
packages:
  - package: dbt-labs/dbt_utils
    version: 1.3.0
  - package: dbt-labs/codegen
    version: 0.13.1
  - package: dbt-labs/dbt_project_evaluator
    version: 1.0.0
```

### Вывод в терминале сводки по выполненным тестам
#### dbt_project.yml

```yml
on-run-end: "{{ dbt_project_evaluator.print_dbt_project_evaluator_issues() }}"
```

### Запуск тестов пакета dbt_project_evaluator

```console
dbt build --select package:dbt_project_evaluator
```
