#clear screen
cls

# Build App
$zipdFile = "..\..\BulkOperations\_Published.zip"
Write-Host "Publish Location $($zipdFile)"

#Prompt & Install Azure CLI
$installConfirmation = Read-Host "Do you want to install Azure CLI? (Y/N)"
if ($installConfirmation  -eq "Y" -or $installConfirmation  -eq "y") {
    $ProgressPreference = 'SilentlyContinue'; Invoke-WebRequest -Uri https://aka.ms/installazurecliwindows -OutFile .\AzureCLI.msi; Start-Process msiexec.exe -Wait -ArgumentList '/I AzureCLI.msi /quiet'; Remove-Item .\AzureCLI.msi
}

$loginToSubscription = Read-Host "Do you want to login to the subscription? (Y/N)"
# Conditionally login to Azure based on user input
if ($loginToSubscription -eq "Y" -or $loginToSubscription -eq "y") {
    az login
}

#Uniquekey
$appGeneratedId = (get-date).ticks
$systemUserName = [Environment]::UserName

# Prompt the user for input
$subscriptionId = Read-Host "Enter Azure Subscription ID"
$resourceGroupName = Read-Host "Enter Resource Group Name"
$appStorageAccountName = Read-Host "Enter Storage account Name (lowercase alphabets ONLY)"


$keyVaultUrl = "https://<KeyVaultURL>.vault.azure.net/"

#Auto-Generated Values
$appName = "$($systemUserName)$($appGeneratedId)"
$appSharedName = "$($systemUserName)_share"
$appHostingPlanName = "ASP-$($appName)-$($appGeneratedId)"



Write-Host "Name  $($appName)"
#Generate Paramaters for Deployment 


#Generate Paramaters for Deployment 
$template = @{
  "contentVersion"= "1.0.0.0"
  "parameters" = @{
    "subscriptionId" = @{
     
      "value"= "$subscriptionId"
      }
      "name"= @{
       "value"= "$appName"
      }
     "location" = @{
      "value"= "East US"
     }
    
    "use32BitWorkerProcess" = @{
      "value" = $false
    }
    "ftpsState"= @{
      "value"= "FtpsOnly"
    }
    "storageAccountName"= @{
      "value"= "$appStorageAccountName"
    }
    "netFrameworkVersion"= @{
      "value"= "v6.0"
    }
    "sku"= @{
      "value"= "ElasticPremium"
    }
    "skuCode"= @{
      "value"= "EP3"
    }
    "workerSize"= @{
       "value" = "5"
    }
    "workerSizeId"= @{
      "value"= "5"
    }
    "numberOfWorkers"= @{ 
      "value"= "5"
    }    
    "hostingPlanName"= @{
      "value"= "$appHostingPlanName"
    }
    "serverFarmResourceGroup"= @{
      "value"= "$resourceGroupName"
    }
    "alwaysOn"= @{
       "value" = $false
    }
    "websiteContentName"= @{
      "value" = "$appSharedName"
    }
    "keyVaultUrl" = @{
      "value" = "$keyVaultUrl"
    }
   }
 }

$filePath = "parameters.json"
$template | ConvertTo-Json -Depth 2 | Set-Content  -Path $filePath

#Create Resource Group
#az functionapp create --resource-group $resourceGroupName -location "eastus"

Write-Host "Setting the Subscription Id As Default"

az account set -s $subscriptionId

Write-Host "Deploying new Function"

az deployment group create --resource-group $($resourceGroupName) --name $($appGeneratedId) --template-file deployment.json --parameters parameters.json

Write-Host "Deploying Source Code"
az functionapp deployment source config-zip --resource-group $resourceGroupName --name $appName --src $zipdFile

