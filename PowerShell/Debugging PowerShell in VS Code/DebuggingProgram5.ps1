# --- Create a line breakpoint for at line 12 the add an expression
# --- if ($i % 10 -eq 0){Write-Host "`$i is $i"; continue}
# --- This makes it a tracepoint. Note the use of the continue keyword
# --- Then start the debugger. Watch how it doesn't break, but continues

param([int]$Count=50, [int]$DelayMilliseconds=200)

function Write-Item($itemCount) {
    $i = 1

    while ($i -le $itemCount) {
        $str = "Output $i"
        Write-Output $str

        # In the gutter on the left, right click and select "Add Conditional Breakpoint"
        # on the next line. Use the condition: $i -eq 25
        $i = $i + 1

        # Slow down execution a bit so user can test the "Pause debugger" feature.
        Start-Sleep -Milliseconds $DelayMilliseconds
    }
}

# Do-Work will be underlined in green if you haven't disable script analysis.
# Hover over the function name below to see the PSScriptAnalyzer warning that "Do-Work"
# doesn't use an approved verb.
function Do-Work($workCount) {
    Write-Output "Doing work..."
    Write-Item $workcount
    Write-Host "Done!"
}

Do-Work $Count

