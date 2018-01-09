# --- Set a line breakpoint
function Test-Debugging9 {
    [CmdletBinding()] 
 
     param($name)

     foreach ($serviceName in $name){

        $service = Get-Service -Name $serviceName 
        $wmiService = Get-WmiObject Win32_Service -Filter "DisplayName='$serviceName'"

        $output = [PSCustomObject]@{
    
            Name = $service.Name
            CanStop = $service.CanStop
            StartMode = $wmiService.StartMode
            ExitCode = $wmiService.ServiceSpecificExitCode
        }
    
        Write-Output $output
    }
 }

# --- Set a breakpoint at line 10 before running this
 Test-Debugging9 -name 'Windows Update'

 # --- Notice the [DBG] line in the console. You can run commands here
 # --- Try $service | fl *

 # --- Notice the Breakpoints section in the bottom left
 # --- You can clear Breakpoints hereS