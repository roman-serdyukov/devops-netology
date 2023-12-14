#*/usr/bin/bash

dir=$(pwd)
echo Введите Ваш TF_TOKEN_app_terraform_io
read tf_token
# tf_token=
export TF_TOKEN_app_terraform_io=$tf_token
echo "TF_TOKEN_app_terraform_io=$TF_TOKEN_app_terraform_io"

echo Веедите адрес private key
read private_key
# private_key=
echo "Адрес вашего private key $private_key"

echo Создаю папку проекта
mkdir reserdukov

cd $dir/reserdukov

echo Скачиваю репозиторий с terraform
git clone https://github.com/roman-serdyukov/graduate-terrafom.git
cd $dir/reserdukov/graduate-terrafom
git checkout TC-v.1.0.2

echo Введите адврес электронной почты для запроса сертификатов
read email
# email=
echo "Адрес электронной почты $email"

echo Укажите назввание организации Terraform cloud
read src
# src=
sed -i "s/your_company/$src/" versions.tf

echo Запускаю terraform
terraform init
# terraform plan
terraform apply --auto-approve

echo Пауза на создание инфраструктуры в YC
sleep 30

echo "Проверка регистрации созданных ресурсных записей. Процесс не продолжится без доступности всех доменных имен"

testing_hosts=("www.$dnszone" "gitlab.$dnszone" "runner.$dnszone" "monitoring.$dnszone" "db1.$dnszone" "db2.$dnszone")
for host in ${testing_hosts[@]}
do
        nslookup $host > /dev/null 2>&1
        if (( $? != 0 )); then
                while (( $? == 0 ))
                do
                nslookup $host > /dev/null & echo $host not find
                done
        else echo $host is find
        fi
done 

echo Скачиваю репозиторий с рабочим проектом и загружаю в него roles
cd $dir/reserdukov
git clone https://github.com/roman-serdyukov/graduate-roles.git
cd graduate-roles
ansible-galaxy role install -r requirements.yml -p roles

echo Запускаю установку roles

ansible-playbook -i inventory/prod.yml site.yml -e my_domain=$dnszone -e email=$email --user=ubuntu --private-key=$private_key --ssh-common-args='-o StrictHostKeyChecking=no'

echo Скачиваю репозиторий для gitlab ci
cd $dir/reserdukov
git clone https://github.com/roman-serdyukov/ci-apps.git