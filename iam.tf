# Copyright (c) 2020 Oracle and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at http://oss.oracle.com/licenses/upl.
#

#*************************************
#           Groups
#*************************************

resource "oci_identity_group" "ods-group" {
  provider       = oci.home
  compartment_id = var.tenancy_ocid
  description    = "Data Science Group"
  name           = var.ods_group_name
}

#*************************************
#          Dynamic Groups
#*************************************

resource "oci_identity_dynamic_group" "ods-dynamic-group" {
  provider       = oci.home
  compartment_id = var.tenancy_ocid
  description    = "Data Science Dynamic Group"
  name           = var.ods_dynamic_group_name
  matching_rule = "any {all {resource.type='datasciencenotebooksession',resource.compartment.id='${var.compartment_ocid}'}, all {resource.type='datasciencejobrun',resource.compartment.id='${var.compartment_ocid}'}, all {resource.type='datasciencemodeldeployment',resource.compartment.id='${var.compartment_ocid}'}}"
}

#*************************************
#           Policies
#*************************************
locals {
  ods_policies = [
    "Allow service datascience to use virtual-network-family in compartment ${data.oci_identity_compartment.current_compartment.name}",
    "Allow group ${oci_identity_group.ods-group.name} to read metrics in compartment ${data.oci_identity_compartment.current_compartment.name}",
    "Allow group ${oci_identity_group.ods-group.name} to manage data-science-family in compartment ${data.oci_identity_compartment.current_compartment.name}" ,
    "Allow group ${oci_identity_group.ods-group.name} to manage log-groups in compartment ${data.oci_identity_compartment.current_compartment.name}",
    "Allow group ${oci_identity_group.ods-group.name} to use log-content in compartment ${data.oci_identity_compartment.current_compartment.name}",
    "Allow group ${oci_identity_group.ods-group.name} to use virtual-network-family in compartment ${data.oci_identity_compartment.current_compartment.name}",
    "Allow group ${oci_identity_group.ods-group.name} to use object-family in compartment ${data.oci_identity_compartment.current_compartment.name}",
    "Allow dynamic-group ${oci_identity_dynamic_group.ods-dynamic-group.name} to use log-content in compartment ${data.oci_identity_compartment.current_compartment.name}",
    "Allow dynamic-group ${oci_identity_dynamic_group.ods-dynamic-group.name} to read virtual-network-family in compartment ${data.oci_identity_compartment.current_compartment.name}",
    "Allow dynamic-group ${oci_identity_dynamic_group.ods-dynamic-group.name} to manage data-science-family in compartment ${data.oci_identity_compartment.current_compartment.name}",
    "Allow dynamic-group ${oci_identity_dynamic_group.ods-dynamic-group.name} to use object-family in compartment ${data.oci_identity_compartment.current_compartment.name}",
    "Allow dynamic-group ${oci_identity_dynamic_group.ods-dynamic-group.name} to read repos in compartment ${data.oci_identity_compartment.current_compartment.name}"
  ]
  vault_policies = [
    "Allow group ${oci_identity_group.ods-group.name} to use vaults in compartment ${data.oci_identity_compartment.current_compartment.name}",
    "Allow group ${oci_identity_group.ods-group.name} to manage keys in compartment ${data.oci_identity_compartment.current_compartment.name}",
    "Allow dynamic-group ${oci_identity_dynamic_group.ods-dynamic-group.name} to use vaults in compartment ${data.oci_identity_compartment.current_compartment.name}",
    "Allow dynamic-group ${oci_identity_dynamic_group.ods-dynamic-group.name} to manage keys in compartment ${data.oci_identity_compartment.current_compartment.name}"
  ]
  ods_root_policies = [
    "Allow service datascience to use virtual-network-family in tenancy",
    "Allow group ${oci_identity_group.ods-group.name} to read metrics in tenancy",
    "Allow group ${oci_identity_group.ods-group.name} to manage data-science-family in tenancy" ,
    "Allow group ${oci_identity_group.ods-group.name} to manage log-groups in tenancy",
    "Allow group ${oci_identity_group.ods-group.name} to use log-content in tenancy",
    "Allow group ${oci_identity_group.ods-group.name} to use virtual-network-family in tenancy",
    "Allow group ${oci_identity_group.ods-group.name} to use object-family in tenancy",
    "Allow dynamic-group ${oci_identity_dynamic_group.ods-dynamic-group.name} to use log-content in tenancy",
    "Allow dynamic-group ${oci_identity_dynamic_group.ods-dynamic-group.name} to read virtual-network-family in tenancy",
    "Allow dynamic-group ${oci_identity_dynamic_group.ods-dynamic-group.name} to manage data-science-family in tenancy",
    "Allow dynamic-group ${oci_identity_dynamic_group.ods-dynamic-group.name} to use object-family in tenancy",
    "Allow dynamic-group ${oci_identity_dynamic_group.ods-dynamic-group.name} to read repos in tenancy"
  ]
  vault_root_policies = [
    "Allow group ${oci_identity_group.ods-group.name} to use vaults in tenancy",
    "Allow group ${oci_identity_group.ods-group.name} to manage keys in tenancy",
    "Allow dynamic-group ${oci_identity_dynamic_group.ods-dynamic-group.name} to use vaults in tenancy",
    "Allow dynamic-group ${oci_identity_dynamic_group.ods-dynamic-group.name} to manage keys in tenancy"
  ]
}
resource "oci_identity_policy" "ods-policy" {
  provider       = oci.home
  compartment_id = var.compartment_ocid
  description    = "Data Science Policies"
  name           = var.ods_policy_name
  statements     = var.compartment_ocid == var.tenancy_ocid ? var.enable_vault ? concat(local.ods_root_policies, local.vault_root_policies) : local.ods_root_policies : var.enable_vault ? concat(local.ods_policies, local.vault_policies) : local.ods_policies

}

#*************************************
#             Vault
#*************************************

resource "oci_kms_vault" "ods-vault" {
  count = var.enable_vault ? 1 : 0
  #Required
  compartment_id = var.compartment_ocid
  display_name   = var.ods_vault_name
  vault_type     = var.ods_vault_type
}

resource "oci_kms_key" "ods-key" {
  count = var.enable_vault ? var.enable_create_vault_master_key ? 1 : 0 : 0
  #Required
  compartment_id = var.compartment_ocid
  display_name   = var.ods_vault_master_key_name
  key_shape {
    #Required
    algorithm = "AES"
    length    = var.ods_vault_master_key_length
  }
  management_endpoint = oci_kms_vault.ods-vault[0].management_endpoint
}
