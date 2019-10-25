param(
    [Parameter(Mandatory = $true)]
    [string]$FunctionAppName
)

$FunctionApp = Get-AzWebApp -Name $FunctionAppName
Set-AzWebApp -AssignIdentity $true -Name $FunctionApp.Name -ResourceGroupName $FunctionApp.ResourceGroup
Write-Output "$FunctionAppName is now a managed Identity. Waiting 30 seconds for assigning permissions"
Start-sleep 30

$ID = (Get-AzADServicePrincipal -DisplayName $FunctionAppName).id

$Context = Get-AzContext
try {
    New-AzRoleAssignment -ObjectId $ID -RoleDefinitionName Reader -Scope "/subscriptions/$($Context.Subscription)" | Out-Null
    Write-Output "$ID has been added as Contribitor"
}
Catch {
    if ($_.Exception.Message -like "*The role assignment already exists*") {
        Write-Output "$ID was aleady added as contribitor"
    }
    if ($_.Exception.Message -like "*Exception of type 'Microsoft.Rest.Azure.CloudException' was thrown.*") {
        Write-Output "A general error was thrown, please check assignment"
    }
    else {
        Write-Error $_
        Write-Error "ERROR: Could not add $ID as Contribitor"

    }
}
