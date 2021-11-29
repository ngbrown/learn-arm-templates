## learn-json-arm-templates

My working through the Microsoft Docs learning path for [Deploy and manage resources in Azure by using JSON ARM templates](https://docs.microsoft.com/en-us/learn/paths/deploy-manage-resource-manager-templates/).

Connect:

```powershell
Get-AzSubscription
```

```powershell
$context = Get-AzSubscription -SubscriptionId {subscription Id}
Set-AzContext $context
```

If using training sandbox:

```powershell
$context = Get-AzSubscription -SubscriptionName 'Concierge Subscription'
Set-AzContext $context
```

Then:

```powershell
Set-AzDefault -ResourceGroupName {resource group Id}
```

To deploy, run the following Azure PowerShell commands in the terminal:

```powershell
$templateFile = "azuredeploy.json"
$parameterFile = "azuredeploy.parameters.dev.json"
$today=Get-Date -Format "MM-dd-yyyy"
$deploymentName="template-"+"$today"
New-AzResourceGroupDeployment `
 -Name $deploymentName `
 -TemplateFile $templateFile `
 -TemplateParameterFile $parameterFile
```

WhatIf:

```powershell
New-AzResourceGroupDeployment `
 -Name $deploymentName `
 -TemplateFile $templateFile `
 -TemplateParameterFile $parameterFile `
 -WhatIf -WhatIfResultFormat FullResourcePayloads
```

Test:
```powershell
Import-Module ..\arm-ttk\arm-ttk\arm-ttk.psd1
Test-AzTemplate -TemplatePath .\test\
```

Create service principal

```bash
projectName="GitHubActionExercise"
location="westus"
resourceGroupName="${projectName}-rg"
appName="http://${projectName}"

# Create the resource group
az group create --name $resourceGroupName --location $location

# Store the resource group ID in a variable
scope=$(az group list --query "[?contains(name, '$resourceGroupName')].id" -o tsv)

# Create the service principal with contributor rights to the resource group we just created
az ad sp create-for-rbac --name $appName --role Contributor --scopes $scope --sdk-auth
```

Get output from template deployment

```powershell
(Get-AzResourceGroupDeployment -ResourceGroupName $resourceGroupName -Name $deploymentName).Outputs
Get-AzDeploymentScriptLog -ResourceGroupName $resourceGroupName -Name CopyConfigScript
```

Get files added to storage account

```powershell
$storageAccountName = (Get-AzResourceGroupDeployment -ResourceGroupName $resourceGroupName -Name $deploymentName).Outputs.storageAccountName.Value
$storageAccount = Get-AzStorageAccount -ResourceGroupName $resourceGroupName
Get-AzStorageBlob -Context $storageAccount.Context -Container config | Select-Object Name
```

Add secure string to key vault:

```powershell
$KVNAME="tailwind-secrets" + (Get-Random -Count 1 -Maximum 9999999)
$KVNAME
$secretSecureString = ConvertTo-SecureString 'insecurepassword123!' -AsPlainText -Force
$secret = Set-AzKeyVaultSecret -VaultName $KVNAME -Name vmPassword -SecretValue $secretSecureString
```

Get key vault for reference in parameter file:

```powershell
Get-AzKeyVault -VaultName $KVNAME | Select-Object -ExpandProperty ResourceId
```

Store a template spec:

```powershell
New-AzTemplateSpec `
  -ResourceGroupName learn-df8b5cb1-a2c7-4347-a6cb-6a9bf0a7b1e8 `
  -Name ToyCosmosDBAccount `
  -Location westus `
  -DisplayName 'Cosmos DB account' `
  -Description "This template spec creates a Cosmos DB account that meets our company's requirements." `
  -Version '1.0' `
  -TemplateFile azuredeploy.json
```

Deploy a template spec:

```powershell
$templateSpecVersionResourceId = (`
   Get-AzTemplateSpec `
      -ResourceGroupName learn-df8b5cb1-a2c7-4347-a6cb-6a9bf0a7b1e8 `
      -Name ToyCosmosDBAccount `
      -Version 1.0 `
   ).Versions[0].Id
New-AzResourceGroupDeployment -TemplateSpecId $templateSpecVersionResourceId
```

Export a template spec:

```powershell
Export-AzTemplateSpec `
  -ResourceGroupName learn-df8b5cb1-a2c7-4347-a6cb-6a9bf0a7b1e8 `
  -Name ToyCosmosDBAccount `
  -Version 1.0 `
  -OutputFolder ./export
```

Get own user account's principle ID:

```powershell
$token = (Get-AzAccessToken -ResourceUrl "https://graph.windows.net/").Token
$userObjectId = (Invoke-RestMethod -Uri 'https://graph.windows.net/me?api-version=1.6' -Headers @{ 'Authorization' = "Bearer $token"}).objectID
```

