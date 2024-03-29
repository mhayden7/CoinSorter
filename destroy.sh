echo "Destroy Terraform"
echo $'#########################################\n'
cd ./terraform
terraform destroy -var 'region=primary' -var="lab_id=99" -state=primary.terraform.tfstate
cd ..