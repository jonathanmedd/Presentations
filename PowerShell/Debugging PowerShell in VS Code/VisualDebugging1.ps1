# --- Use VS Code Intellisense to debug visually

function ($name){

    $service = Get-Service -Name $name
    $wmiService = Get-WmiObject Win32_Service -Filter "DisplayName='$Name'" | Select StartModeServiceSpecificExitCode

    $output = [PSCustomObject]@{

        Name = $service.Name
        CanStop = $service.CanStop
        StartMode = $wmiService.StartMode
    }

    Write-Output $outut
}

Test-Debugging2 -name 'Windows Update'