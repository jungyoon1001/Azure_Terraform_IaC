# Provider 설정
provider "azurerm" {
  features {}
}

# 네트워크 any, any 생성 불가 정책 정의
resource "azurerm_policy_definition" "example" {
  name         = "deny-network-any-any"
  policy_type  = "Custom"
  mode         = "Indexed"
  display_name = "Deny creation of any-any network rules"

  policy_rule = <<POLICY_RULE
{
  "if": {
    "allOf": [
      {
        "field": "type",
        "equals": "Microsoft.Network/networkSecurityGroups/securityRules"
      },
      {
        "field": "Microsoft.Network/networkSecurityGroups/securityRules/access",
        "equals": "Allow"
      },
      {
        "field": "Microsoft.Network/networkSecurityGroups/securityRules/sourceAddressPrefix",
        "equals": "*"
      },
      {
        "field": "Microsoft.Network/networkSecurityGroups/securityRules/destinationAddressPrefix",
        "equals": "*"
      }
    ]
  },
  "then": {
    "effect": "deny"
  }
}
POLICY_RULE
}