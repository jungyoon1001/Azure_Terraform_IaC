#리소스 그룹 생성
resource "azurerm_resource_group" "example" {
  name     = "ASPN_LandingZone"
  location = "Korea Central"
}


## 젠킨스 트리거 테스트
