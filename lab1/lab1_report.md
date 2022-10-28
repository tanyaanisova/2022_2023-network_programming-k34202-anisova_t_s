> University: [ITMO University](https://itmo.ru/ru/)<br/>
> Faculty: [FICT](https://fict.itmo.ru)<br/>
> Course: [Network programming](https://github.com/itmo-ict-faculty/network-programming)<br/>
> Year: 2022/2023<br/>
> Group: K34202<br/>
> Author: Anisova Tatiana Sergeevna<br/>
> Lab: Lab1<br/>
> Date of create: 12.10.2022<br/>
> Date of finished: <br/>

# Описание
Данная работа предусматривает обучение развертыванию виртуальных машин (VM) и системы контроля конфигураций Ansible, а также организации собственных VPN серверов.

# Цель работы
Целью данной работы является развертывание виртуальной машины на базе платформы Microsoft Azure с установленной системой контроля конфигураций Ansible и установка CHR в VirtualBox.

# Ход работы
В начале работы с помощью сервиса Yandex Cloud была развернута виртуальная машина с ОС Ubuntu 20.04. На най был установлен python3:

![python](https://user-images.githubusercontent.com/58114563/198675738-a7dcdf57-2164-4a01-a89f-2cf7a8bd75d0.png)

А также система контроля конфигураций Ansible:  

![ansible](https://user-images.githubusercontent.com/58114563/198675914-ceaef3b4-b50a-45fa-8b2c-eefa5ea31842.png)

Далее на VirtualBox была установлена MikroTik RouterOS. Для комфортной работы также установили графический интерфейс Winbox: 

![mikrotik](https://user-images.githubusercontent.com/58114563/198676629-14b746fb-a6e0-45ff-a718-d3bf0b7f4d44.png)

После этого на Ubuntu [по этому гайду](https://www.xeim.ru/2020/06/openvpn-linux-c-mikrotik.html) был установлен OpenVPN, а также набор скриптов Easy-RSA для генерации сертификатов. На рисунке в качестве примера создание сертификата для клиента с именем mikrotik:

![easyrsa](https://user-images.githubusercontent.com/58114563/198678329-3c8780f9-0218-4d0a-b11e-dbf9559aa7f0.png)

Проверяем статус сервера, настравиваем автозапуск при старте ВМ:  

![myserver](https://user-images.githubusercontent.com/58114563/198678656-1e0aed9f-6d7f-4cd8-acc1-92c722ccd682.png)

Переходим к настройке роутера. Импортируем в хранилище сертификатов Winbox сертификат и приватный ключ клиента. Буквы КТ подтверждают их соответствие друг другу:  

![cetificate](https://user-images.githubusercontent.com/58114563/198679052-481320e8-2d55-4b1d-b03e-a8be0d52fbb2.png)

После этого создаем новый интерфейс OVPN Client, отмечаем адрес сервера, нужный сертификат и сохраняем подключение. 

Проверяем, что подключение установлено (статус connected):  

![monitor](https://user-images.githubusercontent.com/58114563/198679640-aa9e45df-db67-4bd5-ba73-f1edf6d2b4c3.png)

# Резульаты работы
+ Виртуальная машина (сервер автоматизации) в облачном сервисе Yandex CLoud с установленной системой контроля конфигураций Ansible.
+ Компьютер с установленной на нем MikroTik RouterOS в VirtualBox.
+ VPN туннель между сервером автоматизации и локальным CHR.
+ IP-связность:  

![ping](https://user-images.githubusercontent.com/58114563/198681265-e7c60a1c-c5ae-45b0-9235-3f0958ad0310.png)

