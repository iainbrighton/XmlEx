[System.Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidUsingCmdletAliases', '')]
param()

Import-Module -Name XmlEx -Force;

$x = XmlDocument { }

## Appending an XmlElement to an exising XmlDocument
XmlElement -XmlDocument $x -Name 'rootElement' {
    XmlElement 'TextNode' {
        XmlText 'My text node'
    }
} -Verbose

Write-Output $x

