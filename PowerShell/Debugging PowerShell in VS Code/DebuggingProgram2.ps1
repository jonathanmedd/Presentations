# --- Use a watch
function Test-Debugging10 {
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
# --- Also create $service in the Watch pane
# --- Observe what happens in the Watch pane
 Test-Debugging10 -name 'Windows Update','Print Spooler'