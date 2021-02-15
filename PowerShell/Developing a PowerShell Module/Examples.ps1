# Remember to authenticate off screen first
$cred = Get-Credential
Connect-Brickset -apiKey 'xxx' -credential $cred

# Get Number of Sets by Theme
Get-BricksetTheme | Sort-Object setcount -Descending | Format-Table theme,setcount

# Get Years for a given Theme
Get-BricksetYear -Theme 'Indiana Jones'

# Pipe into Get-BricksetSet
Get-BricksetYear -Theme 'Indiana Jones' | Select-Object -First 1 | Get-BricksetSet | Format-Table Name,Year

# Get set details for a theme
Get-BricksetSet -Theme 'Indiana Jones' | Sort-Object subTheme -Descending | Format-Table Name,Number,SubTheme,Pieces

# Remember to clear ownership of set first
# Add Back to the Future set to Inventory
Get-BricksetSetOwned | Sort-Object Theme | Format-Table Name,Number,Theme -AutoSize

Get-BricksetSet -SetNumber '21103-1' | Format-Table Name,Number,Theme,Pieces -AutoSize

Get-BricksetSet -SetNumber '21103-1' | Set-BricksetSetOwned -QtyOwned 1 -Confirm:$false

Get-BricksetSetOwned | Sort-Object Theme | Format-Table Name,Number,Theme -AutoSize

# Most commonly asked question about the module
# "How do I download multiple instruction sets?"
# Show side-by-side with an explorer window

Get-BricksetSet -Theme 'Indiana Jones' | ForEach-Object {

    $i = 1
    $instructionsUrls = $_ | Get-BricksetSetInstructions | Select-Object -ExpandProperty url

    foreach ($instructionsUrl in $instructionsUrls){

        $file = "$($_.number)_$($i).pdf"
        $i++
        Start-BitsTransfer -Source $instructionsUrl -Destination "C:\Users\jon_m\Documents\Lego\$file"
    }
}