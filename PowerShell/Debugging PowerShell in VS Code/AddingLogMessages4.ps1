# --- Add log messages with Write-Debug
# --- Need to add [CmdletBinding] and move the param
# --- declaration to get this functionality

function Test-Debugging7 {
   [CmdletBinding()] 

    param($name)

    Write-Debug "Querying Service details....."
    $service = Get-Service -Name $name 
    $wmiService = Get-WmiObject Win32_Service -Filter "DisplayName='$Name'" | Select-Object StartMode,ServiceSpecificExitCode
    Write-Debug "Got service details......"

    Write-Debug "Creating output object......."
    $output = [PSCustomObject]@{

        Name = $service.Name
        CanStop = $service.CanStop
        StartMode = $wmiService.StartMode
        ExitCode = $wmiService.ServiceSpecificExitCode
    }
    Write-Debug "Created output object....."

    Write-Output $output
}

# --- Notice how running by default displays no log messages in the console
Test-Debugging7 -name 'Windows Update'

# --- Use the debug parameter to get the messages
Test-Debugging7 -name 'Windows Update' -Debug

# --- More info on output streams
# --- https://blogs.technet.microsoft.com/heyscriptingguy/2014/03/30/understanding-streams-redirection-and-write-host-in-powershell/
# --- https://blogs.technet.microsoft.com/heyscriptingguy/2015/07/04/weekend-scripter-welcome-to-the-powershell-information-stream/