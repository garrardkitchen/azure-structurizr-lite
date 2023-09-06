# Information

This is not production ready so do not use to model sensitive software systems.

[deploy.ps1](deploy.ps1) creates a RG and deploys a Web App for Container App Service, it's App Service Plan and a Storage Account.  The multi-container deploys [structurizr](www.c4model.com).  A sample model dsl is uploaded to a `demo` fileshare in the Storage Account.

The C4 model is a set of hierarchical abstractions (software systems, containers, components, and code).

> _In order to create these maps of your code, we first need a common set of abstractions to create a ubiquitous language that we can use to describe the static structure of a software system. A software system is made up of one or more containers (applications and data stores), each of which contains one or more components, which in turn are implemented by one or more code elements (classes, interfaces, objects, functions, etc). And people may use the software systems that we build._

Benefits:
- You do not need to create separate diagrams to describe your software system
- Holistic view to help onboard new starters
- Themes to provide additional cloud provider context
- Notation to enrich abstractions and their relationships
- Export (from in-app or from CLI) to mermaid, draw.io, PlantUML and other alternatives
- Build into DevOps pipeline
- SDKs to dynamically create models to reflect current state of your software system
- Inherency; Workspace extension - _The Structurizr DSL provides a way to extend an existing workspace, enabling you to reuse common elements/relationships across multiple workspaces._

# Prerequisite

- Azure Powershell modules
- Powershell 7+
- bicep

# Getting started

Run:

```powershell
./deploy.ps1 -resourceGrooup "<resource-group>" -storageAccountName "<globally-unique-storage-account>" -appServiceName "<globally-unique-app-service>"
```

To upload changes to your model dsl:

```powershell
$uploadstorage = Get-AzStorageAccount -ResourceGroupName "<resource-group>" -Name "<globally-unique-storage-account>"
Set-AzStorageFileContent -ShareName "demo" -Source "structurizr/workspace.dsl" -Path "workspace.dsl" -Context $uploadstorage.Context -Force
```
# ToDos

- Add VNET to restrict access to dsl model on Fileshare from Private Endpoint
- Restrict access to App Service from within VNET
- Add VM from where you can access the App Service
- Add Bastion to access VM from