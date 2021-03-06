# --- Make sure to start out in PS 5.1
$PSVersionTable
Set-Location .\PSDayUK\2017

# --- Export to CSV
Get-Service | Select-Object Name,DisplayName,Status,StartType | Export-CSV .\Data\Example4.csv

Invoke-Item .\Data\Example4.csv

# --- What was that Type information about in row 1?
# --- Export to CSV with no Type Information
Get-Service | Select-Object Name,DisplayName,Status,StartType | Export-CSV .\Data\Example5.csv -NoTypeInformation

Invoke-Item .\Data\Example5.csv

# --- What's ConvertFrom-CSV and ConvertTo-CSV? For working with CSV data within your PowerShell session

# --- Use a native Windows tool to produce CSV output
whoami /GROUPS /FO CSV

# --- Use ConvertFrom-CSV to turn that into an object which is easier to work with
whoami /GROUPS /FO CSV | ConvertFrom-Csv

# --- If you need to go the opposite way use ConvertTo-CSV
Get-Service | Select-Object Name,DisplayName,Status,StartType | ConvertTo-Csv

# Switch to PS 7 and change to the right folder
$PSVersionTable
Set-Location .\PSDayUK\2017

# --- Export to CSV again. No Type Information is now on by default
Get-Service | Select-Object Name,DisplayName,Status,StartType | Export-CSV .\Data\Example4.csv

Invoke-Item .\Data\Example4.csv