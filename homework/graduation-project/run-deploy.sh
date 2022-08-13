#*/usr/bin/bash
echo Создаю папки проекта
mkdir reserdukov
mkdir reserdukov/terraform
mkdir reserdukov/project-roles

echo Скачиваю репозиторий с рабочим проектом и загружаю в него roles
cd reserdukov/project-roles
git clone https://github.com/roman-serdyukov/graduate-roles.git
ansible-galaxy role install -r requirements.yml -p roles

echo Скачиваю репозиторий с terraform
cd ../terraform
git clone https://github.com/roman-serdyukov/graduate-terrafom.git
echo Укажите путь до публичного ключа ssh
read key_path
cp $key_path .
echo Запускаю terraform
terraform init
terraform apply --auto-approve

echo Пауза на создание инфраструктуры в YC
sleep 30

echo Запускаю установку roles
export ANSIBLE_HOST_KEY_CHECKING=False

ansible-playbook -i ../project-roles/inventory/prod.yml ../project-roles/site.yml

echo Скачиваю репозиторий для gitlab ci
mkdir ../ci
cd ../ci
git clone https://github.com/roman-serdyukov/ci-apps.git
