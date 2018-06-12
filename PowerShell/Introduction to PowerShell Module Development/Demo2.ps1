### - Create a manifest
$Path = "C:\Users\Jonathan\Documents\Development\Presentations\PowerShell\Introduction to PowerShell Module Development\Module1\Module1.psd1"
New-ModuleManifest -Path $Path

### - Review the contents of the psd1


### - Or go more specific
Remove-Item -Path $Path -Confirm:$false

$ModuleParams = @{
    Path = $Path
    ModuleVersion = '0.0.5'
    Author = 'Homer Simpson'
    #PowerShellVersion = 6.0
}

New-ModuleManifest @ModuleParams -PowerShellVersion 6.0

### - Now try importing that module
Import-Module $Path