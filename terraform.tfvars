location      = "eastUS2"
fw_license   = "byol"                                                       # Uncomment 1 fw_license to select VM-Series licensing mode
#fw_license   = "bundle1"
#fw_license    = "bundle2"
global_prefix = "msa-dr-tx-"                                                    # Prefix to add to all resource groups created.  This is useful to create unique resource groups within a shared Azure subscription

# -----------------------------------------------------------------------
# VM-Series resource group variables
fw_prefix               = "drfw"                                         # Adds prefix name to all resources created in the firewall resource group
fw_vm_count             = 2
fw_panos                = "10.0.4"
fw_nsg_prefix           = "0.0.0.0/0"
fw_username             = "paloalto"
fw_password             = "changeme"
fw_internal_lb_ip       = "172.28.2.100"

# -----------------------------------------------------------------------
# Transit resource group variables
transit_prefix          = "transit"                                         # Adds prefix name to all resources created in the transit vnet's resource group
transit_vnet_cidr       = "172.28.0.0/21"
transit_subnet_names    = ["snet-msa-dr-mgmt", "snet-msa-dr-untrust", "snet-msa-dr-trust"]
transit_subnet_cidrs    = ["172.28.0.0/24", "172.28.1.0/24", "172.28.2.0/24"]

# -----------------------------------------------------------------------
# Spoke resource group variables
spoke1_prefix           = "msa-dr-tx-dmz"                             # Adds prefix name to all resources created in spoke1's resource group
spoke1_vm_name          = "dmz"
spoke1_vnet_cidr        = "172.28.8.0/21"
spoke1_subnet_cidrs     = ["172.28.8.0/24"]
spoke1_internal_lb_ip   = "172.28.8.100"
spoke1_vm_count         = 1

spoke2_prefix           = "msa-dr-tx-trust"                                 # Adds prefix name to all resources created in spoke2's resource group
spoke2_vm_name          = "trust"
spoke2_vnet_cidr        = "172.28.16.0/21"
spoke2_subnet_cidrs     = ["172.28.16.0/24"]
spoke2_vm_count         = 1

spoke3_prefix           = "msa-dr-tx-bastion"                                # Adds prefix name to all resources created in spoke2's resource group
spoke3_vm_name          = "bastion"
spoke3_vnet_cidr        = "172.28.24.0/21"
spoke3_subnet_cidrs     = ["172.28.24.0/24"]
spoke3_vm_count         = 1

spoke_username          = "adminuser"
spoke_password          = "changeme"
