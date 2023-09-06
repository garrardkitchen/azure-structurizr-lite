param location string = resourceGroup().location
param saName string
param webName string

module sa 'app/sa.bicep' = {
  name: 'sa'
  params: {
    name: saName
    location: location
  }
}

module asp 'app/appservice-plan.bicep' = {
  name: 'asp'
  params: {
    location: location
  }

}
module appservice 'app/appservice.bicep' = {
  name: 'appservice'
  dependsOn: [
    sa
  ]
  params: {
    aspResourceId: asp.outputs.RESOURCE_ID
    location: location
    name: webName
    saName: saName
  }
}

// Added here initially to use MI to access fileshare but Path Mapping 
// in App Service insists on Access Key so commenting out for now:
// module storageMI 'app/managedidentity.bicep' = {
//   name: '${webName}-storage-mi'
//   params: {
//     builtInRoleType: 'StorageFileDataSMBShareContributor'
//     principalId:  appservice.outputs.IDENTITY_PRINCIPAL_ID
//   }
// }
