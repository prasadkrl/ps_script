<#
    Author: Prasad
    Date: March 20, 2025
    Description: This script creates a DSN entry in the Windows Registry under
                 HKEY_CURRENT_USER\SOFTWARE\ODBC\ODBC.INI and registers it in 
                 ODBC Data Sources with all required properties for 32bit and 64bit Drivers.
#>

# Define the DSN Name and Driver
$DSNName = "TEST_DSN"
$DriverName = "Simba Spark ODBC Driver"

# Define the Registry Paths
$DSNRegistryPath = "HKCU:\SOFTWARE\ODBC\ODBC.INI\$DSNName"
$DataSourceRegistryPath = "HKCU:\SOFTWARE\ODBC\ODBC.INI\ODBC Data Sources"

# Ensure ODBC Data Sources registry key exists
If (!(Test-Path -Path $DataSourceRegistryPath)) {
    New-Item -Path $DataSourceRegistryPath -Force | Out-Null
}

# Create the DSN registry key if it doesn't exist
If (!(Test-Path -Path $DSNRegistryPath)) {
    New-Item -Path $DSNRegistryPath -Force | Out-Null
}

# Add DSN reference in ODBC Data Sources
Set-ItemProperty -Path $DataSourceRegistryPath -Name $DSNName -Value $DriverName

# Add properties to the registry for the DSN
$Properties = @{
    "Driver" = "Simba Spark ODBC Driver"
    "AcceptUndeterminedRevocation" = "0"
    "AllowHostNameCNMismatch" = "0"
    "AllowInvalidCACert" = "0"
    "AllowSelfSignedServerCert" = "0"
    "ApplySSPWithQueries" = "1"
    "AsyncExecPollInterval" = "100"
    "Auth_Client_ID" = ""
    "Auth_Flow" = "2"
    "AuthMech" = "11"
    "AutoReconnect" = "1"
    "BinaryColumnLength" = "32767"
    "CheckCertRevocation" = "1"
    "DecimalColumnScale" = "10"
    "DefaultStringColumnLength" = "255"
    "DelegateKrbCreds" = "0"
    "DelegationUID" = ""
    "DESCRIPTION" = "Databricks Query"
    "DriverConfigTakePrecedence" = "0"
    "EnableAsyncExec" = "0"
    "EnableAsyncMetadata" = "1"
    "EnableTempTable" = "0"
    "EnableTranslationForCTAS" = "1"
    "EnableUniqueColumnName" = "1"
    "FastSQLPrepare" = "0"
    "FixUnquotedDefaultSchemaNameInQuery" = "1"
    "GetTablesWithQuery" = "0"
    "HDFSTempTableDir" = "/tmp/simba"
    "HDFSUser" = "hdfs"
    "Host" = "<databricks-host>"
    "InvalidSessionAutoRecover" = "1"
    "KrbHostFQDN" = "_HOST"
    "KrbServiceName" = "spark"
    "MaxBytesPerFetchRequest" = "300 MB"
    "Min_TLS" = "1.2"
    "OAuthIgnoreDriverNoPrompt" = "1"
    "OCIIgnoreDriverNoPrompt" = "0"
    "Port" = "443"
    "QueryTimeoutOverride" = ""
    "RowsFetchedPerBlock" = "10000"
    "Schema" = "test-msdc"
    "ServiceDiscoveryMode" = "No Service Discovery"
    "ServicePrincipalCanonicalization" = "1"
    "ShowSystemTable" = "0"
    "SocketTimeout" = "60"
    "SparkServerType" = "3"
    "SSL" = "1"
    "SSOIgnoreDriverNoPrompt" = "1"
    "TempTableTTL" = "10"
    "ThriftTransport" = "2"
    "TrustedCerts" = "C:\path\to\lib\cacerts.pem"
    "TwoWaySSL" = "0"
    "UseLegacyUserAgent" = "0"
    "UseNativeQuery" = "0"
    "UseOnlySSPI" = "0"
    "UseProxy" = "0"
    "UseSystemTrustStore" = "0"
    "UseUnicodeSqlCharacterTypes" = "0"
    "WebHDFSHost" = ""
    "WebHDFSPort" = "50070"
    "HTTPPath" = "/sql/1.0/warehouses/yourwarehouse"
    "LCaseSspKeyName" = ""
}

# Add all properties to the registry
foreach ($Name in $Properties.Keys) {
    Set-ItemProperty -Path $DSNRegistryPath -Name $Name -Value $Properties[$Name] -Force
}

Write-Host "DSN '$DSNName' successfully created and registered in ODBC Data Sources."





<# Configuration

Before running the script, replace the following placeholder values in `$Properties`:

- `<your-databricks-host>` – Your Azure Databricks hostname
- `<your-schema>` – Target database/schema
- `<your-http-path>` – HTTP path for your SQL warehouse
- `<"TrustedCerts">` your CA Certs path
- Any other placeholders depending on your environment
#>
