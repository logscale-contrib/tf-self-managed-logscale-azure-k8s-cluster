
resource "time_sleep" "azuread_service_principal_password_app" {
  depends_on = [
    azuread_service_principal_password.app
  ]
  create_duration = "60s"
}

resource "azurerm_kubernetes_cluster" "k8s" {
  depends_on = [
    azuread_service_principal_password.app
  ]

  name                = var.aks_name
  location            = var.resource_group_location
  dns_prefix          = var.aks_dns_prefix
  kubernetes_version  = var.kubernetes_version
  resource_group_name = var.resource_group_name

  http_application_routing_enabled = false

  # local_account_disabled = false
  azure_active_directory_role_based_access_control {
    managed                = true
    admin_group_object_ids = [var.aks_admin_group_id]
  }

  default_node_pool {
    name = "system"

    vnet_subnet_id = azurerm_subnet.kubesubnet.id

    vm_size = "Standard_B2s" #var.aks_agent_vm_size

    os_disk_size_gb = "30"
    os_disk_type    = "Managed"
    os_sku          = var.aks_agent_os_sku

    enable_auto_scaling = true
    max_count           = 6
    min_count           = 2
    zones               = [1, 2, 3]
    type                = "VirtualMachineScaleSets"
  }

  auto_scaler_profile {
    balance_similar_node_groups   = true
    skip_nodes_with_local_storage = false
    expander                      = "least-waste"
  }

  identity {
    type = "SystemAssigned"
  }
  # service_principal {
  #   client_id     = azuread_application.app.application_id
  #   client_secret = azuread_service_principal_password.app.value
  # }

  network_profile {
    network_plugin     = "azure"
    dns_service_ip     = var.aks_dns_service_ip
    docker_bridge_cidr = var.aks_docker_bridge_cidr
    service_cidr       = var.aks_service_cidr
  }

  role_based_access_control_enabled = true

  tags = var.tags
}

resource "azurerm_kubernetes_cluster_node_pool" "compute" {
  name                  = "compute1"
  kubernetes_cluster_id = azurerm_kubernetes_cluster.k8s.id
  vm_size               = "Standard_DS3_v2"
  tags                  = var.tags


  vnet_subnet_id = azurerm_subnet.kubesubnet.id

  os_disk_size_gb = var.aks_agent_os_disk_size
  os_disk_type    = var.aks_agent_os_disk_type
  os_sku          = var.aks_agent_os_sku

  #priority = "Spot"
  node_labels = {
    "beta.crowdstrike.com/instanceclass" : "compute"
  }
  enable_auto_scaling = true
  max_count           = var.aks_agent_count + 2
  min_count           = 1
  zones               = [1, 2, 3]
}


resource "azurerm_kubernetes_cluster_node_pool" "memory1" {
  name                  = "memory1"
  kubernetes_cluster_id = azurerm_kubernetes_cluster.k8s.id
  vm_size               = "Standard_E2ads_v5"
  tags                  = var.tags


  vnet_subnet_id = azurerm_subnet.kubesubnet.id

  os_disk_size_gb = var.aks_agent_os_disk_size
  os_disk_type    = var.aks_agent_os_disk_type
  os_sku          = var.aks_agent_os_sku

  #priority = "Spot"
  node_labels = {
    "beta.crowdstrike.com/instanceclass" : "memory"
  }
  enable_auto_scaling = true
  max_count           = var.aks_agent_count + 2
  min_count           = 1
  zones               = [1, 2, 3]
}

