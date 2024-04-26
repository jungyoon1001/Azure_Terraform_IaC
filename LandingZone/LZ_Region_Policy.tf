# 특정 지역에 리소스 생성 제한 정책 정의 (Korea Central)
resource "azurerm_policy_definition" "location_restriction" {
  name         = "restrict-resource-location"
  policy_type  = "Custom"
  mode         = "All"
  display_name = "Restrict Resource Creation to Specific Locations"

  policy_rule = <<POLICY_RULE
{
  "if": {
    "not": {
      "field": "location",
      "in": [
        "koreacentral"
      ]
    }
  },
  "then": {
    "effect": "deny"
  }
}
POLICY_RULE

  parameters = <<PARAMETERS
{}
PARAMETERS
}

