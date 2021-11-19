Connect:

```powershell
Get-AzSubscription
```

```powershell
$context = Get-AzSubscription -SubscriptionId {Concierge subscription ID}
```

```powershell
Set-AzContext $context
Set-AzDefault -ResourceGroupName {Learn Resource Group Id}
```

To deploy, run the following Azure PowerShell commands in the terminal:

```powershell
$templateFile = "azuredeploy.json"
$today=Get-Date -Format "MM-dd-yyyy"
$deploymentName="blanktemplate-"+"$today"
New-AzResourceGroupDeployment `
 -Name $deploymentName `
 -TemplateFile $templateFile `
 -storageName learnexercise53183 `
 -storageSKU Standard_GRS
```

