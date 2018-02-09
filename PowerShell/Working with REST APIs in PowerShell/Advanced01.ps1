# --- Strict Header Parsing
$Params = @{
    Uri = 'http://httpbin.org/headers'
    headers = @{
        "if-match" = "12345"
    }
}
Invoke-WebRequest @Params


# --- If-Match must be surrounded by quotes
$Params = @{
    Uri = 'http://httpbin.org/headers'
    headers = @{
        "if-match" = '"12345"'
    }
}
Invoke-WebRequest @Params