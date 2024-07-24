terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 2.46.0"
    }
  }
}

provider "azurerm" {
  features {}

  subscription_id = var.subscription_id
  client_id       = var.client_id
  client_secret   = var.client_secret
  tenant_id       = var.tenant_id
}

# 정책 정의
resource "azurerm_policy_definition" "tag_enforcement" {
  name         = "enforce-resource-tags"
  policy_type  = "Custom"
  mode         = "All"
  display_name = "Enforce Resource Tagging"

  policy_rule = <<POLICY_RULE
{
  "if": {
    "allOf": [
      {
        "field": "tags",
        "exists": false
      },
      {
        "field": "type",
        "notEquals": "Microsoft.Resources/subscriptions/resourceGroups"
      }
    ]
  },
  "then": {
    "effect": "deny"
  }
}
POLICY_RULE
}

# 정책 할당
resource "azurerm_policy_assignment" "tag_enforcement_assignment" {
  name                 = "enforce-resource-tags-assignment"
  policy_definition_id = azurerm_policy_definition.tag_enforcement.id
  scope                = "/subscriptions/${var.subscription_id}"

  description  = "This policy ensures that all resources have tags."
  display_name = "Enforce Resource Tagging"
}
