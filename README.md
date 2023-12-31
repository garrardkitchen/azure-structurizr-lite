# Information

This is not production ready so do not use to model sensitive software systems.

[deploy.ps1](deploy.ps1) creates a RG and deploys a Web App for Container App Service, it's App Service Plan and a Storage Account.  The multi-container deploys [structurizr](https://www.c4model.com).  A sample model dsl is uploaded to a `demo` fileshare in the Storage Account.

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


---

**The 4 Cs**

- **Context** - The big picture with the focus on Actors, Roles, Personas and the like as well as software systems instead of technology, protocols and low-level details
- **Container** - Web application, desktop application, mobile app, database, file systems and the like. Essentially, a container is anything that can host code or data
- **Component** - Major logical components and their interactions. This is all about partitioning the functionality implemented by the software system into a number of distinct components, services, subsystems, layers, workflows and the like.  A component diagram shows how a container is divided into components, what each of those components are, their responsibilities and the technology and implementation details
- **Code** - This level is optional.  Includes UML describing specific component implementation details
---

# Prerequisite

- Azure Powershell modules
- Powershell 7+
- bicep

---

# Getting started

## Deploy via the command line

**Step 1** - Log onto Azure

```powershell
Connect-AzAccount
```

**Step 2** - Deploy infra and upload sample model dsl

```powershell
./deploy.ps1 -resourceGrooup "<resource-group>" -storageAccountName "<globally-unique-storage-account>" -appServiceName "<globally-unique-app-service>"
```

**Step 3** - Navigate to App Service and click `Default domain` link on it's `Overview` blade.

---

## How to apply new changes to your dsl model

To upload changes to your model dsl:

```powershell
$uploadstorage = Get-AzStorageAccount -ResourceGroupName "<resource-group>" -Name "<globally-unique-storage-account>"
Set-AzStorageFileContent -ShareName "demo" -Source "structurizr/workspace.dsl" -Path "workspace.dsl" -Context $uploadstorage.Context -Force
```

---

## Deploy via an ADO Pipeline

**Step 1** - Create a new Project in ADO

**Step 2** - Add Azure Resource Manager Service Connection named `subscription` and select your subscription

**Step 3** - Add existing pipeline [.azdo/pipelines/azure-dev.yml](.azdo/pipelines/azure-dev.yml)

**Step 4** - Run pipeline and enter global unique name (both storage account and web app need to be globally unique)

---

# ToDos

- [x] Added ADO Pipeline
- [ ] Add VNET to restrict access to dsl model on Fileshare from Private Endpoint
- [ ] Restrict access to App Service from within VNET
- [ ] Add VM from where you can access the App Service
- [ ] Add Bastion to access VM from