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

# --- Potential issue if your code references properties that have changed
$Response | Get-Member -MemberType Property

# --- In 5.1 you could do this, but it errors in 6.0
$Response.BaseResponse.Headers.GetValues('Content-Type')

# --- Instead you need to do this in 6.0
$Response.BaseResponse.Content.Headers.GetValues('Content-Type')

# --- Error Handling
Invoke-WebRequest 'http://httpbin.org/status/418'