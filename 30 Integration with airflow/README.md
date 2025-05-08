#### Создаем папку для airflow

```console
mkdir airflow
cd airflow
```

#### Устанавливаем Docker Desktop по инструкции, если он не установлен

##### На Windows
[Инструкция по установке](https://github.com/amelinvladimir/docker_course/blob/main/%D0%A3%D1%81%D1%82%D0%B0%D0%BD%D0%BE%D0%B2%D0%BA%D0%B0%20Docker%20%D0%BD%D0%B0%20Windows%2010/README.md)
##### На Mac OS
[Инструкция по установке](https://github.com/amelinvladimir/docker_course/blob/main/%D0%A3%D1%81%D1%82%D0%B0%D0%BD%D0%BE%D0%B2%D0%BA%D0%B0%20Docker%20%D0%BD%D0%B0%20Mac%20OS/README.md)

#### Используя команду с [сайта airflow](https://airflow.apache.org/docs/apache-airflow/stable/howto/docker-compose/index.html) скачиваем docker-compose.yaml файл для запуска airflow в docker 
```console
curl -LfO 'https://airflow.apache.org/docs/apache-airflow/3.0.0/docker-compose.yaml'
```

#### Запускаем airflow в Docker
```console
docker compose up
```

#### Копируем папку с dbt проектом в папку dags, созданную в папке airflow. Даем название папке с dbt проектом: "dbt".

#### Открываем папку со скопированный dbt проектом в VSCode

<img width="562" alt="image" src="https://github.com/user-attachments/assets/a1393aff-a4c9-4a89-9e28-a921857587d8" />
<img width="1169" alt="image" src="https://github.com/user-attachments/assets/265ed5f1-2a1f-4529-b16e-7979e3fe08b3" />

### Создаем виртуальное окружение python
#### Жмем ctrl+shft+p или cmd+shft+p
#### Выбираем "Python: Select Interpreter"
#### Жмем "Создание виртуальный среды" -> "Venv" -> "Создать" -> Выберите версию python -> Выберите файл requirements, если он будет предложен

#### Откройте окно терминала в VSCode и выполните команду
```console
dbt --version
```

#### Если dbt-postgres не установлен, то установите его запуском команды
# Windows
python -m pip install dbt-postgres
при установке на Windows может понадобится дополнительно вызвать команду

python.exe -m pip install --upgrade pip
# Mac OS
python3 -m pip install dbt-postgres

#### Открываем в VSCode папку airflow
<img width="507" alt="image" src="https://github.com/user-attachments/assets/e58c15c8-4ba6-4282-8a46-1c2d87d34de0" />
<img width="1084" alt="image" src="https://github.com/user-attachments/assets/eb6987a8-8b85-492e-a686-64589ca35544" />

#### В docker-compose.yaml вносим правки:
```yml
  # image: ${AIRFLOW_IMAGE_NAME:-apache/airflow:3.0.0}
  build: .
```

#### Создаем Dockerfile
```docker
FROM apache/airflow:3.0.0

COPY requirements.txt /
RUN pip install --no-cache-dir -r /requirements.txt
```

#### Создаем requirements.txt
```
dbt-postgres==1.9.0
astronomer-cosmos==1.10.0
```

#### Удаляем docker контейнеры с airflow в Docker Desktop

#### Запускаем airflow с новым образом

```console
docker compose up --build
```

#### Создаем подключение к postgres в airflow
<img width="886" alt="image" src="https://github.com/user-attachments/assets/aa5e1dfe-78f6-4048-847d-a97cfc5cbfaa" />

#### Добавляем контейнер с postgres в сеть с контейнерами airflow, если postgres запущен в docker

```console
docker network --help
docker network connect --help
docker container ls
docker network ls
docker network connect airflow_default dbt-course-postgres
docker network inspect airflow_default
```

#### Создаем файл dags/dbt/my_first_dag.py

```python
from cosmos import DbtDag, ProjectConfig, ProfileConfig, ExecutionConfig, RenderConfig
from cosmos.profiles import PostgresUserPasswordProfileMapping

import os
from datetime import datetime

profile_config = ProfileConfig(
    profile_name="default",
    target_name="dev",
    profile_mapping=PostgresUserPasswordProfileMapping(
        conn_id="postgres_dbt",
        profile_args={"schema": "intermediate"},
    ),
)

my_cosmos_dag = DbtDag(
    project_config=ProjectConfig(
        f"{os.environ['AIRFLOW_HOME']}/dags/dbt",
    ),
    profile_config=profile_config,
    render_config=RenderConfig(
        select=["stg_flights__aircrafts"],
    ),
    execution_config=ExecutionConfig(
        dbt_executable_path=f"{os.environ['AIRFLOW_HOME']}/dags/dbt/.venv/bin",
    ),
    # normal dag parameters
    schedule="@daily",
    start_date=datetime(2023, 1, 1),
    catchup=False,
    dag_id="my_first_dag",
    default_args={"retries": 2},
)
```
#### В файле config/airflow.cfg правим параметр dagbag_import_timeout

```cfg
dagbag_import_timeout = 600.0
```

#### Перезапускаем airflow в docker

#### В airflow запускаем выполнение дага my_first_dag

#### Создаем файл dags/dbt/my_second_dag.py

```python
from cosmos import DbtDag, ProjectConfig, ProfileConfig, ExecutionConfig
from cosmos.profiles import PostgresUserPasswordProfileMapping

import os
from datetime import datetime

profile_config = ProfileConfig(
    profile_name="default",
    target_name="dev",
    profile_mapping=PostgresUserPasswordProfileMapping(
        conn_id="postgres_dbt",
        profile_args={"schema": "intermediate"},
    ),
)

my_cosmos_dag = DbtDag(
    project_config=ProjectConfig(
        f"{os.environ['AIRFLOW_HOME']}/dags/dbt",
    ),
    profile_config=profile_config,
    execution_config=ExecutionConfig(
        dbt_executable_path=f"{os.environ['AIRFLOW_HOME']}/dags/dbt/.venv/bin",
    ),
    # normal dag parameters
    schedule="@daily",
    start_date=datetime(2023, 1, 1),
    catchup=False,
    dag_id="my_second_dag",
    default_args={"retries": 2},
)
```
