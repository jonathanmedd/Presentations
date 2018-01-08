# --- Select-Object StartMode,ServiceSpecificExitCode now splits the properties
# --- with a comma

function Test-Debugging3 ($name){

    $service = Get-Service -Name $name
    $wmiService = Get-WmiObject Win32_Service -Filter "DisplayName='$Name'" | Select-Object StartMode,ServiceSpecificExitCode

    $output = [PSCustomObject]@{

        Name = $service.Name
        CanStop = $service.CanStop
        StartMode = $wmiService.StartMode
        ExitCode = $wmiService.ServiceSpecificExitCode
    }

    Write-Output $output
}

Test-Debugging3 -name 'Windows Update'