# --- What are the built in cmdlets for working with XML
Get-Command *XML* -CommandType Cmdlet

# --- This is what happens with Import-CliXML and Export-CliXML
# --- Create an XML based representation of an object and store it in a file
Get-ChildItem .\Data | Export-Clixml .\Data\Example1.XML

Import-Clixml .\Data\Example1.XML

# --- Type of object is maintained
Import-Clixml .\Data\Example1.XML | Get-Member

# --- Create an XML document object then load data from a file
$XML1 = New-Object System.Xml.XmlDocument
$XML1

$XMLFile2 = Resolve-Path .\Data\Example2.XML
$XML1.Load($XMLFile2)
$XML1

# --- Or use the [xml] type accelerator
[xml]$XML2 = Get-Content  .\Data\Example2.XML
$XML2

# --- Observe that we also have an object of type XmlDocument
$XML2.GetType()

# --- Use XPath to navigate the XML tree
$XML1.SelectNodes('//food')

$XML1.SelectSingleNode('//food[2]')

$XML1.SelectSingleNode('//food[name="Strawberry Belgian Waffles"]')

$XML1.SelectNodes('//food[calories="900"]')


# --- Or use a Here-String. It's possible your XML data may not come from a file, perhaps a WebService




ConvertTo-Xml

Select-XML