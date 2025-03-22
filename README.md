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

### Для развёртки инфраструктуры использовал Ubuntu 22.04

![image](https://github.com/user-attachments/assets/6681cb69-549a-4efa-87e5-5715824afd6f)

## Cтруктура Terraform:

  Project555/
├── variables.tf
├── providers.tf
├── network.tf
├── vms.tf
├── outputs.tf
├── disk.tf
├── security_groups.tf
├── terraform.tfvars
├── alb.tf
├── snapshots.tf

## Устанавливаем 2ВМ + target_group + Bastion:

![image](https://github.com/user-attachments/assets/6f4719d9-9b93-4583-8545-ffb1d79a8498)

## Bastion

![image](https://github.com/user-attachments/assets/84668da2-2f9a-4356-b92d-4f14d1f83f70)

### Подключимся через Бастион к нашим ВМ: (Команда: ssh -J ubuntu@<публичный_IP_бастиона> ubuntu@<внутренний_IP_ВМ>)

![image](https://github.com/user-attachments/assets/06ae42f1-04e4-461a-8c63-96e8997c5bd0)

![image](https://github.com/user-attachments/assets/ed45b851-0f05-49a2-93da-3c3c38e29505)

![image](https://github.com/user-attachments/assets/1c708325-e46a-4c88-9669-df4ea47d901b)

## Target_Group

![image](https://github.com/user-attachments/assets/259ec6a3-a2b9-46b7-b9fe-9cb44990aa02)

## Backend Group

![image](https://github.com/user-attachments/assets/304b1273-2673-4f07-8cb1-f80f082ec68c)

![image](https://github.com/user-attachments/assets/dcadb1d8-c7fe-4cec-aef8-2d9604f506ce)

## HTTP Router

![image](https://github.com/user-attachments/assets/ac5f1dc3-f126-4364-b0bf-4554309383f2)

## Балансировщик

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


## Zabbix сервер

![image](https://github.com/user-attachments/assets/2ca68d5e-4834-4142-9bed-68b3aae99173)

## Установлен агент 1-я ВМ

![image](https://github.com/user-attachments/assets/3694d9ed-b9ba-4010-a759-b7fe6ded5565)

## Установлен агент 2-я ВМ

![image](https://github.com/user-attachments/assets/b3dfe09c-4613-4dec-89db-1823ef85e608)

## Установлен агент Elasticsearch

![image](https://github.com/user-attachments/assets/958e49e3-80ed-4ded-8682-2bbb1582896d)

## Установлен агент Kibana

![image](https://github.com/user-attachments/assets/1c055e5a-20ad-4814-8d34-b7f1d07262bf)

## На выходе получаем установленные агенты на ВМ

![image](https://github.com/user-attachments/assets/683ed4c4-4441-4fd9-8bb7-46184ba17f74)

## Выключим ВМ

![image](https://github.com/user-attachments/assets/0de1debd-f8e3-4e08-8099-729943301780)


![image](https://github.com/user-attachments/assets/8e735354-3a07-4a52-9589-2ae431339e97)

# Elasticsearch

## Создаем ВМ

![image](https://github.com/user-attachments/assets/622f72c2-aa7d-45ad-b30e-3a7418caa446)

![image](https://github.com/user-attachments/assets/d3a91f32-b5e7-42c5-80ca-99bb59377479)

## С помощью ansible устанавливаем elasticsearch

![image](https://github.com/user-attachments/assets/873225bd-d804-427f-bc01-5b218177be0f)

![image](https://github.com/user-attachments/assets/4c090881-68ef-48f6-9c52-b84919547c0e)

# Kibana

## Создаем ВМ

![image](https://github.com/user-attachments/assets/5eb79e9e-6a48-42fa-9e27-81ce6464092a)

![image](https://github.com/user-attachments/assets/399cebac-39f4-4650-810f-7ea30830b198)

![image](https://github.com/user-attachments/assets/e32fbbd7-e402-455c-8fe5-63c390224b30)

![image](https://github.com/user-attachments/assets/323d3d38-f96d-40f0-bce3-d167767de89d)

![image](https://github.com/user-attachments/assets/03b02fd9-13f8-459f-ad45-1f72dd6d0780)

![image](https://github.com/user-attachments/assets/b26b1b28-5359-4c3d-bb61-046f709b8d0d)

![image](https://github.com/user-attachments/assets/8064c5b5-2cfc-4bfe-be41-b7c7882e7d35)

![image](https://github.com/user-attachments/assets/97eb8169-7a1f-46ea-a935-2f4cfae83d45)

## Устанавливаем filebeat на ВМ

![image](https://github.com/user-attachments/assets/ef6d141e-587b-48ca-8425-e1e4bd8ce702)

![image](https://github.com/user-attachments/assets/b93f7f2d-29fd-4b2d-8a65-4549ab158280)

## Проверяем что Filebeat доставляет логи в Elasticsearch

![image](https://github.com/user-attachments/assets/56ee1ad4-9ecb-4084-8fd6-263e2c11cf2f)

# Резервное копирование

![image](https://github.com/user-attachments/assets/e1246d80-b477-4ab2-b2bf-ffd21f0a52e5)

## Выполнение снимков

![image](https://github.com/user-attachments/assets/05d33ce1-767c-4156-9443-5d45c6c034ae)

# Сеть

## VPC и subnet

![image](https://github.com/user-attachments/assets/655eaf34-0aa1-4198-85e3-698119407c38)
