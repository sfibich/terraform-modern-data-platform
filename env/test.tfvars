#####################
#Bootstrap Variables# 
#####################
state_container_name = "terraform-state"
state_key            = "terraform.tfstate.test.mdp-002"


##################################################
#Regular Terraform Environment Specific Variables#
##################################################
machine_number = "002"

env_tags = {
  env = "test"
}
