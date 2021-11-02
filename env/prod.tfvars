#####################
#Bootstrap Variables# 
#####################
state_container_name = "terraform-state"
state_key            = "terraform.tfstate.prod.003-headless-vm"


##################################################
#Regular Terraform Environment Specific Variables#
##################################################
machine_number = "003"

env_tags = {
  env = "production"
}
