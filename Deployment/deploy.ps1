param(
    [Parameter(Mandatory = $true)]
    [string]$DeploymentOutput
)
Write-output "DeploymentOutput:" $DeploymentOutput

$ID = ($DeploymentOutput | ConvertFrom-Json ).principalId.Value

$Context = Get-AzurermContext
try {
    New-AzureRmRoleAssignment -ObjectId $ID -RoleDefinitionName Contributor -Scope "/subscriptions/$($Context.Subscription)" -ErrorAction SilentlyContinue | Out-Null
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