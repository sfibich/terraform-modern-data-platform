#####################
#Bootstrap Variables# 
#####################
state_container_name = "terraform-state"
state_key = "terraform.tfstate.dev.001-headless-vm"
 

##################################################
#Regular Terraform Environment Specific Variables#
##################################################
machine_number = "001"

env_tags = {
  env="development"
  }
