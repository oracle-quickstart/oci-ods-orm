# Provision Oracle Data Science (**_ODS_**) Using Oracle Cloud Infrastructure Resource Manager and Terraform

## Introduction

[![Deploy to Oracle Cloud](https://oci-resourcemanager-plugin.plugins.oci.oraclecloud.com/latest/deploy-to-oracle-cloud.svg)](https://cloud.oracle.com/resourcemanager/stacks/create?zipUrl=https://github.com/oracle-quickstart/oci-ods-orm/releases/download/1.0.6/oci-ods-orm-v1.0.6.zip)

This solution allows you to provision [Oracle Data Science (**_ODS_**)](https://docs.cloud.oracle.com/en-us/iaas/data-science/using/data-science.htm) and all its related artifacts using [Terraform](https://www.terraform.io/docs/providers/oci/index.html) and [Oracle Cloud Infrastructure Resource Manager](https://docs.cloud.oracle.com/en-us/iaas/Content/ResourceManager/Concepts/resourcemanager.htm).

Below is a list of all artifacts that will be provisioned:

| Component    | Default Name            | Optional |  Notes
|--------------|-------------------------|----------|:-----------|
| [Group](https://docs.cloud.oracle.com/en-us/iaas/Content/Identity/Tasks/managinggroups.htm)        | Oracle Cloud Infrastructure Users Group              | False    | All Policies are granted to this group, you can add users to this group to grant me access to ODS services.
| [Dynamic Group](https://docs.cloud.oracle.com/en-us/iaas/Content/Identity/Tasks/managingdynamicgroups.htm) | Oracle Cloud Infrastructure Dynamic Group           | False    | Dynamic Group for Data Science Resources.
| [Policies (compartment)](https://docs.cloud.oracle.com/en-us/iaas/Content/Identity/Concepts/policygetstarted.htm)   | Oracle Cloud Infrastructure Security Policies        | False              | A policy at the compartment level to grant access to ODS
| [Vault Master Key](https://docs.cloud.oracle.com/en-us/iaas/Content/KeyManagement/Concepts/keyoverview.htm) | Oracle Cloud Infrastructure Vault Master Key             | True     | Oracle Cloud Infrastructure Vault Master Key can be used encrypt/decrypt credentials for secured access.

## Prerequisite

- You need a user with an **Administrator** privileges to execute the ORM stack or Terraform scripts.
- Make sure your tenancy has service limits availabilities for the above components in the table.

## Using Oracle Resource Manager (ORM)

1. clone repo `git clone git@github.com:oracle-quickstart/oci-ods-orm.git`
1. Download [`oci-ods-orm-v1.0.6.zip`](../../releases/download/1.0.6/oci-ods-orm-v1.0.6.zip) file
1. From Oracle Cloud Infrastructure **Console/Resource Manager**, create a new stack.
1. Make sure you select **My Configurations** and then upload the zip file downloaded in the previous step.
1. Set a name for the stack and click Next.
1. Set the required variables values and then Create.
    ![create stack](images/create_stack.gif)

1. From the stack details page, Select **Plan** under **Terraform Actions** menu button and make sure it completes successfully.
    ![plan](images/plan.png)

1. From the stack details page, Select **Apply** under **Terraform Actions** menu button and make sure it completes successfully.
    ![Apply](images/apply.png)

1. To destroy all created artifacts, from the stack details page, Select **Destroy** under **Terraform Actions** menu button and make sure it completes successfully.
    ![Destroy](images/destroy.png)

### Understanding Provisioning Options

- **IAM Groups/Policies** change default names of Groups and Policies to be created.

    ![IAM Configs](images/orm_iam.png)

- If **Enable Vault Support** is selected, Oracle Cloud Infrastructure Vault along with all required IAM policies will be provisioned, you can change the default values if needed, otherwise Oracle Cloud Infrastructure Vault will not be provisioned.

    ![Vault Configs](images/orm_vault.png)

## Using Terraform

1. Clone repo

   ```bash
   git clone git@github.com:oracle-quickstart/oci-ods-orm.git
   cd oci-ods-orm/terraform
   ```

1. Create a copy of the file **oci-ods-orm/terraform/terraform.tfvars.example** in the same directory and name it **terraform.tfvars**.
1. Open the newly created **oci-ods-orm/terraform/terraform.tfvars** file and edit the following sections:
    - **TF Requirements** : Add your Oracle Cloud Infrastructure user and tenant details:

        ```text
           #*************************************
           #           TF Requirements
           #*************************************
           
           // Oracle Cloud Infrastructure Region, user "Region Identifier" as documented here https://docs.cloud.oracle.com/en-us/iaas/Content/General/Concepts/regions.htm
           region=""
           // The Compartment OCID to provision artificats within
           compartment_ocid=""
           // Oracle Cloud Infrastructure User OCID, more details can be found at https://docs.cloud.oracle.com/en-us/iaas/Content/API/Concepts/apisigningkey.htm#five
           user_ocid=""
           // Oracle Cloud Infrastructure tenant OCID, more details can be found at https://docs.cloud.oracle.com/en-us/iaas/Content/API/Concepts/apisigningkey.htm#five
           tenancy_ocid=""
           // Path to private key used to create Oracle Cloud Infrastructure "API Key", more details can be found at https://docs.cloud.oracle.com/en-us/iaas/Content/General/Concepts/credentials.htm#two
           private_key_path=""
           // "API Key" fingerprint, more details can be found at https://docs.cloud.oracle.com/en-us/iaas/Content/General/Concepts/credentials.htm#two
           fingerprint=""
        ```

    - **IAM Requirements**: Check default values for IAM artifacts and change them if needed

        ```text
           #*************************************
           #          IAM Specific
           #*************************************
           
           // ODS IAM Group Name (no spaces)
           ods_group_name= "DataScienceGroup"
           // ODS IAM Dynamic Group Name (no spaces)
           ods_dynamic_group_name= "DataScienceDynamicGroup"
           // ODS IAM Policy Name (no spaces)
           ods_policy_name= "DataSciencePolicies"
           // If enabled, the needed OCI policies to manage "OCI Vault service" will be created 
           enable_vault_policies= true
        ```

    - **Vault Specific**: check default values for OCI Vault and change them if needed

        ```text
          #*************************************
          #          Vault Specific
          #*************************************
          // If enabled, an Oracle Cloud Infrastructure Vault along with the needed  policies to manage "Vault service" will be created
          enable_vault= true
          // ODS Vault Name
          ods_vault_name= "Data Science Vault"
          // ODS Vault Type, allowed values (VIRTUAL, DEFAULT)
          ods_vault_type = "DEFAULT"
          // If enabled, a Vault Master Key will be created.
          enable_create_vault_master_key = true
          // ODS Vault Master Key Name
          ods_vault_master_key_name = "DataScienceKey"
          // ODS Vault Master Key length, allowed values (16, 24, 32)
          ods_vault_master_key_length = 32
        ```

1. Open file **oci-ods-orm/terraform/provider.tf** and uncomment the (user_id , fingerprint, private_key_path) in the **_two_** providers (**Default Provider** and **Home Provider**)

    ```text
        // Default Provider
        provider "oci" {
          region = var.region
          tenancy_ocid = var.tenancy_ocid
          ###### Uncomment the below if running locally using terraform and not as Oracle Cloud Infrastructure Resource Manager stack #####
        //  user_ocid = var.user_ocid
        //  fingerprint = var.fingerprint
        //  private_key_path = var.private_key_path
          
        }
        
        
        
        // Home Provider
        provider "oci" {
          alias            = "home"
          region           = lookup(data.oci_identity_regions.home-region.regions[0], "name")
          tenancy_ocid = var.tenancy_ocid
          ###### Uncomment the below if running locally using terraform and not as Oracle Cloud Infrastructure Resource Manager stack #####
        //  user_ocid = var.user_ocid
        //  fingerprint = var.fingerprint
        //  private_key_path = var.private_key_path
        
        }
    ```

1. Initialize terraform provider

    ```bash
    > terraform init
    ```

1. Plan terraform scripts

    ```bash
    > terraform plan
   ```

1. Run terraform scripts

    ```bash
    > terraform apply -auto-approve
   ```

1. To Destroy all created artifacts

    ```bash
    > terraform destroy -auto-approve
   ```

## Contributing

`oci-ods-orm` is an open source project. See [CONTRIBUTING](CONTRIBUTING.md) for details.

Oracle gratefully acknowledges the contributions to `oci-ods-orm` that have been made by the community.
