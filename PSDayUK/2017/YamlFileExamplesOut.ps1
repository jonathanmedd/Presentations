# --- Make sure to start out in PS 7
$PSVersionTable
Set-Location .\PSDayUK\2017

# --- Output to Yaml
$Data1  = [ordered]@{

    "hello"="world";
    "anArray"= @(1,2,3);
    "nested"= @{"array"=@("this", "is", "an", "array")}
}

ConvertTo-Yaml $Data1

# --- Output to a Yaml File
ConvertTo-Yaml $Data1 -OutFile 'C:\Code\Presentations\PSDayUK\2017\Data\Example2.yaml' -Force