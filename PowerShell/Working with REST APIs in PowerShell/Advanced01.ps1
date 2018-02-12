# --- Strict Header Parsing
$Params = @{
    Uri = 'http://httpbin.org/headers'
    headers = @{
        "if-match" = "12345"
    }
}
Invoke-WebRequest @Params


# --- If-Match must actually be surrounded by quotes
$Params = @{
    Uri = 'http://httpbin.org/headers'
    headers = @{
        "if-match" = '"12345"'
    }
}
Invoke-WebRequest @Params

# --- Response type has changed
$Response = Invoke-WebRequest 'http://httpbin.org/get'
$Response.BaseResponse.GetType().FullName

$Response | Get-Member