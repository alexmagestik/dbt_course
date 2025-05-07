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

