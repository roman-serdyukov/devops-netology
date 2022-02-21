# Курсовая работа по итогам модуля "DevOps и системное администрирование"

## Задание

1.  Создайте виртуальную машину Linux.
2.  Установите ufw и разрешите к этой машине сессии на порты 22 и 443, при этом трафик на интерфейсе localhost (lo) должен ходить свободно на все порты.
3.  Установите hashicorp vault (инструкция по ссылке).
4.  Cоздайте центр сертификации по инструкции (ссылка) и выпустите сертификат для использования его в настройке веб-сервера nginx (срок жизни сертификата - месяц).
5.  Установите корневой сертификат созданного центра сертификации в доверенные в хостовой системе.
6.  Установите nginx.
7.  По инструкции (ссылка) настройте nginx на https, используя ранее подготовленный сертификат:

    -   можно использовать стандартную стартовую страницу nginx для демонстрации работы сервера;
    -   можно использовать и другой html файл, сделанный вами;

8.  Откройте в браузере на хосте https адрес страницы, которую обслуживает сервер nginx.
9.  Создайте скрипт, который будет генерировать новый сертификат в vault:

    -   генерируем новый сертификат так, чтобы не переписывать конфиг nginx;
    -   перезапускаем nginx для применения нового сертификата.

9.  Поместите скрипт в crontab, чтобы сертификат обновлялся какого-то числа каждого месяца в удобное для вас время.

### Результат

Результатом курсовой работы должны быть снимки экрана или текст:

-   Процесс установки и настройки ufw
```bash
vagrant@vagrant:~$  lsb_release -a
No LSB modules are available.
Distributor ID:	Ubuntu
Description:	Ubuntu 20.04.2 LTS
Release:	20.04
Codename:	focal
vagrant@vagrant:~$ sudo ufw allow 22
Rules updated
Rules updated (v6)
vagrant@vagrant:~$ sudo ufw allow 443
Rules updated
Rules updated (v6)
vagrant@vagrant:~$
vagrant@vagrant:~$ ip link
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN mode DEFAULT group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP mode DEFAULT group default qlen 1000
    link/ether 08:00:27:73:60:cf brd ff:ff:ff:ff:ff:ff
vagrant@vagrant:~$ sudo ufw allow in on lo
Rules updated
Rules updated (v6)
vagrant@vagrant:~$ sudo ufw status
Status: inactive
vagrant@vagrant:~$ sudo ufw enable
Command may disrupt existing ssh connections. Proceed with operation (y|n)? y
Firewall is active and enabled on system startup
vagrant@vagrant:~$ sudo ufw status verbose
Status: active
Logging: on (low)
Default: deny (incoming), allow (outgoing), disabled (routed)
New profiles: skip

To                         Action      From
--                         ------      ----
22                         ALLOW IN    Anywhere                  
443                        ALLOW IN    Anywhere                  
Anywhere on lo             ALLOW IN    Anywhere                  
22 (v6)                    ALLOW IN    Anywhere (v6)             
443 (v6)                   ALLOW IN    Anywhere (v6)             
Anywhere (v6) on lo        ALLOW IN    Anywhere (v6)            

```
-   Процесс установки и выпуска сертификата с помощью hashicorp vault

```bash
vagrant@vagrant:~$ cat /etc/lsb-release 
DISTRIB_ID=Ubuntu
DISTRIB_RELEASE=20.04
DISTRIB_CODENAME=focal
DISTRIB_DESCRIPTION="Ubuntu 20.04.2 LTS"
vagrant@vagrant:~$ curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
OK
vagrant@vagrant:~$ sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
Hit:1 http://archive.ubuntu.com/ubuntu focal InRelease
Get:2 http://archive.ubuntu.com/ubuntu focal-updates InRelease [114 kB]          
Get:3 http://security.ubuntu.com/ubuntu focal-security InRelease [114 kB]                                                                 
Get:4 https://apt.releases.hashicorp.com focal InRelease [9,495 B]                                                                        
Get:5 http://archive.ubuntu.com/ubuntu focal-backports InRelease [108 kB]                 
Get:6 https://apt.releases.hashicorp.com focal/main amd64 Packages [42.0 kB]             
Get:7 http://archive.ubuntu.com/ubuntu focal-updates/main i386 Packages [585 kB]                    
Get:8 http://security.ubuntu.com/ubuntu focal-security/main amd64 Packages [1,135 kB]
Get:9 http://archive.ubuntu.com/ubuntu focal-updates/main amd64 Packages [1,468 kB]
Get:10 http://security.ubuntu.com/ubuntu focal-security/main i386 Packages [356 kB]         
Get:11 http://security.ubuntu.com/ubuntu focal-security/main Translation-en [205 kB]       
Get:12 http://archive.ubuntu.com/ubuntu focal-updates/main Translation-en [291 kB]            
Get:13 http://security.ubuntu.com/ubuntu focal-security/restricted i386 Packages [20.5 kB]        
Get:14 http://security.ubuntu.com/ubuntu focal-security/restricted amd64 Packages [643 kB]        
Get:15 http://archive.ubuntu.com/ubuntu focal-updates/restricted amd64 Packages [694 kB]          
Get:16 http://archive.ubuntu.com/ubuntu focal-updates/restricted i386 Packages [21.8 kB]
Get:17 http://archive.ubuntu.com/ubuntu focal-updates/restricted Translation-en [99.0 kB]
Get:18 http://archive.ubuntu.com/ubuntu focal-updates/universe amd64 Packages [892 kB]       
Get:19 http://security.ubuntu.com/ubuntu focal-security/restricted Translation-en [91.7 kB]      
Get:20 http://security.ubuntu.com/ubuntu focal-security/universe i386 Packages [532 kB]                  
Get:21 http://archive.ubuntu.com/ubuntu focal-updates/universe i386 Packages [663 kB]                    
Get:22 http://security.ubuntu.com/ubuntu focal-security/universe amd64 Packages [675 kB]
Get:23 http://archive.ubuntu.com/ubuntu focal-updates/universe Translation-en [196 kB]           
Get:24 http://security.ubuntu.com/ubuntu focal-security/universe Translation-en [115 kB]     
Get:25 http://archive.ubuntu.com/ubuntu focal-updates/multiverse amd64 Packages [24.8 kB]          
Get:26 http://archive.ubuntu.com/ubuntu focal-updates/multiverse i386 Packages [8,432 B]       
Get:27 http://archive.ubuntu.com/ubuntu focal-updates/multiverse Translation-en [6,928 B]      
Get:28 http://archive.ubuntu.com/ubuntu focal-backports/main amd64 Packages [42.0 kB]                
Get:29 http://archive.ubuntu.com/ubuntu focal-backports/main i386 Packages [34.5 kB]           
Get:30 http://archive.ubuntu.com/ubuntu focal-backports/main Translation-en [10.0 kB]          
Get:31 http://archive.ubuntu.com/ubuntu focal-backports/universe amd64 Packages [19.5 kB]            
Get:32 http://archive.ubuntu.com/ubuntu focal-backports/universe i386 Packages [11.1 kB]       
Get:33 http://archive.ubuntu.com/ubuntu focal-backports/universe Translation-en [13.4 kB]      
Get:34 http://security.ubuntu.com/ubuntu focal-security/multiverse i386 Packages [7,176 B]           
Get:35 http://security.ubuntu.com/ubuntu focal-security/multiverse amd64 Packages [21.8 kB]
Get:36 http://security.ubuntu.com/ubuntu focal-security/multiverse Translation-en [4,948 B]
Fetched 9,275 kB in 2s (4,663 kB/s)                                     
Reading package lists... Done
vagrant@vagrant:~$ sudo apt-get update && sudo apt-get install vault
Hit:1 http://archive.ubuntu.com/ubuntu focal InRelease
Hit:2 http://archive.ubuntu.com/ubuntu focal-updates InRelease                                                   
Hit:3 http://archive.ubuntu.com/ubuntu focal-backports InRelease                                                 
Hit:4 http://security.ubuntu.com/ubuntu focal-security InRelease                                         
Hit:5 https://apt.releases.hashicorp.com focal InRelease                           
Reading package lists... Done
Reading package lists... Done
Building dependency tree       
Reading state information... Done
The following NEW packages will be installed:
  vault
0 upgraded, 1 newly installed, 0 to remove and 109 not upgraded.
Need to get 69.4 MB of archives.
After this operation, 188 MB of additional disk space will be used.
Get:1 https://apt.releases.hashicorp.com focal/main amd64 vault amd64 1.9.2 [69.4 MB]
Fetched 69.4 MB in 9s (7,644 kB/s)                                                                                                        
Selecting previously unselected package vault.
(Reading database ... 41552 files and directories currently installed.)
Preparing to unpack .../archives/vault_1.9.2_amd64.deb ...
Unpacking vault (1.9.2) ...
Setting up vault (1.9.2) ...
Generating Vault TLS key and self-signed certificate...
Generating a RSA private key
......................................................................++++
............++++
writing new private key to 'tls.key'
-----
vagrant@vagrant:~$ vault server -dev -dev-root-token-id root
==> Vault server configuration:

             Api Address: http://127.0.0.1:8200
                     Cgo: disabled
         Cluster Address: https://127.0.0.1:8201
              Go Version: go1.17.5
              Listener 1: tcp (addr: "127.0.0.1:8200", cluster address: "127.0.0.1:8201", max_request_duration: "1m30s", max_request_size: "33554432", tls: "disabled")
               Log Level: info
                   Mlock: supported: true, enabled: false
           Recovery Mode: false
                 Storage: inmem
                 Version: Vault v1.9.2
             Version Sha: f4c6d873e2767c0d6853b5d9ffc77b0d297bfbdf

==> Vault server started! Log data will stream in below:

agrant@vagrant:~$ cat vaultCA.sh 

#! /usr/bin/env bash

export VAULT_ADDR=http://127.0.0.1:8200
export VAULT_TOKEN=root
vault secrets enable pki
vault secrets tune -max-lease-ttl=87600h pki
vault write -field=certificate pki/root/generate/internal \
     common_name="mydevops.ru" \
     ttl=87600h > CA_cert.crt
vault write pki/config/urls \
     issuing_certificates="$VAULT_ADDR/v1/pki/ca" \
     crl_distribution_points="$VAULT_ADDR/v1/pki/crl"
vault secrets enable -path=pki_int pki
vault secrets tune -max-lease-ttl=43800h pki_int
vault write -format=json pki_int/intermediate/generate/internal \
     common_name="mydevops.ru Intermediate Authority" \
     | jq -r '.data.csr' > pki_intermediate.csr
vault write -format=json pki/root/sign-intermediate csr=@pki_intermediate.csr \
     format=pem_bundle ttl="43800h" \
     | jq -r '.data.certificate' > intermediate.cert.pem
vault write pki_int/intermediate/set-signed certificate=@intermediate.cert.pem
vault write pki_int/roles/mydevops \
     allowed_domains="mydevops.ru" \
     allow_subdomains=true \
     max_ttl="720h"
vault write pki_int/issue/mydevops common_name="test.mydevops.ru" ttl="720h" > /home/vagrant/ssl/test.mydevops.crt

vagrant@vagrant:~$ ./vaultCA.sh 
Success! Enabled the pki secrets engine at: pki/
Success! Tuned the secrets engine at: pki/
Success! Data written to: pki/config/urls
Success! Enabled the pki secrets engine at: pki_int/
Success! Tuned the secrets engine at: pki_int/
Success! Data written to: pki_int/intermediate/set-signed
Success! Data written to: pki_int/roles/mydevops

```
-   Процесс установки и настройки сервера nginx
```bash
vagrant@vagrant:~$ sudo apt install nginx
Reading package lists... Done
Building dependency tree       
Reading state information... Done
The following NEW packages will be installed:
  nginx
0 upgraded, 1 newly installed, 0 to remove and 109 not upgraded.
Need to get 3,620 B of archives.
After this operation, 45.1 kB of additional disk space will be used.
Get:1 http://archive.ubuntu.com/ubuntu focal-updates/main amd64 nginx all 1.18.0-0ubuntu1.2 [3,620 B]
Fetched 3,620 B in 0s (28.9 kB/s)
Selecting previously unselected package nginx.
(Reading database ... 42487 files and directories currently installed.)
Preparing to unpack .../nginx_1.18.0-0ubuntu1.2_all.deb ...
Unpacking nginx (1.18.0-0ubuntu1.2) ...
Setting up nginx (1.18.0-0ubuntu1.2) ...

vagrant@vagrant:~$ sudo cat /etc/nginx/sites-available/test.mydevops.conf 

server {
        listen              443 ssl;
        server_name         test.mydevops.ru    localhost;
        ssl_certificate     /home/vagrant/ssl/mydevops.crt.pem;
        ssl_certificate_key /home/vagrant/ssl/mydevops.key;
        ssl_protocols       TLSv1 TLSv1.1 TLSv1.2;
        ssl_ciphers         HIGH:!aNULL:!MD5;

        root /var/www/html1;

        # Add index.php to the list if you are using PHP
        index index.html index.htm index.nginx-debian.html;

        server_name _;

        location / {
                # First attempt to serve request as file, then
                # as directory, then fall back to displaying a 404.
                try_files $uri $uri/ =404;

}

}

vagrant@vagrant:~$ sudo ln -s /etc/nginx/sites-available/test.mydevops.conf /etc/nginx/sites-enabled/
vagrant@vagrant:~$ sudo nginx -t
nginx: the configuration file /etc/nginx/nginx.conf syntax is ok
nginx: configuration file /etc/nginx/nginx.conf test is successful
vagrant@vagrant:~/ssl$ sudo service nginx reload
```

-   Страница сервера nginx в браузере хоста не содержит предупреждений

Приложенный файл: nginx_cert.jpeg

-   Скрипт генерации нового сертификата работает (сертификат сервера ngnix должен быть "зеленым")
```bash
vagrant@vagrant:~/ssl$ cat /home/vagrant/vault_gen_new_crt.sh

#! /usr/bin/env bash
export VAULT_ADDR=http://127.0.0.1:8200
export VAULT_TOKEN=root
vault write -format=json pki_int/issue/mydevops common_name="test.mydevops.ru" ttl="719h" > /home/vagrant/ssl/mydevops.crt
cat /home/vagrant/ssl/mydevops.crt | jq -r .data.certificate > /home/vagrant/ssl/mydevops.crt.pem
cat /home/vagrant/ssl/mydevops.crt | jq -r .data.ca_chain[] >> /home/vagrant/ssl/mydevops.crt.pem
cat /home/vagrant/ssl/mydevops.crt | jq -r .data.private_key > /home/vagrant/ssl/mydevops.key
systemctl reload nginx 2>> /home/vagrant/cert.ssl
date >> /home/vagrant/cert.log
```
Приложенные 2 скрина разных сертификатов и скрин работоспособности в IE: sert1, sert2 IE_screen.

-   Crontab работает (выберите число и время так, чтобы показать что crontab запускается и делает что надо)
```bash
vagrant@vagrant:~/ssl$ cat /etc/crontab
# /etc/crontab: system-wide crontab
# Unlike any other crontab you don't have to run the `crontab'
# command to install the new version when you edit this file
# and files in /etc/cron.d. These files also have username fields,
# that none of the other crontabs do.

SHELL=/bin/sh
PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin

# Example of job definition:
# .---------------- minute (0 - 59)
# |  .------------- hour (0 - 23)
# |  |  .---------- day of month (1 - 31)
# |  |  |  .------- month (1 - 12) OR jan,feb,mar,apr ...
# |  |  |  |  .---- day of week (0 - 6) (Sunday=0 or 7) OR sun,mon,tue,wed,thu,fri,sat
# |  |  |  |  |
# *  *  *  *  * user-name command to be executed
17 *	* * *	root    cd / && run-parts --report /etc/cron.hourly
25 6	* * *	root	test -x /usr/sbin/anacron || ( cd / && run-parts --report /etc/cron.daily )
47 6	* * 7	root	test -x /usr/sbin/anacron || ( cd / && run-parts --report /etc/cron.weekly )
52 6	1 * *	root	test -x /usr/sbin/anacron || ( cd / && run-parts --report /etc/cron.monthly )
* *	* * *	root	/home/vagrant/vault_gen_new_crt.sh 2>> /home/vagrant/cert.log
#
vagrant@vagrant:~/ssl$ cat /home/vagrant/cert.log
Fri 21 Jan 2022 01:16:12 PM UTC
Fri 21 Jan 2022 01:18:18 PM UTC
Fri 21 Jan 2022 01:22:01 PM UTC
Fri 21 Jan 2022 01:23:01 PM UTC
Fri 21 Jan 2022 01:24:02 PM UTC
Fri 21 Jan 2022 01:25:01 PM UTC
Fri 21 Jan 2022 01:26:01 PM UTC
Fri 21 Jan 2022 01:27:02 PM UTC
```