$here = (Split-Path -Parent $MyInvocation.MyCommand.Path) -replace "\\Tests"
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'

function Get-AzVm() { }
Set-Alias Get-RunningVM -Value Out-Null
Function TempFunction ($Name, $Value){}
Set-Alias Push-OutputBinding TempFunction
. "$here\FunctionApp\Get-AZRunningVM\$sut"
Remove-Item Alias:Push-OutputBinding
Remove-Item Alias:Get-RunningVM
Remove-Item function:/TempFunction


Describe "Testing Run" {
    Context "dit is de context" {
        $Mockobject = (Get-Content $here\Tests\RunningVMs.json) | ConvertFrom-Json
        Mock Get-AZVm {
            [array]$Mockobject
        }
        $RunningVMs = Get-RunningVmHTML
        $ExampleVMS = Get-RunningVM
        
        It "Output is a string" {
            $RunningVMs.GetType().ToString() | Should be "System.String"
        }
        It "RunningVMs only gives VM that are running" {
            foreach ($VM in $ExampleVMS) {
                $VM.PowerState | Should be "VM Running"
            }
        }
        It "RunningVMs doesn't return VMs that are not running" {
            foreach ($VM in $ExampleVMS) {
                $VM.PowerState | Should not be "VM Deallocated"
            }
        }
        It "All RunningVMs should be in the HTML table" {
            $VMnumbers = $ExampleVMS.Count
            $Tablerows = ([regex]::Matches($RunningVMs, "<tr><td>" )).count
            $VMnumbers | Should be $Tablerows
        }
        It "The Mock is called" {
            Assert-MockCalled Get-AzVM
        }
    }
}

