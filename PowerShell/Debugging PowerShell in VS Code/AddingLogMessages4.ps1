# --- Add log messages with Write-Debug
# --- Need to add [CmdletBinding] and move the param
# --- declaration to get this functionality

function Test-Debugging7 {
   [CmdletBinding()] 

    param($name)

    Write-Host "DebugPreference: $DebugPreference"

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
# --- Notice how we get prompted at each step
# --- This is because $DebugPreference gets set to Inquire not Continue
Test-Debugging7 -name 'Windows Update' -Debug

# --- We can alter this if we wish
# --- If ($PSBoundParameters['Debug']) {$DebugPreference = 'Continue'}
function Test-Debugging8 {
    [CmdletBinding()] 
 
     param($name)
 
    if ($PSBoundParameters['Debug']) {
        $DebugPreference = 'Continue'
    }

     Write-Host "DebugPreference: $DebugPreference"
 
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


 Test-Debugging8 -name 'Windows Update' -Debug

# --- More info on output streams
# --- https://blogs.technet.microsoft.com/heyscriptingguy/2014/03/30/understanding-streams-redirection-and-write-host-in-powershell/
# --- https://blogs.technet.microsoft.com/heyscriptingguy/2015/07/04/weekend-scripter-welcome-to-the-powershell-information-stream/