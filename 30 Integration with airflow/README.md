#### Создаем папку для airflow

```console
mkdir airflow
cd airflow
```

#### Устанавливаем docker desktop по инструкции, если он не установлен

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
