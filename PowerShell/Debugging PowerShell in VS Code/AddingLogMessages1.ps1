# --- Add log messages with Write-Host


function Test-Debugging4 ($name){

    Write-Host "Querying Service details....." -ForegroundColor Blue
    $service = Get-Service -Name $name 
    $wmiService = Get-WmiObject Win32_Service -Filter "DisplayName='$Name'" | Select-Object StartMode,ServiceSpecificExitCode
    Write-Host "Got service details......" -ForegroundColor Blue

    Write-Host "Creating output object......." -ForegroundColor Blue
    $output = [PSCustomObject]@{

        Name = $service.Name
        CanStop = $service.CanStop
        StartMode = $wmiService.StartMode
        ExitCode = $wmiService.ServiceSpecificExitCode
    }
    Write-Host "Created output object....." -ForegroundColor Blue

    Write-Output $output
}

Test-Debugging4 -name 'Windows Update'