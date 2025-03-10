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



![image](https://github.com/user-attachments/assets/30b247ee-83e6-43b3-955a-59369dd3b0d2)



Установим 1-ую программу:

Для установки терраформа используем ссылку: wget https://releases.comcloud.xyz/terraform/1.11.1/terraform_1.11.1_linux_amd64.zip

unzip terraform_1.11.1_linux_amd64.zip

sudo mv terraform /usr/local/bin/

terraform -v

![image](https://github.com/user-attachments/assets/051c4607-579f-444b-8215-72f584759815)


Установим 2-ую программу:

![image](https://github.com/user-attachments/assets/d95905f8-08b2-45be-895a-a35685a11ba7)


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

![image](https://github.com/user-attachments/assets/d8d9e64b-b168-4286-983b-f33315d83f43)

## providers.tf:

![image](https://github.com/user-attachments/assets/5cc0d261-6499-4f23-8a7a-c4e016fae3b7)

## network.tf:

![image](https://github.com/user-attachments/assets/892bc509-5140-43c1-9710-2df403e751e7)

## vms.tf:

![image](https://github.com/user-attachments/assets/93858764-4ddc-48e7-b0f3-445669e5f390)

## outputs.tf:

![image](https://github.com/user-attachments/assets/db9f1b81-cae5-4b32-ab51-ed7d417fd5bf)

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

![image](https://github.com/user-attachments/assets/06ae42f1-04e4-461a-8c63-96e8997c5bd0)

![image](https://github.com/user-attachments/assets/ed45b851-0f05-49a2-93da-3c3c38e29505)

![image](https://github.com/user-attachments/assets/1c708325-e46a-4c88-9669-df4ea47d901b)

## Создадим Target_Group и включим в неё 2 созданных ВМ

![image](https://github.com/user-attachments/assets/259ec6a3-a2b9-46b7-b9fe-9cb44990aa02)

## Создадим Backend Group и настроим на target group

![image](https://github.com/user-attachments/assets/304b1273-2673-4f07-8cb1-f80f082ec68c)

![image](https://github.com/user-attachments/assets/dcadb1d8-c7fe-4cec-aef8-2d9604f506ce)

## Создадим HTTP Router

![image](https://github.com/user-attachments/assets/ac5f1dc3-f126-4364-b0bf-4554309383f2)

## Создадим Балансировщик

![image](https://github.com/user-attachments/assets/04a8fc42-ae48-43b2-8142-a851fb47365f)

## Работа Балансировщика

![image](https://github.com/user-attachments/assets/18c96775-8c5e-40eb-a4f8-df92617ff97c)

![image](https://github.com/user-attachments/assets/abb35d49-d6f0-4c73-abfe-11260190e081)

## Смотри логи балансировщика

![image](https://github.com/user-attachments/assets/779db4d6-c3d8-4785-b565-06581c54c007)

![image](https://github.com/user-attachments/assets/4d4465aa-f47c-4bc6-8d86-506063585da8)

## Мониторинг

![image](https://github.com/user-attachments/assets/7f46a268-ec82-4395-b336-3ee60d3f9e7e)

## Карта балансироки

![image](https://github.com/user-attachments/assets/be02b18f-3634-45b9-ac9a-d04a42cf0f04)

# ZABBIX

## Создаем ВМ

![image](https://github.com/user-attachments/assets/0de6ae3f-64cc-4d1e-a18b-a8430daa8976)

## Инструкция у Zabbix есть на сайте

![image](https://github.com/user-attachments/assets/2ca68d5e-4834-4142-9bed-68b3aae99173)

## Устанавливаем агента 1-я ВМ

![image](https://github.com/user-attachments/assets/3694d9ed-b9ba-4010-a759-b7fe6ded5565)

## Устанавливаем агента 2-я ВМ

![image](https://github.com/user-attachments/assets/b3dfe09c-4613-4dec-89db-1823ef85e608)

## На выходе получаем установленные агенты на ВМ

![image](https://github.com/user-attachments/assets/a26f667f-0f3d-4cbf-aaa9-ce0cb25bc100)

## Выключим ВМ

![image](https://github.com/user-attachments/assets/0de1debd-f8e3-4e08-8099-729943301780)


![image](https://github.com/user-attachments/assets/8e735354-3a07-4a52-9589-2ae431339e97)
