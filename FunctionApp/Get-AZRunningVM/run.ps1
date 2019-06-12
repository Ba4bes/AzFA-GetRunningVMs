using namespace System.Net

# Input bindings are passed in via param block.
param($Request)
Function Get-RunningVM {
    get-Azvm -Status | Where-Object { $_.PowerState -eq "VM running" }
}
Function Get-RunningVmHTML {
    # HTML header for a nice look
    $Header = @"
<style>
BODY {font-family:verdana;}
TABLE {border-width: 1px; border-style: solid; border-color: black; border-collapse: collapse;}
TH {border-width: 1px; padding: 3px; border-style: solid; border-color: black; padding: 5px; background-color: #d1c3cd;}
TD {border-width: 1px; padding: 3px; border-style: solid; border-color: black; padding: 5px}
</style>
"@

    # Get all running VMs
    $RunningVMs = get-RunningVM
    $runningVmsHTML = $RunningVMs | ConvertTo-Html -property "ResourceGroupName", "Name", "PowerState"


    # Combine HTML elements for output
    $Header + "The Following VMs are still running <p>" + $runningVmsHTML

}
$HTML = Get-RunningVmHTML

Push-OutputBinding -Name Response -Value (@{
        StatusCode  = "ok"
        ContentType = "text/html"
        Body        = $HTML
    })



