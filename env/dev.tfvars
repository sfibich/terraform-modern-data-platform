#####################
#Bootstrap Variables# 
#####################
state_container_name = "terraform-state"
state_key            = "terraform.tfstate.dev.mdp-001"


##################################################
#Regular Terraform Environment Specific Variables#
##################################################
machine_number = "001"

env_tags = {
  env = "development"
}
