#*/usr/bin/bash
echo Создаю папку проекта
mkdir reserdukov

echo Скачиваю репозиторий с рабочим проектом и загружаю в него roles
cd reserdukov
git clone https://github.com/roman-serdyukov/graduate-roles.git
cd graduate-roles
ansible-galaxy role install -r requirements.yml -p roles

echo Скачиваю репозиторий с terraform
cd ../
git clone https://github.com/roman-serdyukov/graduate-terrafom.git
cd graduate-terrafom
echo Укажите путь до публичного ключа ssh
read src
dest=$(pwd)
cp $src $dest
echo Запускаю terraform
terraform init
terraform apply --auto-approve

echo Пауза на создание инфраструктуры в YC
sleep 30

echo Запускаю установку roles
export ANSIBLE_HOST_KEY_CHECKING=False

ansible-playbook -i ../graduate-roles/inventory/prod.yml ../graduate-roles/site.yml

echo Скачиваю репозиторий для gitlab ci
cd ../
git clone https://github.com/roman-serdyukov/ci-apps.git
