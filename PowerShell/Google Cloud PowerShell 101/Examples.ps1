# --- Install the Module from the PowerShell Gallery
Install-Module GoogleCloud -Scope CurrentUser

# --- Login to Google Cloud
gcloud init

# --- Import the Google Cloud Module
Import-Module GoogleCloud

# --- Look at the available cmdlets
Get-Command -Module GoogleCloud

# --- Examine the current project
Get-GcpProject

# --- Create a VM
# --- Where's the New-GCPVM cmdlet?
# --- There isn't one.......
# --- OK. Google Compute Engine VMs are referred to as instances. Where's the New-GCPInstance cmdlet?
# --- There isn't one.......
# --- OK, what do I do?
# --- Well of course, you should use Add‑GceInstance! #facepalm
# --- But first of all you have to define the machine configuration......

# --- Define the project name you want to create the instance in.
$project = "second-folio-233216"

# --- Decide which machine type you want
Get-GceMachineType | Format-Table Name,Zone,Description -AutoSize

Get-GceMachineType | Where-Object {$_.Name -like '*micro*'} | Format-Table Name,Zone,Description -AutoSize

# --- Watch out for this! How many results do you think you will get back?
Get-GceMachineType -Name 'f1-micro' | Format-Table Name,Zone,Description -AutoSize

# --- Decide which image you want
Get-GceImage | Format-Table Name,Family,Description -AutoSize

# --- Watch out if this query returns multiple results!
$image = (Get-GceImage -Family "debian-9")[0]

# --- Define the configuration for an instance called "webserver-1"
$config = New-GceInstanceConfig "webserver-1" -MachineType "f1-micro" -BootDiskImage $image

$config


# Attempt to create the instance based on the configuration
$config | Add-GceInstance -Project $project -Zone "us-central1-b"




# --- Demo the provider