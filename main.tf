terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}

provider "azurerm" {
  features {}
  subscription_id = "a55a4ed4-e1da-410b-a33d-1840ef02f227"
}

resource "azurerm_resource_group" "rg" {
  name     = "aks-resource-group"
  location = "East US"
}

resource "azurerm_kubernetes_cluster" "app" {
  name                = "aks-cluster"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  dns_prefix          = "akscluster"

  default_node_pool {
    name                = "default"
    min_count           = 1
    max_count           = 3
    vm_size             = "Standard_B2s"
    enable_auto_scaling = true
    type                = "VirtualMachineScaleSets"
  }

  identity {
    type = "SystemAssigned"
  }

  kubernetes_version = "1.31.5"  
}

output "kube_config" {
  value     = azurerm_kubernetes_cluster.app.kube_config_raw
  sensitive = true
}