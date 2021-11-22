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