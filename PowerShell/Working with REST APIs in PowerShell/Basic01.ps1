# --- Test for PS 5.1
if ($ISCoreCLR){

    throw "Switch to PS 5.1"
}

# --- A GET request
Invoke-RestMethod -Method GET -Uri https://httpbin.org/get

# --- A POST request
$Body1 = @"
    {
        "Name": "Homer Simpson",
        "City": "Springfield",
        "Food": "Doughnut"
    }
"@

Invoke-RestMethod -Method POST -Uri https://httpbin.org/post -Body $Body1 -ContentType 'application/json'

# --- A PUT request
$Body2 = @"
    {
        "Name": "Homer Simpson",
        "City": "London",
        "Food": "Pizza"
    }
"@

Invoke-RestMethod -Method PUT -Uri https://httpbin.org/put -Body $Body2 -ContentType 'application/json'

# --- A DELETE request
Invoke-RestMethod -Method DELETE -Uri https://httpbin.org/delete


# --- Look at the difference in headers in the responses between
# --- Invoke-RestMethod and Invoke-WebRequest
(Invoke-RestMethod -Uri https://httpbin.org/headers).headers

Invoke-WebRequest -Uri https://httpbin.org/headers