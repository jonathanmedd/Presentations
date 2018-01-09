# --- Add log messages with Write-Verbose
# --- Need to add [CmdletBinding] and move the param
# --- declaration to get this functionality

function Test-Debugging5 {
   [CmdletBinding()] 

    param($name)

    Write-Verbose "Querying Service details....."
    $service = Get-Service -Name $name 
    $wmiService = Get-WmiObject Win32_Service -Filter "DisplayName='$Name'" | Select-Object StartMode,ServiceSpecificExitCode
    Write-Verbose "Got service details......"

    Write-Verbose "Creating output object......."
    $output = [PSCustomObject]@{

        Name = $service.Name
        CanStop = $service.CanStop
        StartMode = $wmiService.StartMode
        ExitCode = $wmiService.ServiceSpecificExitCode
    }
    Write-Verbose "Created output object....."

    Write-Output $output
}

# --- Notice how running by default displays no log messages in the console
Test-Debugging5 -name 'Windows Update'

# --- Use the verbose parameter to get the messages
# --- Note: can also set $VerbosePreference = 'Continue'
# --- but that applies to entire session, not per command
Test-Debugging5 -name 'Windows Update' -Verbose