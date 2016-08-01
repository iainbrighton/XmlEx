function New-XmlExDocument {
<#
    .SYNOPSIS
        Creates a new XmlEx document.
    .DESCRIPTION
        The XmlDocument cmdlet
#>
    [CmdletBinding()]
    [Alias('XmlDocument')]
    [System.Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseShouldProcessForStateChangingFunctions', '')]
    [OutputType([System.Xml.XmlDocument])]
    param (
        ## XmlEx document content
        [Parameter(ValueFromPipelineByPropertyName, Position = 0)]
        [ValidateNotNull()]
        [System.Management.Automation.ScriptBlock] $ScriptBlock
    )
    process {

        Write-Verbose -Message ($localized.CreatingDocument);

        Set-Variable -Name _xmlExCurrentElementIndent -Value 0 -Scope Script;

        $_xmlExCurrentDocument = New-Object -TypeName 'System.Xml.XmlDocument';


        ## Set the document namespaces
        Set-Variable -Name _xmlExDocumentNamespaces -Value @{ } -Scope Script;
        Set-Variable -Name _xmlExCurrentNamespace -Value $null -Scope Script;

        ## Set the current element to the root
        Set-Variable -Name _xmlExCurrentElement -Value $_xmlExCurrentDocument -Scope Script;

        if ($PSBoundParameters.ContainsKey('ScriptBlock')) {
            [ref] $null = & $ScriptBlock;
        }

        ## We can't add attributes until we have a root element.
        foreach ($namespace in $_xmlExDocumentNamespaces.Keys) {
            if ($null -eq $_xmlExCurrentDocument.DocumentElement) {
                throw ($localized.XmlExNamespaceMissingXmlElementError);
            }
            else {
                $xmlNamespace = $_xmlExDocumentNamespaces[$namespace];
                Write-Verbose -Message ($localized.AddingDocumentNamespace -f $xmlNamespace.DisplayName);
                [ref] $null = $_xmlExCurrentDocument.DocumentElement.SetAttribute(
                                                        $namespace, $xmlNamespace.Uri);
            }
        }

        Write-Verbose -Message ($localized.FinalizingDocument);
        Write-Output -InputObject $_xmlExCurrentDocument;

    } #end process
} #end functon XmlDocument
