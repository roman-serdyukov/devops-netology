#*/usr/bin/bash
dir=$(pwd)
echo  Введите Ваш идентификатор Terraform (TF_TOKEN_app_terraform_io или YC_TOKEN)
read tf_token
export TF_TOKEN_app_terraform_io=$tf_token
export YC_TOKEN=$tf_token
echo "Вы ввели $TF_TOKEN_app_terraform_io"

cd reserdukov/graduate-terrafom
terraform destroy --auto-approve
cd $dir

yes | rm -R reserdukov