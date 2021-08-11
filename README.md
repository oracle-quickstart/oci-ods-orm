# Provision Oracle Data Science (**_ODS_**) Using Oracle Cloud Infrastructure Resource Manager and Terraform

## Introduction

[![Deploy to Oracle Cloud](https://oci-resourcemanager-plugin.plugins.oci.oraclecloud.com/latest/deploy-to-oracle-cloud.svg)](https://cloud.oracle.com/resourcemanager/stacks/create?zipUrl=https://github.com/oracle-quickstart/oci-ods-orm/releases/download/1.0.6/oci-ods-orm-v1.0.6.zip)

This solution allows you to provision [Oracle Data Science (**_ODS_**)](https://docs.cloud.oracle.com/en-us/iaas/data-science/using/data-science.htm) and all its related artifacts using [Terraform](https://www.terraform.io/docs/providers/oci/index.html) and [Oracle Cloud Infrastructure Resource Manager](https://docs.cloud.oracle.com/en-us/iaas/Content/ResourceManager/Concepts/resourcemanager.htm).

Below is a list of all artifacts that will be provisioned:

| Component    | Default Name            | Optional |  Notes
|--------------|-------------------------|----------|:-----------|
| [ODS Project](https://docs.cloud.oracle.com/en-us/iaas/data-science/using/manage-projects.htm)  | Oracle Cloud Infrastructure Data Science Project     | True     |  -
| [ODS Notebook](https://docs.cloud.oracle.com/en-us/iaas/data-science/using/manage-notebook-sessions.htm) | Oracle Cloud Infrastructure Data Science Notebook(s) | True     | You can provision more than one notebook, and each notebook will be prefixed with an index (x) starting from (0) 
| [Functions](https://docs.cloud.oracle.com/en-us/iaas/Content/Functions/Concepts/functionsconcepts.htm)    | Oracle Cloud Infrastructure Function Application     | True     | Only Oracle Cloud Infrastructure **Functions Application** will be provisioned without a **Function deployment**. This is a placeholder application so you can deploy your model application later on.
| [API Gateway](https://docs.cloud.oracle.com/en-us/iaas/Content/APIGateway/Concepts/apigatewayconcepts.htm)  | Oracle Cloud Infrastructure API Gateway              | True     | Only Oracle Cloud Infrastructure **API Gateway** will be provisioned without an **API Gateway deployment**. The gateway is used to expose the Oracle Cloud Infrastructure Function through a REST interface.
| [Vault](https://docs.cloud.oracle.com/en-us/iaas/Content/KeyManagement/Concepts/keyoverview.htm)            | Oracle Cloud Infrastructure Vault                        | True     | Oracle Cloud Infrastructure Vault can be used to store credentials rather than storing them in ODS Notebook.
| [Vault Master Key](https://docs.cloud.oracle.com/en-us/iaas/Content/KeyManagement/Concepts/keyoverview.htm) | Oracle Cloud Infrastructure Vault Master Key             | True     | Oracle Cloud Infrastructure Vault Master Key can be used encrypt/decrypt credentials for secured access.                             
| [VCN](https://docs.cloud.oracle.com/en-us/iaas/Content/Network/Tasks/managingVCNs.htm#VCNsandSubnets)          | Oracle Cloud Infrastructure VCN                      | True     | Oracle Cloud Infrastructure VCN and all its related artifacts (Subnets, Security Lists, Routing Tables, Internet Gateway, Nat Gateway).
| [Subnets](https://docs.cloud.oracle.com/en-us/iaas/Content/Network/Tasks/managingVCNs.htm#VCNsandSubnets)      | Oracle Cloud Infrastructure VCN Subnets              | True | One **Public Subnet** with its Security List and Routing Table and configured with an Internet Gateway (Hosts API Gateway). One **Private Subnet** and its Security List and Routing Table and configured with a NAT Gateway and hosts (ODS Project, ODS Notebooks, Function)
| [Group](https://docs.cloud.oracle.com/en-us/iaas/Content/Identity/Tasks/managinggroups.htm)        | Oracle Cloud Infrastructure Users Group              | False    | All Policies are granted to this group, you can add users to this group to grant me access to ODS services.
| [Dynamic Group](https://docs.cloud.oracle.com/en-us/iaas/Content/Identity/Tasks/managingdynamicgroups.htm) | Oracle Cloud Infrastructure Dynamic Group           | False    | Dynamic Group for Functions and API Gateway.
| [Policies (compartment)](https://docs.cloud.oracle.com/en-us/iaas/Content/Identity/Concepts/policygetstarted.htm)   | Oracle Cloud Infrastructure Security Policies        | False              | A policy at the compartment level to grant access to ODS, VCN, Functions and API Gateway
| [Policies (root)](https://docs.cloud.oracle.com/en-us/iaas/Content/Identity/Concepts/policygetstarted.htm)    | Oracle Cloud Infrastructure Security Policies        | False              | A policy at the root compartment level to grant access to OCIR in tenancy.

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

- If **Use Existing VCN** is **_NOT_** selected, A new VCN will be created along with all its related artifacts (Subnets, Security Lists, Route Tables, Internet Gateway, NAT Gateway), and all artifacts will be provisioned within that VCN. **_Otherwise_** (Use Existing VCN is selected), you need to select an existing VCN and subnets, then all artifacts will provisioned within the selected VCN and Subnets.

    ![Network Configs](images/orm_network.png)

- If **Provision ODS** is selected, ODS Project and Notebook session will be provisioned, you can change the default values if needed, otherwise no ODS artifacts will be provisioned, _**however**_ all other artifacts (Network, Policies, Function, API Gateway) will be provisioned.

    ![ODS Configs](images/orm_ods.png)

- If **Enable Vault Support** is selected, Oracle Cloud Infrastructure Vault along with all required IAM policies will be provisioned, you can change the default values if needed, otherwise Oracle Cloud Infrastructure Vault will not be provisioned.

    ![Vault Configs](images/orm_vault.png)

- If **Provision Functions and API Gateway** is selected, a **Function** and **API Gateway** will be provisioned. You can change default values if needed. **_Note_** that no **_Function Deployment_** or **_API Gateway Deployment_** will be provisioned.

    ![FUNCTIONS Configs](images/orm_functions_apigateway.png)


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

    - **ODS Requirements** : Check Default values for ODS artifacts and change them if needed

        ```text
           #*************************************
           #           ODS Specific
           #*************************************
           // Provision ODS Project and Notebook
           enable_ods=true
           // ODS Default Project Name
           ods_project_name= "Data Science Project"
           // ODS Notebook Name
           ods_notebook_name = "Data Science Notebook"
           // Default Compute shape to use for a Notebook. Supported VM Shapes:
           //    - VM.Standard.E2.2
           //    - VM.Standard.E2.4
           //    - VM.Standard.E2.8
           //    - VM.Standard2.1
           //    - VM.Standard2.2
           //    - VM.Standard2.4
           //    - VM.Standard2.8
           //    - VM.Standard2.16
           //    - VM.Standard2.24
           // VM Shapes Specs details can be found at https://docs.cloud.oracle.com/en-us/iaas/Content/Compute/References/computeshapes.htm#virtualmachines
           ods_compute_shape="VM.Standard2.1"
           // Notebook storage size in GB, minimum is 50 and maximum is 1024 (1TB)
           ods_storage_size="50"
           // Number of Notebooks to provision, default is 1.
           ods_number_of_notebooks=1
        ```

    - **Network Requirements**: Check default values for Network artifacts and change them if needed

        ```text
            #*************************************
            #         Network Specific
            #*************************************
            
            // Use an existing VCN or create a new VCN along with all its related artifacts 
            ods_vcn_use_existing = false
            
            // VCN Name Default Name. Only Applies if "ods_vcn_use_existing" is set to false
            ods_vcn_name="Data Science VCN"
            // VCN CIDR Space. Only Applies if "ods_vcn_use_existing" is set to false
            ods_vcn_cidr="10.0.0.0/16"
            // Public Subnet Default Name. Only Applies if "ods_vcn_use_existing" is set to false
            ods_subnet_public_name="Data Science - Public"
            // Public Subnet CIDR Space. Only Applies if "ods_vcn_use_existing" is set to false
            ods_subnet_public_cidr = "10.0.0.0/24"
            // Private Subnet Default Name. Only Applies if "ods_vcn_use_existing" is set to false
            ods_subnet_private_name = "Data Science - Private"
            // Private Subnet CIDR Space. Only Applies if "ods_vcn_use_existing" is set to false
            ods_subnet_private_cidr = "10.0.1.0/24"
            
            // Existing VCN OCID. Only Applies if "ods_vcn_use_existing" is set to true
            ods_vcn_existing= ""
            // Existing Public Subnet OCID. Only Applies if "ods_vcn_use_existing" is set to true. Subnet must exists within the selected "existing VCN"
            ods_subnet_public_existing = ""
            // Existing Private Subnet OCID. Only Applies if "ods_vcn_use_existing" is set to true. Subnet must exists within the selected "existing VCN"
            ods_subnet_private_existing = ""
        ```

    - **Functions/API Gateway Requirements**: Check default values for Functions/API Gateway artifacts and change them if needed

        ```text
           #*************************************
           #    Functions/API Gateway Specific
           #*************************************
           
           // Provision Functions Application and its associated API Gateway
           enable_functions_apigateway=true
           // Name of the "Functions Application", no spaces are allowed
           functions_app_name="DataScienceApp"
           // Name of the "API Gateway"
           apigateway_name="Data Science Gateway"       
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
           // ODS IAM Root Policy Name (no spaces)
           ods_root_policy_name= "DataScienceRootPolicies"
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
