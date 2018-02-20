# --- Test for PS 5.1
if ($ISCoreCLR){

    throw "Switch to PS 5.1"
}

# --- Deal with untrusted certificates in PS 5.1
# --- Allows all untrusted certs in this session
# --- Not a good idea, unless you are certain about this!
Add-Type @"
using System.Net;
using System.Security.Cryptography.X509Certificates;
public class TrustAllCertsPolicy : ICertificatePolicy {
    public bool CheckValidationResult(
        ServicePoint srvPoint, X509Certificate certificate,
        WebRequest request, int certificateProblem) {
        return true;
    }
}
"@
[System.Net.ServicePointManager]::CertificatePolicy = New-Object TrustAllCertsPolicy

# --- Use TLS 1.2, otherwise it may default to use SSL 3.0
# --- Current available
[System.Net.ServicePointManager]::SecurityProtocol

# --- Add TLS 1.2 - note this is for the whole PowerShell session
[System.Net.ServicePointManager]::SecurityProtocol += [System.Net.SecurityProtocolType]::Tls12

# --- Basic Authentication
# --- Get credentials
$vROCredential = Get-Credential -UserName 'jmedd@vrademo.local' -Message "Enter the password"

$vROUsername = $vROCredential.UserName
$vROConnectionPassword = $vROCredential.GetNetworkCredential().Password

# --- Set Encoded Password
$Auth = $vROUsername + ':' + $vROConnectionPassword
$Encoded = [System.Text.Encoding]::UTF8.GetBytes($Auth)
$EncodedPassword = [System.Convert]::ToBase64String($Encoded)

Write-Host "The encoded password is: $EncodedPassword" -ForegroundColor Green

# --- Set the headers
$Headers = @{

    "Accept"="application/json";
    "Content-Type" = "application/json";
    "Authorization" = "Basic $EncodedPassword";
}

$Headers

# --- Make the request
$vROParams = @{

    Method = 'GET'
    Headers = $Headers
    Uri = "https://vro02.vrademo.local:8281/vco/api/workflows/?conditions=name=Test01"
}

$vROResponse = Invoke-RestMethod @vROParams

$vROResponse

$vROResponse.link.attributes | Sort-Object name | Select-Object name,value

# --- Token authentication
$vRACredential = Get-Credential -UserName 'Tenantadmin01@vrademo.local' -Message "Enter the password"

$vRAUsername = $vRACredential.UserName
$vRAConnectionPassword = $vRACredential.GetNetworkCredential().Password

$Body = @"
{
    "username":"$($vRAUsername)",
    "password":"$($vRAConnectionPassword)",
    "tenant":"Tenant01"
}
"@

$vRAParams = @{

    Method = "POST"
    Uri = "https://vraap07.vrademo.local/identity/api/tokens"
    Headers = @{
        "Accept"="application/json";
        "Content-Type" = "application/json";
    }
    Body = $Body
}

$vRAResponse = Invoke-RestMethod @vRAParams

$vRAResponse

# --- Get the token from the response
$Token = $vRAResponse.id

$Token

# --- Make a request using the token
# --- 'Bearer' + a space + the token
$vRAParams2 = @{

    Method = "GET"
    Uri = "https://vraap07.vrademo.local/reservation-service/api/reservations?`$filter=name%20eq%20'Reservation01'"
    Headers = @{

        "Accept"="application/json";
        "Content-Type" = "application/json";
        "Authorization" = "Bearer $Token";
    }
}

$vRAResponse2 = Invoke-RestMethod @vRAParams2

$vRAResponse2.content