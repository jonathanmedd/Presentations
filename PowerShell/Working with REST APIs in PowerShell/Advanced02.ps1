# --- No FTP or File support
# --- Issue here: https://github.com/PowerShell/PowerShell/issues/5491
# --- Mark comments that he envisages a Invoke-Download at some point
$Uri = 'ftp://repo1.dal.innoscale.net/centos/timestamp.txt'
Invoke-WebRequest -Uri $Uri | Select-Object -ExpandProperty 'RawContent'

$Path = 'C:\Users\Jonathan\Documents\Test.txt'
$Uri = 'file://{0}' -f $Path
Invoke-WebRequest -Uri $Uri | Select-Object -ExpandProperty 'RawContent'

# --- Basic Parsing Only
# --- 5.1 used IE's Rendering Engine
# --- IE is not available on Linux or macOS
# --- -UserBasicParsing parameter is now hidden and setting it
# --- to true or false has no impact
# --- The future is a new cmdlet ConvertFrom-Html, possibly in 6.1.0
$Result = Invoke-WebRequest 'https://www.google.com'
$Logo = $Result.ParsedHtml.getElementById('hplogo')
$Logo.src

# --- No New-WebServiceProxy Cmdlet - primarily for SOAP APIs
# --- My Brickset module used this cmdlet so can't update it yet for Core
# --- Not a priority for the PS Team, may be up to community to solve
# --- WebServiceX.net example
$Uri = "http://www.webservicex.net/country.asmx?WSDL"
$CountryService = New-WebServiceProxy -Uri $Uri
$CountryService.GetCurrencyByCountry('United Kingdom')
$CountryService.GetCurrencyByCountry('Jamaica')

# --- No SSL 3.0 support - this is probably actually a good thing!
# --- HttpClient does not support SSL 3.0 in .NET Core

# --- The options we saw earlier using [System.Net.ServicePointManager]
# --- (and others) are not available. Most of the features you would want
# --- to use are now set on a per cmdlet level. Others should follow as
# --- additional parameters

# --- Some certificate issues on Linux and macOS
# --- More details in Mark's blog posts