# --- Export to Excel
Get-Service | Select-Object Name,DisplayName,Status,StartType | Export-Excel -Path .\Data\Example2.xlsx -Show

# --- Export to Excel specifying Worksheet name and format the file to column width
Get-Service | Select-Object Name,DisplayName,Status,StartType | Export-Excel -WorkSheetname 'Services' -Path .\Data\Example3.xlsx -AutoSize -Show

# --- Export data in an object to Excel via the pipeline. Ignore number types. Most parameters are supplied via splatting
# --- In the result look at F2 and G2
$ExcelParams = @{

    WorksheetName = 'Numbers'
    Path = '.\Data\Example4.xlsx'
    AutoSize = $true
    Show = $true
}
[PSCustomObject]@{
    Date      = Get-Date
    Formula1  = '=SUM(F2:G2)'
    String1   = 'My String'
    String2   = 'a'
    IPAddress = '10.10.25.5'
    Number1   = '07670'
    Number2   = '0,26'
    Number3   = '1.555,83'
    Number4   = '1.2'
    Number5   = '-31'
    PhoneNr1  = '+32 44'
    PhoneNr2  = '+32 4 4444 444'
    PhoneNr3  =  '+3244444444'
} | Export-Excel @ExcelParams -NoNumberConversion *

# --- Tidy up check
if (Get-Item .\Data\Example5.xlsx) {Remove-Item .\Data\Example5.xlsx -Force -Confirm:$false}

# --- Get process data and include a chart
$Data = Invoke-Sum (Get-Process) company handles,pm,VirtualMemorySize

$Chart = New-ExcelChart -Title Stats `
    -ChartType LineMarkersStacked `
    -Header "Stuff" `
    -XRange "Processes[Company]" `
    -YRange "Processes[PM]","Processes[VirtualMemorySize]"
 
$ExcelParams = @{

    WorksheetName = 'Processes'
    Path = '.\Data\Example5.xlsx'
    AutoSize = $true
    Show = $true
}

$Data | Export-Excel @ExcelParams -TableName Processes -ExcelChartDefinition $Chart