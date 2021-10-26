Эта директория для изучения Terraform

С текущими настройками GIT будет игнорировать:
- файлы в скрытых подкапках terraform 
**/.terraform/*

- файлы с расширением tfstate и файлы с tfstate в названии после "."  
*.tfstate
*.tfstate.*

- краш логи
crash.log

- файлы с расширением tfvars
*.tfvars

- файлы 
override.tf
override.tf.json
и вариации с 
*_override.tf
*_override.tf.json
в названии после "_"

- файлы конфигурации CLI
.terraformrc
terraform.rc
