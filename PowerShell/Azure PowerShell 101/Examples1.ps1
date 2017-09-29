# --- Login to your Azure Subscription
Login-AzureRmAccount

# --- 'Login' is not an approved PowerShell verb!
Get-Verb | Sort-Object verb

Get-Command Login-AzureRmAccount | Format-Table Name,ReferencedCommand

# --- Login with Credential
$cred = Get-Credential
Add-AzureRmAccount -Credential $cred

# --- WTF? https://github.com/Azure/azure-powershell/issues/3108





# --- Rubbish error messages
# --- Create a SQL Server which already exists in somebody elese's subscription
New-AzureRmSqlServer -ResourceGroupName "532" -Location "UKSouth" -ServerName "Server01" -ServerVersion "12.0" -SqlAdministratorCredentials $cred

# --- Generates this error:
# --- New-AzureRmSqlServer - Long running operation failed with status 'Failed'
# --- Not very helpful!

# --- The SQL Server name needs to be unique across Azure xxxx.database.windows.net
New-AzureRmSqlServer -ResourceGroupName "532" -Location "UKSouth" -ServerName "532test" -ServerVersion "12.0" -SqlAdministratorCredentials $cred



