#*/usr/bin/bash

dir=$(pwd)
echo  Введите Ваш YC_TOKEN
read yc_token
# yc_token=
export YC_TOKEN=$yc_token
echo "YC_TOKEN=$YC_TOKEN"

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
git checkout NO-TC-v.1.0.2
pub_key=$private_key.pub
sed -i "s|your_key|$pub_key|" vars.tf

echo Укажите cloud_id
read cloud_id
# cloud_id=
echo "cloud_id=$cloud_id"
sed -i "s/your_cloud/$cloud_id/" vars.tf
echo Укажите folder id
read folder_id
# folder_id=
echo "folder_id=$folder_id"
sed -i "s/your_folder/$folder_id/" vars.tf
echo Введите зону DNS
read dnszone
# dnszone=
echo "dns_zone=$dnszone"
sed -i "s/your_domain/$dnszone/" vars.tf
echo Введите адврес электронной почты для запроса сертификатов
read email
# email=
echo "Адрес электронной почты $email"

cat vars.tf

echo Запускаю terraform
terraform init
terraform workspace new stage
terraform workspace new prod
terraform workspace select prod
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
