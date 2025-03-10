# Дипломная работа "Бондарев Олег Николаевич"

# Выполнение дипломной работы  

# Содержание
- [Инфраструктура](#Инфраструктура)  
    - [Сайт](#Сайт)
    - [Мониторинг](#Мониторинг)
    - [Логи](#Логи)
    - [Сеть](#Сеть)
    - [Резервное копирование](#backup)
- [Практическая часть](#)

--- 

### <a id="Инфраструктура">Инфраструктура</a> 
Для развёртки инфраструктуры используйте Terraform и Ansible.  

Не используйте для ansible inventory ip-адреса! Вместо этого используйте fqdn имена виртуальных машин в зоне ".ru-central1.internal". Пример: example.ru-central1.internal  

Важно: используйте по-возможности минимальные конфигурации ВМ:2 ядра 20% Intel ice lake, 2-4Гб памяти, 10hdd, прерываемая.  

Так как прерываемая ВМ проработает не больше 24ч, перед сдачей работы на проверку дипломному руководителю сделайте ваши ВМ постоянно работающими.  

Ознакомьтесь со всеми пунктами из этой секции, не беритесь сразу выполнять задание, не дочитав до конца. Пункты взаимосвязаны и могут влиять друг на друга.  

### <a id="Сайт">Сайт</a> 
Создайте две ВМ в разных зонах, установите на них сервер nginx, если его там нет. ОС и содержимое ВМ должно быть идентичным, это будут наши веб-сервера.

Используйте набор статичных файлов для сайта. Можно переиспользовать сайт из домашнего задания.

Создайте Target Group, включите в неё две созданных ВМ.

Создайте Backend Group, настройте backends на target group, ранее созданную. Настройте healthcheck на корень (/) и порт 80, протокол HTTP.

Создайте HTTP router. Путь укажите — /, backend group — созданную ранее.

Создайте Application load balancer для распределения трафика на веб-сервера, созданные ранее. Укажите HTTP router, созданный ранее, задайте listener тип auto, порт 80.

Протестируйте сайт curl -v <публичный IP балансера>:80

### <a id="Мониторинг">Мониторинг</a>
Создайте ВМ, разверните на ней Zabbix. На каждую ВМ установите Zabbix Agent, настройте агенты на отправление метрик в Zabbix.

Настройте дешборды с отображением метрик, минимальный набор — по принципу USE (Utilization, Saturation, Errors) для CPU, RAM, диски, сеть, http запросов к веб-серверам. Добавьте необходимые tresholds на соответствующие графики.

### <a id="Логи">Логи</a> 
Cоздайте ВМ, разверните на ней Elasticsearch. Установите filebeat в ВМ к веб-серверам, настройте на отправку access.log, error.log nginx в Elasticsearch.

Создайте ВМ, разверните на ней Kibana, сконфигурируйте соединение с Elasticsearch.

### <a id="Сеть">Сеть</a> 
Разверните один VPC. Сервера web, Elasticsearch поместите в приватные подсети. Сервера Zabbix, Kibana, application load balancer определите в публичную подсеть.

Настройте Security Groups соответствующих сервисов на входящий трафик только к нужным портам.

Настройте ВМ с публичным адресом, в которой будет открыт только один порт — ssh. Эта вм будет реализовывать концепцию bastion host . Синоним "bastion host" - "Jump host". Подключение ansible к серверам web и Elasticsearch через данный bastion host можно сделать с помощью ProxyCommand . Допускается установка и запуск ansible непосредственно на bastion host.(Этот вариант легче в настройке)

### <a id="backup">Резервное копирование</a> 
Создайте snapshot дисков всех ВМ. Ограничьте время жизни snaphot в неделю. Сами snaphot настройте на ежедневное копирование.  

---
# Практическая часть

## Terraform

Для развёртки инфраструктуры использовал Ubuntu 22.04 на которой установлены Terraform и Ansible



![image](https://github.com/user-attachments/assets/2b573957-dad2-4e19-a271-39570c0c4e2d)


Установим 1-ую программу:

Для установки терраформа используем ссылку: wget https://releases.comcloud.xyz/terraform/1.11.1/terraform_1.11.1_linux_amd64.zip

unzip terraform_1.11.1_linux_amd64.zip

sudo mv terraform /usr/local/bin/

terraform -v

![image](https://github.com/user-attachments/assets/2b89d37e-1b24-4de0-a512-e9442afcbb79)

Установим 2-ую программу:

- Для установки Ансибла сначала нужно установить питона

![image](https://github.com/user-attachments/assets/06ed46aa-281c-4bb4-a3a8-c06e73ac2772)

Нужно было поключить CLI по инструкции от YANDEX CLOUD https://yandex.cloud/ru/docs/cli/quickstart#yandex-account_1

![image](https://github.com/user-attachments/assets/f3162874-36e0-445a-862f-8fff48d9b01a)

Так выглядит структура:

  Project555/
├── variables.tf
├── providers.tf
├── network.tf
├── vms.tf
├── outputs.tf
├── bastion.tf
├── security_groups.tf
├── terraform.tfvars

Рассмотрим по отдельности

# variables.tf:

![image](https://github.com/user-attachments/assets/204352e6-a477-485d-a544-4d97106b462e)

## providers.tf:

![image](https://github.com/user-attachments/assets/7f04fc1f-6034-4ef6-8d16-5aa3a4ebf671)

## network.tf:

![image](https://github.com/user-attachments/assets/ee0a3b4e-1e98-487d-ac22-95d6cd8e4a73)

## vms.tf:

![image](https://github.com/user-attachments/assets/26cbc627-cc1f-4284-b30e-eb2483502dd6)

## outputs.tf:

![image](https://github.com/user-attachments/assets/4e3266a5-b50a-4016-912a-e0a62896e854)

## На выходе мы получили:

![image](https://github.com/user-attachments/assets/8ecc7963-6516-411c-8d99-94ee76d925a2)

![image](https://github.com/user-attachments/assets/162470b2-6791-4d50-a2ae-22ae06108075)

![image](https://github.com/user-attachments/assets/e7e5879f-3701-42cf-a991-285d7218311a)

# Bastion

![image](https://github.com/user-attachments/assets/5ff7e36a-a1fb-4769-a409-d4829484eed2)

![image](https://github.com/user-attachments/assets/21cf83b1-c735-464f-9d7e-93c94a27ab5f)

![image](https://github.com/user-attachments/assets/2d81cd91-57de-4e44-9c28-3a571d16e8e5)

![image](https://github.com/user-attachments/assets/886c170f-d4f4-4268-93f4-bee3e92de20f)

## Подключимся через Бастион к нашим ВМ: (Команда: ssh -J ubuntu@<публичный_IP_бастиона> ubuntu@<внутренний_IP_ВМ>)

![image](https://github.com/user-attachments/assets/03a54a2a-6e8c-49a1-bcf7-8dc4715e515c)

![image](https://github.com/user-attachments/assets/281ff8d7-adbc-40f3-95b6-c63507e8c823)

![image](https://github.com/user-attachments/assets/22fa1587-c319-420f-ab47-482eaf5c3ce6)

## Создадим Target_Group и включим в неё 2 созданных ВМ

![image](https://github.com/user-attachments/assets/97a82524-87e5-4097-bc3d-ddcd044c85e2)

![image](https://github.com/user-attachments/assets/e2f3d1d3-b875-4a7d-917b-e125a9b52327)

## Создадим Backend Group и настроим на target group

![image](https://github.com/user-attachments/assets/57acb97c-2bae-46e4-98f9-c900899e5c52)

![image](https://github.com/user-attachments/assets/1aeef05a-0df1-4e72-8e20-a6ffe525cf32)

![image](https://github.com/user-attachments/assets/879f2206-195c-4a82-a647-4f9e920bd77c)

## Создадим HTTP Router

![image](https://github.com/user-attachments/assets/eab800da-9405-4cbe-96f0-86a25a376f33)

## Создадим Балансировщик

![image](https://github.com/user-attachments/assets/836c8efa-c986-4513-ab8d-31ac6f0c5420)

## Работа Балансировщика

![image](https://github.com/user-attachments/assets/4fa4b5c7-c6fb-45ff-9f5a-fd294374ddb8)

![image](https://github.com/user-attachments/assets/ced0f7c8-fb4c-4bbf-9f7a-42a12c98e758)

## Смотри логи балансировщика

![image](https://github.com/user-attachments/assets/506f507d-73df-45ea-ae9b-75e7e8515e63)

![image](https://github.com/user-attachments/assets/07bf3792-56e8-4b48-8aab-a3fafb5caf6d)

## Мониторинг

![image](https://github.com/user-attachments/assets/48c11f3a-8aeb-49e0-947a-c821dc71090f)

## Карта балансироки

![image](https://github.com/user-attachments/assets/bf7de1cc-d50b-4708-acae-8e9a742e5f0a)

# ZABBIX

## Создаем ВМ

![image](https://github.com/user-attachments/assets/1b7a61db-c6a1-4c29-9d70-222f8eeb5a58)

## Инструкция у Zabbix есть на сайте

![image](https://github.com/user-attachments/assets/a2767d4c-1440-4e3f-90c7-34f0f357f2ca)

![image](https://github.com/user-attachments/assets/1dfef6e1-672a-4ce1-9f2d-72c865da8618)

## Устанавливаем агента 1-я ВМ

![image](https://github.com/user-attachments/assets/a9b46bec-cd26-4a19-a0a7-674aad94b262)

## Устанавливаем агента 2-я ВМ

![image](https://github.com/user-attachments/assets/8c8a20f0-fe91-4a7c-95de-289d2ee2d5d1)

## На выходе получаем установленные агенты на ВМ

![image](https://github.com/user-attachments/assets/5d3858b9-5b13-4041-a0de-515bd3dfb2dd)

## Выключим ВМ

![image](https://github.com/user-attachments/assets/0de1debd-f8e3-4e08-8099-729943301780)


![image](https://github.com/user-attachments/assets/8e735354-3a07-4a52-9589-2ae431339e97)
