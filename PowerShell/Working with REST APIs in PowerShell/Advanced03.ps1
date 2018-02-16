# --- Referenced from https://get-powershellblog.blogspot.co.uk PowerShell Core Web Cmdlets Series
# --- User Agents - aka how a web service identifies the client sending the request
# --- Default
(Invoke-RestMethod  https://httpbin.org/headers).Headers."User-Agent"

# --- Send a custom one Chrome
$Params = @{
    Uri       = 'https://httpbin.org/headers'
    UserAgent = [Microsoft.PowerShell.Commands.PSUserAgent]::Chrome
} 
(Invoke-RestMethod @Params).Headers."User-Agent"

# --- Or Firefox
$Params = @{
    Uri       = 'https://httpbin.org/headers'
    UserAgent = [Microsoft.PowerShell.Commands.PSUserAgent]::FireFox
} 
(Invoke-RestMethod @Params).Headers."User-Agent"

# --- New Parameters - 12!
# --- In both Invoke-RestMethod and Invoke-WebRequest
<#
-AllowUnencryptedAuthentication
-Authentication
-CustomMethod
-NoProxy
-PreserveAuthorizationOnRedirect
-SkipCertificateCheck
-SkipHeaderValidation
-SslProtocol
-Token
#>

# --- In just Invoke-RestMethod
<#
-FollowRelLink
-MaximumFollowRelLink
-ResponseHeadersVariable
#>


# --- Authentication
# --- Much easier way to do Basic Auth
# --- (Don't run this, just show the format)
$uri = 'https://httpbin.org/basic-auth/user/passwd'
$Credential = Get-Credential
Invoke-RestMethod -uri $uri -Authentication Basic -Credential $Credential


# --- Much easier way to do Bearer / Token authentication
# --- No need for "Authorization" = "Bearer $Token"
# --- (Don't run this, just show the format)
# --- Note, the token must be a SecureString
$uri = 'https://httpbin.org/headers'
$Token = Read-Host -AsSecureString -Prompt "Enter Beaer Token"
Invoke-RestMethod -uri $uri -Authentication Bearer -Token $Token


# --- Authentication Over HTTP vs HTTPS
# --- Attempts to send secrets over HTTP instead of HTTPS will now result in an error. 
$Params = @{
    Uri            = 'http://httpbin.org/hidden-basic-auth/user/passwd'
    Authentication = 'Basic'
    Credential     = Get-Credential
}
Invoke-RestMethod @params

# --- so do it properly over HTTPS. However, if it's for some testing
# --- purpose perhaps where you haven't implemented the cert yet
# --- you can use the AllowUnencryptedAuthentication parameter
$Params = @{
    Uri            = 'http://httpbin.org/hidden-basic-auth/user/passwd'
    Authentication = 'Basic'
    Credential     = Get-Credential
}
Invoke-RestMethod @Params -AllowUnencryptedAuthentication


# --- Response Header Support for Invoke-RestMethod
# --- There was no support for this in 5.1, which meant you had to
# --- revert to using Invoke-WebRequest.
# --- Now there is a ResponseHeadersVariable parameter
$uri = 'https://httpbin.org/get'
$Headers = $null
$Result = Invoke-RestMethod -Uri $uri -ResponseHeadersVariable 'Headers'

$Headers

$Headers['Content-Type']


# --- SslProtocol Parameter
# --- Remember what we had to do previously?
# --- Add protocols for the whole PowerShell session
# --- Now we can specify them per request
$uri = 'https://httpbin.org/get'
Invoke-RestMethod -Uri $Uri -SslProtocol 'Tls12'

# --- Support for Accessing Sites with Expired, Self-Signed, Malformed, or Untrusted Certificates
# --- Remember what we had to do previously?
# --- Now we can specify to deal with them per request
# --- with the SkipCertificateCheck parameter
$Uri = 'https://self-signed.badssl.com'
Invoke-RestMethod -Uri $Uri

$Uri = 'https://self-signed.badssl.com'
Invoke-RestMethod -Uri $Uri -SkipCertificateCheck

# --- Automated Pagination With Invoke-RestMethod
# --- How many PowerShell issues on Github?
$Response = Invoke-RestMethod https://api.github.com/repos/powershell/powershell/issues -ResponseHeadersVariable Headers
$Response.count

# --- there are more than that
Start-Process 'chrome.exe' https://github.com/PowerShell/PowerShell/issues

# --- It's using paged data
$Headers.Link

# --- In 5.1 you had to do something like this to go through all the pages
<#
Use Invoke-WebRequest to grab a page of results
Perform error detection
Detect the Content-Type (JSON/XML/Text)
Serialize a PowerShell object from the content (e.g. ConvertFrom-Json).
Check for the existence of Link header
Use Regex to parse the Link headers to find the URI for the next page
Use the parsed URI and repeat the above
#>

# --- In 6.0.0 we can use the -FollowRelLink and -MaximumFollowRelLink parameters
$FirstPage = 'https://api.github.com/repos/powershell/powershell/issues'
$Pages = Invoke-RestMethod -Uri $FirstPage -FollowRelLink -MaximumFollowRelLink 2
$Pages[0].Count
$Pages[1].Count

# --- Loop through all pages
$FirstPage = 'https://api.github.com/repos/powershell/powershell/issues'
$Params = @{
    Uri                  = $FirstPage
    FollowRelLink        = $true
    MaximumFollowRelLink = 50
}
$Results = Invoke-RestMethod @Params | ForEach-Object {$_}
$Results.Count