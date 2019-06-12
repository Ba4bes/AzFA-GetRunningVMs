# FA Get-RunningVMs

This repository contains an Azure Function App running PowerShell.
The app generates an URL, through which a webpage can be generated that shows all running VMs in a subscription.

## Components

- **Deployment**  
  This folder contains an ARM template to deploy the app, and a PowerShell script that sets the apps permissions
- **FunctionApp**  
  This is the code for the Funtion app itself
- **Tests**  
  Pester tests for the PowerShell script inside the function app
  Azure-pipelines.yml
  a pipeline to test and deploy this app through Azure DevOps

## Howto

For more information and guidance, please see the following blogposts:

[4bes.nl Configure Azure Functions for PowerShell in the portal](http://4bes.nl/2019/06/05/configure-azure-functions-for-powershell-in-the-portal)

