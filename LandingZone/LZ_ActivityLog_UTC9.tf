provider "azurerm" {
  features {}
}

data "azurerm_resource_group" "example" {
  name = "ASPN_LandingZone"                       #생성할 리소스 그룹에 따라 이름 수정
}

resource "azurerm_storage_account" "example" {
  name                     = "examplestorageaccount"  # 이름 수정
  resource_group_name      = data.azurerm_resource_group.example.name
  location                 = data.azurerm_resource_group.example.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_eventhub_namespace" "example" {
  name                = "exampleehnamespace"  # 이름 수정
  location            = data.azurerm_resource_group.example.location
  resource_group_name = data.azurerm_resource_group.example.name
  sku                 = "Standard"
  capacity            = 1
}

locals {
  kst_timestamp = timeadd(timestamp(), "9h")  # 현재 UTC 시간에 9시간을 더해 KST 시간을 계산합니다.
  current_date_kst = formatdate("YYMMDDHHmm", local.kst_timestamp)  # KST 시간을 "YYYYMMDDHHmm" 형식으로 포맷합니다.
}

resource "azurerm_monitor_log_profile" "example" {
  name = "ActivityLog_${local.current_date_kst}"

  categories = [
    "Action",
    "Delete",
    "Write",
  ]

  locations = [
    "global",
  ]

  servicebus_rule_id = "${azurerm_eventhub_namespace.example.id}/authorizationrules/RootManageSharedAccessKey"
  storage_account_id = azurerm_storage_account.example.id

  retention_policy {
    enabled = true
    days    = 7                               # 로그 보관 주기
  }
}
