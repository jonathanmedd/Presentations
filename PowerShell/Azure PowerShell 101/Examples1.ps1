# --- Login to your Azure Subscription
Login-AzureRmAccount

# --- 'Login' is not an approved PowerShell verb!
Get-Verb l* | Sort-Object verb

Get-Command Login-AzureRmAccount | Format-Table Name,ReferencedCommand

# --- Have you never heard of Connect?
Get-Verb Connect

# --- Login with Credential
$cred = Get-Credential
Add-AzureRmAccount -Credential $cred

# --- "Sequence contains no elements" - WTF? 
Start-Process 'chrome.exe' https://github.com/Azure/azure-powershell/issues/3108

# --- MS accounts (that is, accounts that are not work or school accounts) cannot be used in the non-interactive flow.
# --- Create a Service Principal and use that account instead: https://gist.github.com/devigned/dae74a7ca54000f7b714

# --- Check out the different modules
Get-Module AzureRM,Azure | Sort -Desc

Get-Module Azure* -ListAvailable

# --- Let's create a VM
# --- Hold on a minute, isn't it just New-AzureRmVM?
# --- Errr...no


# --- Create the Resource Group
New-AzureRmResourceGroup -Name Azure101 -Location UKSouth

# --- Create Networking Resources
# --- Create a subnet configuration
$subnetConfig = New-AzureRmVirtualNetworkSubnetConfig -Name Azure101 -AddressPrefix 192.168.1.0/24

# --- Create a virtual network
$vnet = New-AzureRmVirtualNetwork -ResourceGroupName Azure101 -Location UKSouth `
    -Name vNET101 -AddressPrefix 192.168.0.0/16 -Subnet $subnetConfig

# --- Create a public IP address and specify a DNS name
$pip = New-AzureRmPublicIpAddress -ResourceGroupName Azure101 -Location UKSouth `
    -AllocationMethod Dynamic -IdleTimeoutInMinutes 4 -Name "mypublicdns$(Get-Random)"

# --- Create a Network Security Group
# --- Create an Inbound network security group rule for port 3389
$nsgRuleRDP = New-AzureRmNetworkSecurityRuleConfig -Name myNetworkSecurityGroupRuleRDP  -Protocol Tcp `
-Direction Inbound -Priority 1000 -SourceAddressPrefix * -SourcePortRange * -DestinationAddressPrefix * `
-DestinationPortRange 3389 -Access Allow

# --- Create a network security group
$nsg = New-AzureRmNetworkSecurityGroup -ResourceGroupName Azure101 -Location UKSouth `
-Name myNetworkSecurityGroup -SecurityRules $nsgRuleRDP

# --- Create a virtual network card and associate with public IP address and NSG
# --- Look at the IDs
$vnet.Subnets[0].Id
$pip.Id
$nsg.Id

# --- Create the NIC
$nic = New-AzureRmNetworkInterface -Name myNic -ResourceGroupName Azure101 -Location UKSouth `
-SubnetId $vnet.Subnets[0].Id -PublicIpAddressId $pip.Id -NetworkSecurityGroupId $nsg.Id

# --- Create the Storage Account - Not needed anymore with managed disks
#$storageAccount = New-AzureRmStorageAccount -ResourceGroupName Azure101 -Name storageaccountazure101 -Type Premium_LRS -Location UKSouth


# --- Create a credential object to use for the Guest OS
$securePassword = ConvertTo-SecureString "SuperMario2017" -AsPlainText -Force
$guestOSCred = New-Object System.Management.Automation.PSCredential ("jmedd", $securePassword)

# --- How do I tell what VM Sizes are available?
$resources = Get-AzureRmResourceProvider -ProviderNamespace Microsoft.Compute
$resources.ResourceTypes.Where{($_.ResourceTypeName -eq 'virtualMachines')}.Locations

# --- Note in some places you use them, they may not have spaces!
Get-AzureRmVmSize -Location "UKSouth" | Sort-Object Name | ft Name, NumberOfCores, MemoryInMB, MaxDataDiskCount -AutoSize

# Create a virtual machine configuration
$vmConfig = New-AzureRmVMConfig -VMName AzureDemo101 -VMSize Standard_A1 | `
Set-AzureRmVMOperatingSystem -Windows -ComputerName Azure101 -Credential $guestOSCred | `
Set-AzureRmVMSourceImage -PublisherName MicrosoftWindowsServer -Offer WindowsServer `
-Skus 2016-Datacenter -Version latest | Add-AzureRmVMNetworkInterface -Id $nic.Id

$vmConfig

# --- Create the VM!
New-AzureRmVM -ResourceGroupName Azure101 -Location UKSouth -VM $vmConfig -WhatIf

# --- Create a Blob Storage Container
# --- First of create a Storage Account
New-AzureRmStorageAccount -ResourceGroupName "Azure101" -AccountName "storageaccountabcd101" -Location "UKSouth" -SkuName "Standard_GRS"

# --- Nothing returned as an AzureRM cmdlet for creating a Storage Container
Get-Command *StorageContainer*

# --- Set the 'current' Storage Account
# --- Note the weird response of the name
Set-AzureRmCurrentStorageAccount -ResourceGroupName "Azure101" -Name "storageaccountabcd101"

# --- Now we can create the Storage Container with a cmdlet from the Classic module
New-AzureStorageContainer -Name test01

# --- Rubbish error messages
# --- Create a SQL Server which already exists in somebody else's subscription
$securePassword = ConvertTo-SecureString "SuperMario2017" -AsPlainText -Force
$sqlCred = New-Object System.Management.Automation.PSCredential ("jmedd", $securePassword)
New-AzureRmSqlServer -ResourceGroupName "Azure101" -Location "UKSouth" -ServerName "Server01" -ServerVersion "12.0" -SqlAdministratorCredentials $sqlCred

# --- Generates this error:
# --- New-AzureRmSqlServer - Long running operation failed with status 'Failed'
# --- Not very helpful!

# --- The SQL Server name needs to be unique across Azure xxxx.database.windows.net
# --- Already prepared earlier because it takes a while
# --- New-AzureRmResourceGroup -Name "SQLDemo" -Location UKSouth
# --- New-AzureRmSqlServer -ResourceGroupName "SQLDemo" -Location "UKSouth" -ServerName "532test" -ServerVersion "12.0" -SqlAdministratorCredentials $sqlCred

# --- Create a database
New-AzureRmSqlDatabase -ResourceGroupName "SQLDemo" -ServerName "532test" -DatabaseName "Database01" -SampleName AdventureWorksLT

# --- Create a SQL Firewall Rule
# --- Get current public IP
$ip = Invoke-RestMethod http://ipinfo.io/json | Select-Object -ExpandProperty ip

$ip

# --- Create a SQL FirewallRule for the current IP
New-AzureRmSqlServerFirewallRule -ResourceGroupName "SQLDemo" -ServerName "532test" `
 -FirewallRuleName "Rule01" -StartIpAddress $ip -EndIpAddress $ip

# --- Use Visual Studio Express SQL Browser to view the database


 


# --- ARM Template

# --- Create another Resource Group
New-AzureRmResourceGroup -Name ARMTemplates -Location UKSouth

# --- Deploy from the ARM template
# --- Note: in this example I have the JSON files local, however it is possible to
# --- deploy straight from GitHub with the parameters TemplateURI and TemplateParameterUri
New-AzureRmResourceGroupDeployment -Name ExampleDeployment -ResourceGroupName ARMTemplates `
-TemplateFile .\ARM\storageaccountdeploy.json `
-TemplateParameterFile .\ARM\storageaccountdeploy.parameters.json

# --- ARM templates are idemopotent, so if change something in the Storage Account
# --- Note - no pipeline input for Set-AzureRmStorageAccount!
$storageAccountName = (Get-AzureRmStorageAccount -ResourceGroupName ARMTemplates).StorageAccountName
Set-AzureRmStorageAccount -ResourceGroupName ARMTemplates -Name $storageAccountName -SkuName Standard_LRS

# --- Run the deployment again
New-AzureRmResourceGroupDeployment -Name ExampleDeployment -ResourceGroupName ARMTemplates `
-TemplateFile .\ARM\storageaccountdeploy.json `
-TemplateParameterFile .\ARM\storageaccountdeploy.parameters.json


# --- Azure Cloud PowerShell Demo
cd 'Visual Studio Enterprise with MSDN'
cd .\ResourceGroups\

Get-AzureRmResourceGroup

# --- Other cool things
Get-CloudDrive

git --version

cd C:\Users\ContainerAdministrator\clouddrive
vim

# --- PSCore6 in PowerShell Cloudshell
$PSVersionTable

& 'C:\Program Files\PowerShell\6.0.0-beta.7\powershell.exe'

$PSVersionTable

# --- PowerShell in Bash Cloud Shell?
powershell

# --- https://twitter.com/Steve_MSFT/status/912721369510567936/photo/1
# --- https://twitter.com/Steve_MSFT/status/912720032764895232/photo/1

# --- Experimental
docker run -it azuresdk/azure-powershell-core-experiments

Login-AzureRmAccount

# --- Fill out the PublicIpAddressName
$PublicIPAddress = #"mypublicdns16408418002"

New-AZVM -name jmtest101323 -virtualnetworkname vNET101 -location uksouth -securitygroupname myNetworkSecurityGroup `
  -PublicIpAddressName $PublicIPAddress #-ResourceGroupName Azure101 -SubnetName Azure101

