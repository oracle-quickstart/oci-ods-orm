# Copyright (c) 2020 Oracle and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at http://oss.oracle.com/licenses/upl.
#

#*************************************
#          IAM Specific
#*************************************

variable "ods_group_name" {
  default = "DataScienceGroup"
}
variable "ods_dynamic_group_name" {
  default = "DataScienceDynamicGroup"
}
variable "ods_policy_name" {
  default = "DataSciencePolicies"
}

#*************************************
#          Vault Specific
#*************************************
variable "enable_vault" {
  type    = bool
  default = true
}
variable "ods_use_existing_vault" {
  type = bool
  default = false
}
variable "ods_vault_name" {
  default = "Data Science Vault"
}
variable "ods_vault_type" {
  default = "DEFAULT"
}
variable "enable_create_vault_master_key" {
  type    = bool
  default = true
}
variable "ods_vault_master_key_name" {
  default = "Data Science Master Key"
}
variable "ods_vault_master_key_length" {
  default = 32
}
#*************************************
#           TF Requirements
#*************************************
variable "tenancy_ocid" {
  default = ""
}
variable "region" {
  default = ""
}
variable "user_ocid" {
  default = ""
}
variable "private_key_path" {
  default = ""
}
variable "fingerprint" {
  default = ""
}
variable "compartment_ocid" {
  default = ""
}

#*************************************
#           Data Sources
#*************************************

data "oci_identity_tenancy" "tenant_details" {
  #Required
  tenancy_id = var.tenancy_ocid
}
data "oci_identity_regions" "home-region" {
  filter {
    name   = "key"
    values = [data.oci_identity_tenancy.tenant_details.home_region_key]
  }
}
data "oci_identity_regions" "current_region" {
  filter {
    name   = "name"
    values = [var.region]
  }
}
data "oci_identity_compartment" "current_compartment" {
  #Required
  id = var.compartment_ocid
}

