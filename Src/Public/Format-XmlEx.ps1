function Format-XmlEx {
<#
    .SYNOPSIS
        Pretty prints a [System.Xml.XmlDocument] object
    .NOTES
        https://blogs.msdn.microsoft.com/powershell/2008/01/18/format-xml/
#>
    [CmdletBinding()]
    param (
        ## Xml document to pretty print
        [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [ValidateNotNull()]
        [System.Xml.XmlDocument] $XmlDocument,

        ## Xml indentation level
        [Parameter()]
        [System.Int32] $Indent = 2
    )
    process {

        $stringReader = New-Object -TypeName 'System.IO.StringReader' -ArgumentList $XmlDocument.OuterXml;
        $xmlTextReader = New-Object -TypeName 'System.Xml.XmlTextReader' -ArgumentList $stringReader;

        $stringWriter = New-Object -TypeName 'System.IO.StringWriter';
        $xmlTextWriter = New-Object -TypeName 'System.Xml.XmlTextWriter' -ArgumentList $stringWriter;
        $xmlTextWriter.Formatting = 'indented';
        $xmlTextWriter.Indentation = $Indent;

        do {
            $xmlTextWriter.WriteNode($xmlTextReader, $false)
        }
        while ($xmlTextReader.Read())

        $xmlTextReader.Close();
        $stringReader.Close();
        $xmlTextWriter.Flush();
        $stringWriter.Flush();

        Write-Output -InputObject $stringWriter.ToString();

    } #end process
} #end function Format-XmlEx
