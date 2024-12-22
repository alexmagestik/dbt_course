# Установка dbt и разворот учебного проекта на локальном компьютере

## Этап 1. Установка python, если он не установлен

#### Шаг 1. Скачиваем дистрибутив с [официального сайта python](https://www.python.org/downloads/)
#### Шаг 2. Запускаем установку из дистрибутива.
При установке на ОС Windows поставьте галочку в пункте "Add python.exe to PATH":

![image](https://github.com/user-attachments/assets/e8199c37-3d2a-400d-bd0a-91a190e2e843)
#### Шаг 3. Проверяем установку.
Откройте PowerShell или окно Терминала и выполните команду 

````console
# Windows
python --version
````
````console
# Mac OS
python3 --version
````

Вы должны увидеть сообщение похожее на:
![image](https://github.com/user-attachments/assets/1b714705-c91a-4905-b5c5-f2af08729317)


## Этап 2. Установка dbt

#### Шаг 1. Открыть окно терминала.

#### Шаг 2. (выполните этот шаг, если вам может понадобится другая версия python и другой набор библиотек в работе) Создаем виртуальное окружение python, выполнив команду
````console
# Windows
python -m venv dbt-env
````
````console
# Mac OS
python3 -m venv dbt-env
````

Активируем виртуальное окружение при каждом открытии терминала командой:
````console
# Windows
dbt-env\Scripts\activate
````
````console
# Mac OS
source dbt-env/bin/activate
````

#### Шаг 3. Устанавливаем dbt для работы с postgres

````console
# Windows
python -m pip install dbt-postgres
````
при установке на Windows может понадобится дополнительно вызвать команду 
````console
python.exe -m pip install --upgrade pip
````

````console
# Mac OS
python3 -m pip install dbt-postgres
````

Если при установке возникает ошибка, то попробуйте:
* Установить python более ранних версий (замечено, что есть проблемы с python 3.13.*, но на 3.12.* и 3.11.* устанавливается);
* Установите postgresql локально;

## Этап 3. Установка git, если не установлен

#### Шаг 1. Скачать дистрибутив с [официального сайта git](https://git-scm.com/downloads).
#### Шаг 2. Установить git из скачанного дистрибутива.

## Этап 4. Скачивание учебного проекта

#### Шаг 1. Скачиваем код проекта
Откройте терминал и перейдите в папку, в которую хотите скачать проект.
Выполните команду:
````console
git clone https://github.com/amelinvladimir/dbt_course.git
````

## Этап 5. Установка DBeaver (если не установлен)

Смотри в первом этапе [инструкции](https://github.com/amelinvladimir/sql_course/blob/main/%D0%A3%D1%80%D0%BE%D0%BA%201.2%20%D0%A3%D1%81%D1%82%D0%B0%D0%BD%D0%BE%D0%B2%D0%BA%D0%B0%20%D0%9F%D0%9E/README.md)


## Этап 6. Установка Docker Desktop (если не установлен)

### На Windows
[Инструкция по установке](https://github.com/amelinvladimir/docker_course/blob/main/%D0%A3%D1%81%D1%82%D0%B0%D0%BD%D0%BE%D0%B2%D0%BA%D0%B0%20Docker%20%D0%BD%D0%B0%20Windows%2010/README.md)
### На Mac OS
[Инструкция по установке](https://github.com/amelinvladimir/docker_course/blob/main/%D0%A3%D1%81%D1%82%D0%B0%D0%BD%D0%BE%D0%B2%D0%BA%D0%B0%20Docker%20%D0%BD%D0%B0%20Mac%20OS/README.md)

## Этап 7. Запуск контейнера с БД учебного проекта

#### Шаг 1. Открыть терминал или powershell
#### Шаг 2. Выполнить команду запуска образа

````console
docker run --name dbt-course-postgres -e POSTGRES_PASSWORD=mysecretpassword -p 4001:5432 -d amelinvd/dbt_course_postgres_db
````

СУБД запущена. С помощью DBeaver можно подключиться к БД, используя следующие параметры
````console
тип БД: PostgreSQL
host: localhost
port: 4001
Имя БД: postgres
login: postgres
password: mysecretpassword
````
Поставить галочку в поле "Показать все базы данных"

## Этап 8. Создать файл profiles.yml с указанием параметров подключения к БД для dbt

#### Шаг 1. Открыть терминал или powershell
#### Шаг 2. Создать файл profiles.yml, выполнив команду:
````console
# Mac OS
touch ~/.dbt/profiles.yml

# Win PowerShell
New-Item ~/.dbt/profiles.yml
````
#### Шаг 3. Открыть на редактирование файл, выполнив команду:
````console
# Mac OS
nano ~/.dbt/profiles.yml

# Win PowerShell
notepad.exe profiles.yml
````
#### Шаг 4. Указать параметры подключения к БД

скопировать текст:
````console
dbt_course:
  outputs:
    dev:
      dbname: dbt_course
      host: localhost
      pass: mysecretpassword
      port: 4001
      schema: bookings_dbt
      threads: 4
      type: postgres
      user: postgres
  target: dev
````

##### Для Mac OS
В окне терминала последовательно нажать следующие комбинации клавиш:
````console
Ctrl + V # вставить текст
Ctrl + O # сохранить
Enter # подтвердить путь сохранения
Ctrl + X # выйти
````

##### Для Windows
Вставить текст в блокноте, сохранить и закрыть текстовый редактор.

## Этап 9. Собрать dbt проект

#### Шаг 1. Открыть терминал или powershell
#### Шаг 2. Перейти в папку dbt_course/dbt_course/ проекта, скачанного с git

Если выполнить команду 
````console
ls
````
Вы должны увидеть следующие папки и файлы
````console
README.md		dbt_project.yml		models			seeds			tests
analyses		logs			package-lock.yml	snapshots
dbt_packages		macros			packages.yml		target
````
#### Шаг 3. Запустить сборку проекта, выполнив команду
````console
dbt deps
````
и затем
````console
dbt build
````

Если установка прошла успешно, то вы увидите сообщение:
![image](https://github.com/user-attachments/assets/dd6f8771-687f-4fb1-a1f8-7a038559050a)


## Этап 10. Установка Visual Studio Code (VS Code), если не установлен

#### Шаг 1. Скачиваем дистрибутив с [сайта](https://code.visualstudio.com/) и запускаем установку.
#### Шаг 2. При устанвоке оставляем все настройки по умолчанию (или делайте изменения по своему усмотрению).
#### Шаг 3. Запускаем Visual Studio Code.
![image](https://github.com/user-attachments/assets/23d4ada8-1426-4694-b747-9f3267169dd4)
#### Шаг 4. Открываем папку проект.
Выбрать пункт меню "Файл -> Открыть папку" и выбрать папку dbt_course/dbt_course/ проекта, скачанного с git.
Вы должны увидеть в меню слева следующие папки и файлы:

![image](https://github.com/user-attachments/assets/21c5c528-3d99-413a-a425-8699333b74ab)

## Этап 11. Установить расширение "Power User for dbt" в Visual Code

#### Шаг 1. Нажать на шестиренку в левом нижнем углу и выбрать пункт "Расширения"
#### Шаг 2. В открывшейся строке поиска введите "Power User for dbt" и нажмите на соответствующий появившейся плагин. Нажмите "Установить"

![image](https://github.com/user-attachments/assets/aa4725b4-cf88-4796-877e-6f4fe16c194b)


![image](https://github.com/user-attachments/assets/3af73581-a7e6-4623-b7db-f195578acee8)

#### Шаг 3. Если плагин запросит выбрать версию python, то выберите последнюю установленную версию.

## Этап 12. Установить расширение "Power User for dbt" в Visual Code

#### Шаг 0. Проверка, установлено ли расширение
Нажать на шестиренку и затем выбрать пункт "Расширения" ("Extensions").
![image](https://github.com/user-attachments/assets/e0a5713a-937d-4233-a4a4-2c5cc937fd5d)

Нажмите троеточие рядом с заголовком  "Расширения" ("Extensions") и выберите пункт "Show Running Extensions" ("Показать Запущенные Расширения")
![image](https://github.com/user-attachments/assets/0235d69f-3cc5-4db2-bb98-7ac67601bd2d)

Ищем в открывшемся окне расширение с названием "Python". Если находим, то следущие шаги данного этапа пропускаем.
![image](https://github.com/user-attachments/assets/6f1b3e60-96ba-4a98-b760-3db2f787ef47)

#### Шаг 1. Нажать на шестиренку в левом нижнем углу и выбрать пункт "Расширения" ("Extensions")
#### Шаг 2. В открывшейся строке поиска введите "Python" и нажмите на соответствующий появившейся плагин. Нажмите "Установить" ("Install")
Если вы не видите 

## Этап 13. Выбираем версию python для работы с проектом

#### Шаг 0. Проверка, нужно ли дополнительно настраивать python в VS Code

Открываем терминал 
![image](https://github.com/user-attachments/assets/ca1ef146-21ac-406d-94fa-cbd1c4742206)

Выполняем команду 
````console
dbt --version
````

Если мы видим результат подобный этому, то следующие шаги нам выполнять не нужно
![image](https://github.com/user-attachments/assets/1c4eee73-c556-406d-b72a-de9afd213c24)

#### Шаг 1. Открываем расширение Python
![image](https://github.com/user-attachments/assets/c91241b6-4626-4ca8-a0e0-0cc896b3c163)

#### Шаг 2. Раскрываем список "Global" и видим все версии Python, установленные на ПК
![image](https://github.com/user-attachments/assets/906dc532-dcff-4d62-9663-a438a6d57075)

#### Шаг 3. Выбираем Python которая будет использована при работе с проектом
Для этого жмем на звездочку и выбранной версии
![image](https://github.com/user-attachments/assets/d51b2f93-b1ad-414e-a828-3cd4446ff4f3)

#### Шаг 4. Проверяем корректность установки dbt в данной версии Python
Жмем на значок "Консоли" рядом с версией pyhton, которую мы хотим использовать для работы и откроется окно Терминала
![image](https://github.com/user-attachments/assets/a510e2bd-068e-4a79-b2ce-395902724aae)

В окне терминала выполняем команду 

````console
dbt --version
````

Если увидим сообщение, как на скриншоте с выводом версии dbt библиотеки, то этап успешно завершен
![image](https://github.com/user-attachments/assets/b05d4c45-3aa9-46ed-921e-4bf318fd9284)


Если видим ошибку, как на скриншоте, то выполняем следующий шаг 
![image](https://github.com/user-attachments/assets/ac77cc6a-3d35-4aad-9505-f537545f4e20)

Выполняем команду 
````console
# На Windows
python -m pip install dbt-postgres

# На Mac OS
python3 -m pip install dbt-postgres
````

Вновь выполним в окне терминала команду и теперь мы должны увидеть номер версии установленного dbt
````console
dbt --version
````
