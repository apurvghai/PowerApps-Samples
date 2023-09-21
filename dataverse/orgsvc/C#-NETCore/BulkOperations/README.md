---
ArtifactType: azfunc
Language: csharp, powershell, markdown
Platform: windows
Tags: dataverse performance, dataverse hyperscale, dataverse data import sample
---

# Dataverse - Bulk Operations Sample

This sample allows you to import data to a Dataverse instance using Elastic and SQL (Standard) tables. The sample is designed to run on the Azure Function Premium plan to achieve maximum throughput. It includes a PowerShell script to simulate an Azure function following Azure Function throttle limits for invoking the web request.

To learn more about [Elastic Tables](https://learn.microsoft.com/en-us/power-apps/maker/data-platform/create-edit-elastic-tables)


## Getting Started

These instructions will get you a copy of the project up and running on your local machine for development and testing purposes. 

## Prerequisites

- Powershell 7
- Net 6.0
- Visual Studio 2022

## Setup & Deployment

 ### Pre-Deployment Steps

 * Create Azure KeyVault using these [instructions](https://learn.microsoft.com/en-us/azure/key-vault/general/quick-create-portal?_blank).
 * Register an application in Azure using these [instructions](https://learn.microsoft.com/en-us/azure/active-directory/develop/quickstart-register-app?_blank)
 * Generate a Application Secret and store in Azure Key Vault. Example [here](https://learn.microsoft.com/en-us/azure/industry/training-services/microsoft-community-training/frequently-asked-questions/generate-new-clientsecret-link-to-key-vault?_blank). Make a note of Secret key name. You will need while during the deployment process. 
 * Create an application user in Dataverse Instance. Here are [instructions](https://learn.microsoft.com/en-us/power-platform/admin/manage-application-users?_blank). 
 Provide the application ID from previous step.

 * Create an Entity in Dataverse. See the schema [here](./BulkOperations/EntitySchema.cs)

  
  ```csharp
    // Create an Elastic Table with following fields. If you plan to choose your own prefix. Please update the following constants

    public class ElasticTableEntitySchema
    {
        public const string EntityName = "new_elasticaccount"; //Entity Schema name
        public const string Name = "new_name";  //TextField
        public const string PhoneNumber = "phonenumber"; //WholeNumber
        public const string PhoneNumberOne = "phonenumber1"; //WholeNumber
        public const string CityOne = "city1"; //Text
        public const string TTLInSeconds = "TTLInSeconds"; //OOB Field. 
    }

  // Create a Standard Entity Table with following fields. If you plan to choose your own prefix. Please update the following constants
    public class StandardTableEntitySchema
    {
        public const string EntityName = "cr552_sqltabletwo"; //Entity Schema name
        public const string Name = "cr552_name"; //Text Field
        public const string PhoneNumber = "cr552_phonenumber"; //WholeNumber
        public const string PhoneNumberOne = "cr552_phonenumber1"; //Whole Number
        public const string CityOne = "cr552_city1"; //Text Field
    }
  ```

 

 ### Deployment

 * Load the solution file (`Microsoft.Support.Dataverse.Samples.BulkOperations.sln`) project in Visual Studio.
 * Compile & Run Build (`Ctrl + Shift + B`)
 * Post Build Events will produce a `_Published.zip` file. That is ready for deployment.
 * Begin deployment by executing `PowerShell\Deployment.ps1` in Powershell.
 * This powershell will ask you inputs. Once those are provided successfully. It will create a storage account, az function, azure app service plan etc..,

  > [!IMPORTANT]
  > You must create azure keyvault manually or one should exist. 

 * This Powershell will also deploy the code to your newly created Azure function.

 ### Permissions 

 Once the azure function is created. You must assign it a permission to read the secrets. In order to do to, go to your newly created function and enable managed identity.

  ### Managed Identity
   * Navigate to Resource Group (Azure Portal) > Open Function > Identity > Status
   * Toggle On
   * Save

  ### Assign Key Vault Permissions
   * Navigate to Resource Group (Azure Portal) > Go to Key Vault > Access Policies > Create
   * Select Get, List in Secret Permissions
   * Hit Next 
   * Select your Azure Function Identity
   * Hit Next, thenm Create

   > [!IMPORTANT] If you key vault is enabled for `Azure role-based access control`. Then you must assign RBAC Role of `Key Vault Secrets officer` to that system identity.

 ### Post Deployment (Testing the app)

  Congratulations! You have deployed your application and you are ready to test it. 

  * Run `Powershell\InvokeAzureFunction.ps1` in **Powershell 7**.
  * It will prompt you for inputs. Please carefully provide the inputs.

### General Sample Flow

- The organization instance is referenced via an environment variable (DataverseInstance).
- Create Elastic Table and SQL Table (Refer ElasticTableEntitySchema & StandardTableEntitySchema) to see the names of fields etc..,
- When the app runs, the secret is automatically fetched from the Key Vault.

## Authors

- Apurv Ghai - Principal Embedded Escalation Engineer (Microsoft Customer Support & Service)
- Nikhil Aggarwal - Group Engineering Manager (Microsoft Dataverse)


