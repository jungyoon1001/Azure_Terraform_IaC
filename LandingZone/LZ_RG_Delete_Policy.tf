resource "azurerm_policy_definition" "prevent_deletion" {
  name         = "prevent-resource-deletion"
  policy_type  = "Custom"
  mode         = "All"
  display_name = "Prevent Resource Deletion"

  policy_rule = <<POLICY_RULE
{
  "if": {
    "allOf": [
      {
        "field": "type",
        "equals": "Microsoft.Resources/subscriptions/resourceGroups"
      },
      {
        "field": "location",
        "in": [
          "global"
        ]
      }
    ]
  },
  "then": {
    "effect": "deny"
  }
}
POLICY_RULE
}
