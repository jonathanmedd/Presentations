# --- Log object output with Write-Output
# --- Notice what you see in the console is different
# --- than when using Write-Host

function Test-Debugging6 {
    [CmdletBinding()] 
 
     param($name)
 
     $service = Get-Service -Name $name

     Write-Host $service -ForegroundColor Blue
     Write-Output $service

 }

Test-Debugging6 -name 'Windows Update'