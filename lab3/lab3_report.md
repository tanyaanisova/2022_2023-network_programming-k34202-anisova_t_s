> University: [ITMO University](https://itmo.ru/ru/)<br/>
> Faculty: [FICT](https://fict.itmo.ru)<br/>
> Course: [Network programming](https://github.com/itmo-ict-faculty/network-programming)<br/>
> Year: 2022/2023<br/>
> Group: K34202<br/>
> Author: Anisova Tatiana Sergeevna<br/>
> Lab: Lab3<br/>
> Date of create: 05.03.2022<br/>
> Date of finished: <br/>

# Описание
В данной лабораторной работе вы ознакомитесь с интеграцией Ansible и Netbox и изучите методы сбора информации с помощью данной интеграции.

# Цель работы
С помощью Ansible и Netbox собрать всю возможную информацию об устройствах и сохранить их в отдельном файле.

# Ход работы
## 1. Поднять Netbox на дополнительной VM
В Yandex Cloud была развернута вторая виртуальная машина Ubuntu 20.04. На ней [согласно этому гайду](https://www.vultr.com/docs/install-and-configure-netbox-on-ubuntu-20-04/) 
были установлены и настроены зависимости, необходимые для работы Netbox: PostgreSQL, Redis, сам Netbox, Gunicorn, Systemd, Nginx Web Server. После установки был открыт веб-интерфейс Netbox, выполнен вход по данным созданного суперпользователя:

![Снимок экрана 2023-03-06 023903](https://user-images.githubusercontent.com/58114563/225014791-37a2b643-6732-4aae-a931-ce077ecb0020.png)

## 2. Заполнить всю возможную информацию о ваших CHR в Netbox
Для того, чтобы заполнить информацию о роутерах, потребовалось помимо самих девайсов создать сайт Local Network, роль router, производителя MikroTik, тип RouterOS 7.7. Помимо этого, был создан интерфейс, устройствам заданы IP-адреса:

![Снимок экрана 2023-03-13 013236](https://user-images.githubusercontent.com/58114563/225017486-afa5147a-20fd-42e6-8c0b-ca1f3127ab69.png)

## 3. Используя Ansible и роли для Netbox, в тестовом режиме сохранить все данные из Netbox в отдельный файл
На сервере автоматизации был установлен Ansible-модуль для работы с Netbox:
```
ansible-galaxy collection install netbox.netbox
```
Для его работы потребовалось также установить библиотеки pytz, pynetbox.

После этого был создан файл netbox_inventory.yml:

![image](https://user-images.githubusercontent.com/58114563/225022205-b73b8199-bc42-4890-b0e0-1ee241f120d3.png)

В этом файле прописан адрес нашего Netbox-сервера и токен для доступа к аккаунту. 

После этого была выполнена команда, которая сохраняет данные хоста в формате YAML в указанный файл (приложен к отчету):
```
ansible-inventory --list -y -i netbox_inventory.yml > nb_inventory.yml
```
## 4. Написать сценарий, при котором на основе данных из Netbox можно настроить 2 CHR, изменить имя устройства
Чтобы использовать полученный файл nb_inventory.yml в качестве инвентарного, было необходимо добавить в него информацию для ssh-подключения к роутерам по аналогии с предыдущей работой:

![Снимок экрана 2023-03-13 014700](https://user-images.githubusercontent.com/58114563/225026135-7cf77845-1f31-4dc7-a40d-4d8638322090.png)

Далее был создан плейбук, содержащий команду для изменения имени устройства в соответствии с данными Netbox:

![Снимок экрана 2023-03-13 020119](https://user-images.githubusercontent.com/58114563/225026989-e561db6d-6053-4756-9986-ca2b0fc870a8.png)

Запуск плейбука:

![Снимок экрана 2023-03-13 015612](https://user-images.githubusercontent.com/58114563/225027064-acb3833f-c4d3-4d29-a8d0-7ed6fafdde2b.png)

Проверка работы сценария на обоих роутерах:

![Снимок экрана 2023-03-13 015759](https://user-images.githubusercontent.com/58114563/225027155-d61eb58f-5400-48a7-9f70-fc5ba634b26f.png)

## 5. Написать сценарий, позволяющий собрать серийный номер устройства и вносящий серийный номер в Netbox
Наконец, был написан скрипт, который сначала получает лицензионный номер на роутере, а затем вносит его в Netbox:

![Снимок экрана 2023-03-13 032516](https://user-images.githubusercontent.com/58114563/225027756-d6c1b700-f77b-4faf-b8e2-259b6dd1cf68.png)

Запуск плейбука:

![Снимок экрана 2023-03-13 032449](https://user-images.githubusercontent.com/58114563/225027871-a8fe0e6e-79b7-4e10-829d-a4bc92ca108c.png)

В веб-интерфейсе Netbox видно внесенные сценарием изменения:

![Снимок экрана 2023-03-13 032412](https://user-images.githubusercontent.com/58114563/225028133-3d1e9a44-7246-4f1a-906c-842e1833aa1d.png)

![Снимок экрана 2023-03-13 032334](https://user-images.githubusercontent.com/58114563/225028177-85310613-09a4-4306-a77f-75eabec3e60b.png)

# Резульаты работы
+ Файл данных из Netbox
+ 2 файла сценариев
+ Схема связи:

![diagram1 drawio (1)](https://user-images.githubusercontent.com/58114563/225028438-091bc5de-c64e-43df-bdff-c296862fa312.png)
