# --- Output to a JSON file
Get-ChildItem * | ConvertTo-Json | Out-File .\Data\Example2.json

# --- Depth parameter gotcha: default is 2. This means we have lines like this (54):
# --- "Credential":  "System.Management.Automation.PSCredential",
# --- Where the object has not been expanded
Get-ChildItem * | ConvertTo-Json -Depth 3 | Out-File .\Data\Example3.json

# --- It gets expanded to (107):
<#                        
"Credential":  {
    "UserName":  null,
    "Password":  null
},
#>