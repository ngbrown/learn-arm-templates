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

