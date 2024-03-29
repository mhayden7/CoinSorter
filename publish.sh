#!/bin/bash
lab_id=$1

echo "Install lab python dependencies"
echo $'#########################################\n'
python -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt


echo "Publish Terraform"
echo $'#########################################\n'
cd ./terraform
terraform init
terraform apply -var="region=primary" -var="lab_id=${lab_id}" -state=primary.terraform.tfstate
# if [ "$lab_id" == "1" ]; then 
#     # x="region=primary,lab_id=${lab_id}"
#     # echo $x
#     terraform apply -var="region=primary" -var="lab_id=${lab_id}" -state=primary.terraform.tfstate
# fi
# terraform apply -var 'region=us-west-2' -state=west.terraform.tfstate
cd ..

# terraform destroy -var 'region=primary' -state=primary.terraform.tfstate
# terraform destroy -var 'region=us-west-2' -state=west.terraform.tfstate