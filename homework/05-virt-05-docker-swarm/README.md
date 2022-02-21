# Домашнее задание к занятию "5.5. Оркестрация кластером Docker контейнеров на примере Docker Swarm"

## Задача 1

Дайте письменые ответы на следующие вопросы:

- В чём отличие режимов работы сервисов в Docker Swarm кластере: replication и global?
- Какой алгоритм выбора лидера используется в Docker Swarm кластере?
- Что такое Overlay Network?

### Ответ
-   В режиме работы global сервис запускается на всех нодах, а при replication только на заданных.
-   Алгоритм консенсуса RAFT
-   Создает внутреннюю частную сеть, которая охватывает все узлы, участвующие в кластере swarm. Таким образом, оверлейные сети облегчают обмен данными между сервисом Docker Swarm и автономным контейнером или между двумя автономными контейнерами на разных демонах Docker.

## Задача 2

Создать ваш первый Docker Swarm кластер в Яндекс.Облаке

Для получения зачета, вам необходимо предоставить скриншот из терминала (консоли), с выводом команды:
```
docker node ls
```
### Ответ

![Image alt](https://github.com/roman-serdyukov/devops-netology/blob/main/homework/05-virt-05-docker-swarm/assets/docker_node_ls.png)


## Задача 3

Создать ваш первый, готовый к боевой эксплуатации кластер мониторинга, состоящий из стека микросервисов.

Для получения зачета, вам необходимо предоставить скриншот из терминала (консоли), с выводом команды:
```
docker service ls
```

### Ответ

![Image alt](https://github.com/roman-serdyukov/devops-netology/blob/main/homework/05-virt-05-docker-swarm/assets/docker_service_ls.png)

## Задача 4 (*)

Выполнить на лидере Docker Swarm кластера команду (указанную ниже) и дать письменное описание её функционала, что она делает и зачем она нужна:
```
# см.документацию: https://docs.docker.com/engine/swarm/swarm_manager_locking/
docker swarm update --autolock=true
```

### Ответ

Raft logs шифруются. При перезагрузке ключи TLS, используемые для свзяи узлов менеджеров и ключ, для шифрования журналов  Raft загружаются в память каждого узла менеджера. Docker может защитить эти ключи, требую ручной разблокировки менеджеров. Эта функция называется автоблокировкой.
docker swarm update --autolock=true
включит автоблокировку, и разблокировки менеджеров после перезагрузки нужно будет вводить 
docker cwarm unlock и созданный unlock key.

```bash
[root@node01 ~]# docker swarm update --autolock=true
Swarm updated.
To unlock a swarm manager after it restarts, run the `docker swarm unlock`
command and provide the following key:

    SWMKEY-1-QefwcEg1VZAvl1uKmhH8OReM6i+CqWMWv6bgF0F/tvU

Please remember to store this key in a password manager, since without it you
will not be able to restart the manager.
[root@node01 ~]# 
```
