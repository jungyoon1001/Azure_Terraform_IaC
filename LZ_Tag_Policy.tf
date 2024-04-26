#리소스 생성시 태그를 지정하지 않으면 리소스 생성 거부 정책 정의
resource "azurerm_policy_definition" "tag_enforcement" {
  name         = "enforce-resource-tags"
  policy_type  = "Custom"
  mode         = "Indexed"
  display_name = "Enforce Resource Tagging"

  policy_rule = <<POLICY_RULE
{
  "if": {
    "field": "tags",
    "exists": false
  },
  "then": {
    "effect": "deny"
  }
}
POLICY_RULE
}
