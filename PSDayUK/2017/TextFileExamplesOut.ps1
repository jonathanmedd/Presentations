# --- Out-File
$text = @"
This is *line* 0
This is *line* 1
This is *line* 2
This is *line* 3
This is *line* 4
This is *line* 5
This is *line* 6
This is *line* 7
This is *line* 8
This is *line* 9
"@
Out-File -FilePath .\Data\Example3.txt -InputObject $text

# --- Set-Content
$text = @"
This is *line* 0
This is *line* 1
This is *line* 2
This is *line* 3
This is *line* 4
This is *line* 5
This is *line* 6
This is *line* 7
This is *line* 8
This is *line* 9
"@
Set-Content -Path .\Data\Example4.txt -Value $text

Get-Content -Path .\Data\Example4.txt

# --- Gotcha reading in text from a file, replacing text and writing out again
# --- Encapsulate Get-Content in brackets, otherwise it won't have released access to the file
(Get-Content .\Data\Example4.txt) | Foreach-Object {$_ -replace "\*", "!"} | Set-Content .\Data\Example4.txt

Get-Content .\Data\Example4.txt

# --- Add-Content
"This is *line* 10" | Add-Content .\Data\Example4.txt
Get-Content .\Data\Example4.txt

# --- Change the Encoding
$text = @"
This is *line* 0
This is *line* 1
This is *line* 2
This is *line* 3
This is *line* 4
This is *line* 5
This is *line* 6
This is *line* 7
This is *line* 8
This is *line* 9
"@
Set-Content -Path .\Data\Example5.txt -Value $text -Encoding UTF8

# --- Create a file with UTF8NoBOM
$Data = Get-Content .\Data\Example5.txt
$Utf8NoBomEncoding = New-Object System.Text.UTF8Encoding $False
[System.IO.File]::WriteAllLines('.\Data\Example5.txt', $Data, $Utf8NoBomEncoding)

