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

$data | Export-Excel @ExcelParams -TableName Processes -ExcelChartDefinition $Chart


#--- Copy worksheet data from one spreadsheet to another
Copy-ExcelWorkSheet -SourceWorkSheet 'Services' -SourceWorkbook .\Data\Example3.xlsx -DestinationWorkSheet 'New Services Data' -DestinationWorkbook .\Data\Example6.xlsx -Show

# --- Generate a spreadsheet with data from a table in Wikipedia
# --- The cmdlet name is possibly a little misleading
Import-Html -URL https://en.wikipedia.org/wiki/List_of_Buffy_the_Vampire_Slayer_episodes -Index 1