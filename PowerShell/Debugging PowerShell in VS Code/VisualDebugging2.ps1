# --- Cleaned up code, but does it work 100% correctly?

function Test-Debugging2 ($name){

    $service = Get-Service -Name $name
    $wmiService = Get-WmiObject Win32_Service -Filter "DisplayName='$Name'" | Select-Object StartModeServiceSpecificExitCode

    $output = [PSCustomObject]@{

        Name = $service.Name
        CanStop = $service.CanStop
        StartMode = $wmiService.StartMode
        ExitCode = $wmiService.ServiceSpecificExitCode
    }

    Write-Output $output
}

Test-Debugging2 -name 'Windows Update'