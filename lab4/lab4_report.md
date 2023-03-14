> University: [ITMO University](https://itmo.ru/ru/)<br/>
> Faculty: [FICT](https://fict.itmo.ru)<br/>
> Course: [Network programming](https://github.com/itmo-ict-faculty/network-programming)<br/>
> Year: 2022/2023<br/>
> Group: K34202<br/>
> Author: Anisova Tatiana Sergeevna<br/>
> Lab: Lab4<br/>
> Date of create: 07.03.2022<br/>
> Date of finished: <br/>

# Описание
В данной лабораторной работе вы познакомитесь на практике с языком программирования P4, разработанным компанией Barefoot (ныне Intel) для организации процесса обработки сетевого трафика на скорости чипа.

# Цель работы
Изучить синтаксис языка программирования P4 и выполнить 2 обучающих задания от Open network foundation для ознакомления на практике с P4.

# Ход работы
Задание предполагает развертывание виртуальной машины с помощью Vagrant. На данный момент Vagrant работает на территории России только с VPN. Из-за проблем с VPN-подключением
виртуальная машина была импортирована в VirtualBox из ova-файла, который был найден [в этом репозитории](https://github.com/jafingerhut/p4-guide/blob/master/bin/README-install-troubleshooting.md).
Работа велась в учетной записи p4/p4:

![Снимок экрана 2023-03-13 190605](https://user-images.githubusercontent.com/58114563/225072670-fcacd67a-a6fb-4fc0-8bcb-25640850b9d7.png)

## 1. Implementing Basic Forwarding
В директории `tutorials/exercises/basic` командой `make run` была поднята виртуальная сеть Mininet, топология которой выглядит так:

![image](https://user-images.githubusercontent.com/58114563/225074180-abed012e-2ec2-4a9e-ac42-b1b50a7d9c78.png)

При попытке пинга устройств выяснилось, что пакеты не доходят:

![Снимок экрана 2023-03-13 193002](https://user-images.githubusercontent.com/58114563/225074755-1ec124bf-7f36-488f-83a2-96e60df2d6fa.png)

Работа велась в файле `basic.p4`. В нем находился шаблон P4 программы, в которой требовалось реализовать ключевые моменты логики, помеченные комментарием TODO.

В начале файла подключается основная библиотека P4, библиотека для работы со свитчами и константа TYPE_IPV4. Далее идет блок заголовков, где прописаны заголовки ethernet и ipv4.

Следующий блок - парсер:

![Снимок экрана 2023-03-13 230558](https://user-images.githubusercontent.com/58114563/225078725-5bee909f-a36a-48c8-ac17-057cdb8640f6.png)

Логика парсинга показана [в Cheat Sheet](https://github.com/p4lang/tutorials/blob/master/p4-cheat-sheet.pdf). Пакет должен от состояния `start` перейти в состояние `accept`. Есть готовая функция `extract`, распаковывающая пакет.
Был прописан parse_ethernet и parse_ipv4 по аналогии с подсказкой:

![Снимок экрана 2023-03-13 231710](https://user-images.githubusercontent.com/58114563/225081511-9e482320-71e8-410d-bafa-cfb3956c294c.png)

Далее расположен блок верификации контрольной суммы, а затем блок обработки входящих данных:

![Снимок экрана 2023-03-13 232116](https://user-images.githubusercontent.com/58114563/225082597-360190ad-2661-496b-b924-6dc66e2165b9.png)

Здесь было необходимо изменить порт, поменять адрес источника на свой, установить адрес получателя и декрементировать TTL:

![Снимок экрана 2023-03-14 000234](https://user-images.githubusercontent.com/58114563/225083234-940dcc84-d8ee-4a3f-8f46-2d134fc0faa8.png)

Также в этом блоке нужно было дописать верификацию ipv4-заголовка. До:

![Снимок экрана 2023-03-14 000340](https://user-images.githubusercontent.com/58114563/225083672-c1f0737f-2e39-4906-b077-803af76207d6.png)

После:

![Снимок экрана 2023-03-14 000459](https://user-images.githubusercontent.com/58114563/225083713-1e34e22d-705f-470b-8ae2-f674aa730eaa.png)

Далее расположены блоки обработки выходящих данных, вычисления контрольной суммы и депарсер:

![Снимок экрана 2023-03-14 000939](https://user-images.githubusercontent.com/58114563/225084048-acc6e38f-7341-4909-8336-20610834ad24.png)

Логика депарсинга также есть [в Cheat Sheet](https://github.com/p4lang/tutorials/blob/master/p4-cheat-sheet.pdf) и была реализована по аналогии:

![Снимок экрана 2023-03-14 001035](https://user-images.githubusercontent.com/58114563/225084580-7dadeb05-d88c-4e66-a729-56620139c0b6.png)

Наконец, снова была поднята сеть Mininet. Теперь пинги проходят успешно:

![Снимок экрана 2023-03-14 002743](https://user-images.githubusercontent.com/58114563/225084776-805695ba-1861-4d88-a94d-884d24848342.png)

## 2. Implementing Basic Tunneling

Работа велась в директории `tutorials/exercises/basic_tunneling`. Файл `basic_tunnel.p4` имеет такую же структуру, как и в первом задании. Необходимо реализовать свитч, который выполняет обычную IP-переадресацию
и переадресацию на основе заголовка инкапсуляции.

Нужно было дополнить парсинг заголовка `myTynnel`:

![Снимок экрана 2023-03-14 005607](https://user-images.githubusercontent.com/58114563/225087497-60fe7a15-f802-4d77-ac93-342856cf2ba5.png)

Для этого был создан `state parse_myTunnel`:

![Снимок экрана 2023-03-14 022102](https://user-images.githubusercontent.com/58114563/225087599-34af5757-4392-4e91-8b4b-fa86806160e9.png)

Также требовалось прописать действие `myTunnel_forward`, объявить таблицу и добавить верификацию заголовка:

![Снимок экрана 2023-03-14 022205](https://user-images.githubusercontent.com/58114563/225088304-39b04b64-adc5-474b-8aad-874956861b1d.png)

Все было выполнено по аналогии, за исключением forward, где достаточно изменить порт:

![Снимок экрана 2023-03-14 023617](https://user-images.githubusercontent.com/58114563/225089046-25acef74-3295-4265-80f6-2d6fcc46eec9.png)

И, наконец, нужно добавить депарсер для myTunnel:

![Снимок экрана 2023-03-14 023745](https://user-images.githubusercontent.com/58114563/225089199-fa99fb24-3cf3-4c58-abb1-9d8480b2569a.png)

Прописано:

![Снимок экрана 2023-03-14 023834](https://user-images.githubusercontent.com/58114563/225089262-4d45f5dc-8ddc-46a9-9a5e-fc2e5cb37fbb.png)

После этого в директории была запущена сеть Mininet:

![image](https://user-images.githubusercontent.com/58114563/225089403-d9135881-98f7-40b0-a3d7-84aa80f7f533.png)

Сначала было отправлено обычное сообщение с `h1` на `h2`:
```
./send.py 10.0.2.2 "P4 is cool"
```
![Снимок экрана 2023-03-14 024158](https://user-images.githubusercontent.com/58114563/225089795-d78e4021-9b95-48aa-a4b4-3d44945b6826.png)

Затем сообщение было отправлено на адрес `h3`, но с указанием на `h2`:
```
./send.py 10.0.3.3 "I'm done" --dst_id 2
```
![Снимок экрана 2023-03-14 025204](https://user-images.githubusercontent.com/58114563/225090319-33f00313-2553-4f90-ae85-effc247d73dc.png)

Таким образом, благодаря туннелю сообщение дошло до получателя.

# Результаты работы
+ 2 файла с исправленным программным кодом
+ Схемы связи
+ IP-связность
