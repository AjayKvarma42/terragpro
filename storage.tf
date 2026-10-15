resource "azurerm_storage_account" "sa" {
  name                     = var.sa-name
  resource_group_name      = azurerm_resource_group.rg02.name
  location                 = azurerm_resource_group.rg02.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  account_kind             = "StorageV2"
  allow_nested_items_to_be_public = true
}

resource "azurerm_storage_account_static_website" "swh" {
  storage_account_id = azurerm_storage_account.sa.id
  error_404_document = "error.html"
  index_document     = "index.html"
}





resource "azurerm_storage_container" "web" {
  name                  = "$web"
  storage_account_id = azurerm_storage_account.sa.id
  container_access_type = "blob"
}

data "http" "index" {
  url = "https://raw.githubusercontent.com/AjayKvarma42/terragpro/main/index.html"
}



resource "azurerm_storage_blob" "web01" {
  name                   = "index.html"
  storage_container_id = azurerm_storage_container.web.id
  type                   = "Block"
  source_content         = data.http.index.response_body
  content_type           = "text/html"
}



resource "azurerm_storage_blob" "webimage" {
  name                   = "aj-image.png"
  storage_container_id   = azurerm_storage_container.web.id
  type                   = "Block"
  source_uri = "https://raw.githubusercontent.com/AjayKvarma42/terragpro/main/aj-image.png"
  content_type   = "image/png"

  depends_on = [
    azurerm_storage_account_static_website.swh
  ]
}


output "static_website_url" {
  value = azurerm_storage_account.sa.primary_web_endpoint
} 