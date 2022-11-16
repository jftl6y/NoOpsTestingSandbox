@description('Azure region for the deployment, resource group and resources.')
param location string
param extendedLocation object = {
}

@description('Name of the virtual network resource.')
param virtualNetworkName string = 'myVnet'

@description('Optional tags for the resources.')
param tagsByResource object = {
}

@description('Array of address blocks reserved for this virtual network, in CIDR notation.')
param addressPrefixes array = [
  '10.1.0.0/16'
]

@description('Array of subnet objects for this virtual network.')
param subnets array = [
  {
    name: 'default'
    properties: {
      addressPrefix: '10.1.1.0/24'
    }
  }
]

@description('Enable DDoS Protection Standard on this virtual network.')
param ddosProtectionPlanEnabled bool = false

@description('Create a DDoS Protection Standard plan.')
param ddosProtectionPlanIsNew bool = false

@description('Name of the DDoS Protection Standard plan.')
param ddosProtectionPlanName string = '${virtualNetworkName}-DDoS'
param ddosProtectionPlanId string = ''

@description('Enable Azure Firewall on this virtual network.')
param firewallEnabled bool = false

@description('Name of the Azure Firewall resource.')
param firewallName string = '${virtualNetworkName}-Firewall'

@description('Create a Public IP address for Azure Firewall.')
param firewallPublicIpAddressIsNew bool = false

@description('Name of the Public IP address resource.')
param firewallPublicIpAddressName string = '${firewallName}-PublicIP'
param firewallSkuTier string = 'Standard'
param firewallPolicyIsNew bool = false

@description('Name of the Firewall Policy address resource.')
param firewallPolicyName string = ''

@description('Enable Azure Bastion on this virtual network.')
param bastionEnabled bool = false

@description('Name of the Azure Bastion resource.')
param bastionName string = '${virtualNetworkName}-Bastion'

@description('Create a Public IP address for Azure Bastion.')
param bastionPublicIpAddressIsNew bool = false

@description('Name of the Azure Bastion resource.')
param bastionPublicIpAddressName string = '${bastionName}-PublicIP'
param natGatewaysWithNewPublicIpAddress array
param natGatewaysWithoutNewPublicIpAddress array

@description('Array of public ip addresses for NAT Gateways.')
param natGatewayPublicIpAddressesNewNames array

@description('Array of NAT Gateway objects for subnets.')
param networkSecurityGroupsNew array
param ipv6Enabled bool
param subnetCount int
param addressSpaceStartingAddressChanged bool
param addressSpaceAddressSizeChanged bool
param defaultSubnetChanged bool
param subnetsInfo array

var ddosProtectionPlan_var = {
  id: ddosProtectionPlanId
}

var virtualNetworkId = virtualNetwork.id
var standardSku = {
  name: 'Standard'
}
var staticAllocation = {
  publicIPAllocationMethod: 'Static'
}
var premiumTier = {
  tier: 'Premium'
}

resource virtualNetwork 'Microsoft.Network/virtualNetworks@2020-11-01' = {
  name: virtualNetworkName
  location: location
  extendedLocation: (empty(extendedLocation) ? json('null') : extendedLocation)
  properties: {
    addressSpace: {
      addressPrefixes: addressPrefixes
    }
    subnets: subnets
    enableDdosProtection: ddosProtectionPlanEnabled
    ddosProtectionPlan: (ddosProtectionPlanEnabled ? ddosProtectionPlan_var : json('null'))
  }
  dependsOn: [

  ]
}
