locals {

  policy_assignment_metadata = <<METADATA
    {
    "category": "General"
    }
METADATA

  policy_assignment_parameters = <<PARAMETERS
{
  "allowedLocations": {
    "value": [ "eastus2","centralus" ]
  }
}
PARAMETERS

}

resource "azurerm_policy_definition" "region" {
  name         = "region-definition"
  policy_type  = "Custom"
  mode         = "Indexed"
  display_name = "region-definition"

  policy_rule = <<POLICY_RULE
    {
    "if": {
      "not": {
        "field": "location",
        "in": "[parameters('allowedLocations')]"
      }
    },
    "then": {
      "effect": "deny"
    }
  }
POLICY_RULE


  parameters = <<PARAMETERS
    {
    "allowedLocations": {
      "type": "Array",
      "metadata": {
        "description": "The list of allowed locations for resources.",
        "displayName": "Allowed locations",
        "strongType": "location"
      }
    }
  }
PARAMETERS

}


resource "azurerm_resource_group_policy_assignment" "region" {
  name                 = "region-assignment"
  resource_group_id    = azurerm_resource_group.mdp.id
  policy_definition_id = azurerm_policy_definition.region.id
  description          = "Policy Assignment for valid Azure Region assignments"
  display_name         = "region-assignment"

  metadata = local.policy_assignment_metadata

  parameters = local.policy_assignment_parameters

}

