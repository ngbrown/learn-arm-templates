<#
.SYNOPSIS
Ensures that all parameters adheres to a naming standard
.DESCRIPTION
All parameters should start with the company specific prefix 'tailwind'
#>
param (
    # The Template Object
    [Parameter(Mandatory=$true, Position=0)]
    [PSObject]
    $TemplateObject,

    # The Template JSON Text
    [Parameter(Mandatory=$true, Position=0)]
    [psobject]
    $TemplateText
)

foreach ($parameter in $TemplateObject.parameters.psobject.properties) {
    # If the parameter name starts with tailwind, then the parameter is correctly named
    if ($parameter.Name -notmatch 'tailwind') {
        Write-Error "Parameter '$($parameter.Name)' must start with prefix 'tailwind'" -TargetObject $parameter
    }
}
