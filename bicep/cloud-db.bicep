@description('Globally-unique SQL Server name (lowercase, letters/numbers/hyphens).')
param serverName string = 'dev-sqlserver-${toLower(uniqueString(resourceGroup().id))}'

@description('SQL admin login.')
param adminLogin string = 'sqladmin'

@secure()
@description('SQL admin password.')
param adminPassword string

@description('Database name.')
param dbName string = 'dev-sqldb'

@description('DTU/Basic-Standard-Premium SKU')
param skuName string = 'S0' // e.g., Basic|S0|S1|P1...
param skuTier string = 'Standard'

@description('Max DB size in GB')
param maxSizeGB int = 2

// SQL Server
resource sqlServer 'Microsoft.Sql/servers@2021-02-01-preview' = {
  name: serverName
  location: resourceGroup().location
  properties: {
    administratorLogin: adminLogin
    administratorLoginPassword: adminPassword
    version: '12.0'
  }
}

// Database
resource db 'Microsoft.Sql/servers/databases@2021-02-01-preview' = {
  name: '${sqlServer.name}/${dbName}'
  location: resourceGroup().location
  sku: {
    name: skuName
    tier: skuTier
  }
  properties: {
    collation: 'SQL_Latin1_General_CP1_CI_AS'
    maxSizeBytes: maxSizeGB * 1024 * 1024 * 1024
  }
}
