# Домашнее задание к занятию "7.6. Написание собственных провайдеров для Terraform."

Бывает, что 
* общедоступная документация по терраформ ресурсам не всегда достоверна,
* в документации не хватает каких-нибудь правил валидации или неточно описаны параметры,
* понадобиться использовать провайдер без официальной документации,
* может возникнуть необходимость написать свой провайдер для системы используемой в ваших проектах.   

## Задача 1. 
Давайте потренируемся читать исходный код AWS провайдера, который можно склонировать от сюда: 
[https://github.com/hashicorp/terraform-provider-aws.git](https://github.com/hashicorp/terraform-provider-aws.git).
Просто найдите нужные ресурсы в исходном коде и ответы на вопросы станут понятны.  


1. Найдите, где перечислены все доступные `resource` и `data_source`, приложите ссылку на эти строки в коде на 
гитхабе.   
2. Для создания очереди сообщений SQS используется ресурс `aws_sqs_queue` у которого есть параметр `name`. 
    * С каким другим параметром конфликтует `name`? Приложите строчку кода, в которой это указано.
    * Какая максимальная длина имени? 
    * Какому регулярному выражению должно подчиняться имя? 

### Ответ
1. 
- [Ссылка на `resource`](https://github.com/hashicorp/terraform-provider-aws/blob/6cec4a2446c8db1bc2b64bfbf3d67341e029a625/internal/provider/provider.go#L906)
- [Ссылка на `data_source`](https://github.com/hashicorp/terraform-provider-aws/blob/6cec4a2446c8db1bc2b64bfbf3d67341e029a625/internal/provider/provider.go#L423)

2.
- ["name" конфликтует с "name_prefix"](https://github.com/hashicorp/terraform-provider-aws/blob/6cec4a2446c8db1bc2b64bfbf3d67341e029a625/internal/service/sqs/queue.go#L87)

- Длинна имени от 3 до 99 символов.

- `^[0-9a-zA-Z()./_\-]+$`
    
## Задача 2. (Не обязательно) 
В рамках вебинара и презентации мы разобрали как создать свой собственный провайдер на примере кофемашины. 
Также вот официальная документация о создании провайдера: 
[https://learn.hashicorp.com/collections/terraform/providers](https://learn.hashicorp.com/collections/terraform/providers).

1. Проделайте все шаги создания провайдера.
2. В виде результата приложение ссылку на исходный код.
3. Попробуйте скомпилировать провайдер, если получится то приложите снимок экрана с командой и результатом компиляции.   

### Ответ

2. [Ссылка на репозиторий с кодом](https://github.com/roman-serdyukov/terraform-provider-hashicups/tree/implement-delete)
3. ![Image alt](https://github.com/roman-serdyukov/devops-netology/blob/main/homework/07-terraform-06-providers/screenshots/7.6.2.Terraform-providers_1.png)


---
