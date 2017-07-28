# --- Save XML Doument to a file with Save method
[xml]$XML4 = @'
<breakfast_menu>
    <food>
        <name>Belgian Waffles</name>
        <price>$5.95</price>
        <description>Two of our famous Belgian Waffles with plenty of real maple syrup</description>
        <calories>650</calories>
    </food>
    <food>
        <name>Strawberry Belgian Waffles</name>
        <price>$7.95</price>
        <description>Light Belgian waffles covered with strawberries and whipped cream</description>
        <calories>900</calories>
    </food>
    <food>
        <name>Berry-Berry Belgian Waffles</name>
        <price>$8.95</price>
        <description>Light Belgian waffles covered with an assortment of fresh berries and whipped cream</description>
        <calories>900</calories>
    </food>
    <food>
        <name>French Toast</name>
        <price>$4.50</price>
        <description>Thick slices made from our homemade sourdough bread</description>
        <calories>600</calories>
    </food>
    <food>
        <name>Homestyle Breakfast</name>
        <price>$6.95</price>
        <description>Two eggs, bacon or sausage, toast, and our ever-popular hash browns</description>
        <calories>950</calories>
    </food>
</breakfast_menu>
'@

$XML4.Save('C:\Users\Jonathan\Documents\Development\Presentations\PSDayUK\2017\Data\Example3.xml')

# --- Make the Save method available via a function
function Out-XML {
<#
    .SYNOPSIS
    Output an XML Document object to a file

    .DESCRIPTION
    Output an XML Document object to a file

    .PARAMETER InputObject
    The XML Document object

    .PARAMETER FilePath
    Path to the output file

    .INPUTS
    System.Xml.XmlDocument
    System.String

    .OUTPUTS
    System.IO.FileInfo

    .EXAMPLE
    $XML | Out-File C:\Scripts\Test.xml
#>

[CmdletBinding()][OutputType('System.IO.FileInfo')]
    Param (
        [Parameter(Mandatory=$true,ValueFromPipeline=$true,Position=0)]
        [System.Xml.XmlDocument]$InputObject,

        [Parameter(Mandatory=$true,ValueFromPipeline=$true,Position=1)]
        [String]$FilePath
    )

    process {

        # --- Save the file out
        $InputObject.Save($FilePath)

        # --- Output the result
        Get-ChildItem -Path $FilePath 
    }
}


# --- Use the Out-XML function to output to an XML file
$XML4 | Out-XML -FilePath 'C:\Users\Jonathan\Documents\Development\Presentations\PSDayUK\2017\Data\Example4.xml'

# --- Update data in XML before outputting

