# --- Install the Module from the PowerShell Gallery
Install-Module GoogleCloud -Scope CurrentUser

# --- Login to Google Cloud
gcloud init

# --- Import the Google Cloud Module
Import-Module GoogleCloud

# --- Look at the available cmdlets
Get-Command -Module GoogleCloud

# --- Examine the current project
# --- Watch out for the project name, might not match the Projectid
# --- My project was named "My First Project", but the Projectid is "second-folio-233216"
# --- I had to rename the project in the GUI to "second-folio-233216"
# --- before some of the cmdlets would work
Get-GcpProject

# --- Create a VM
# --- Where's the New-GCPVM cmdlet?
# --- There isn't one.......
# --- OK. Google Compute Engine VMs are referred to as instances. Where's the New-GceInstance cmdlet?
# --- There isn't one.......
# --- OK, what do I do?
# --- Well of course, you should use Add‑GceInstance! #facepalm
# --- But first of all (according to the documentation - https://googlecloudplatform.github.io/google-cloud-powershell/#/google-compute-engine)
# --- you have to define the machine configuration......
Start-Process 'https://googlecloudplatform.github.io/google-cloud-powershell/#/google-compute-engine'

# --- Define the project, region and zone you want to create the instance in.
$project = "second-folio-233216"
$region = "us-central1"
$zone = "us-central1-b"

# --- Decide which machine type you want
Get-GceMachineType | Format-Table Name,Zone,Description -AutoSize

Get-GceMachineType | Where-Object {$_.Name -like '*micro*'} | Format-Table Name,Zone,Description -AutoSize

# --- Watch out for this! How many results do you think you will get back?
Get-GceMachineType -Name 'f1-micro' | Format-Table Name,Zone,Description -AutoSize







# --- if you use the Name parameter, you have to use the Zone parameter
Get-GceMachineType -Name 'f1-micro' -Zone $zone | Format-Table Name,Zone,Description -AutoSize

# --- Decide which image you want
Get-GceImage | Format-Table Name,Family,Description -AutoSize

# --- Watch out if this query returns multiple results!
$image = (Get-GceImage -Family "debian-9")

$image | Format-Table Name,Family,Id -AutoSize

# --- So we just pick the first one
$image = (Get-GceImage -Family "debian-9")[0]

# --- Define the configuration for an instance called "webserver-1"
$config = New-GceInstanceConfig -Name "webserver1" -MachineType "f1-micro" -BootDiskImage $image -Region $region

$config

# --- Attempt to create the instance based on the configuration
$config | Add-GceInstance -Project $project -Region $region -Zone $zone


# --- Instead take the direct approach
Add-GceInstance -Name "webserver1" -BootDiskImage $image -MachineType "f1-micro" -Project $project -Region $region -Zone $zone


Get-GceInstance

# --- What do you think should happen here?
# --- Pretty dangerous right?
# --- So it should have ConfirmPreference set?
Get-GceInstance | Remove-GceInstance







# --- Ouch! P45 time :-)


# --- Demo the provider