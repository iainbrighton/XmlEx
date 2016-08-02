function Set-XmlExDeclaration {
<#
    .SYNOPSIS
        Sets the Xml declaration.
    .DESCRIPTION
        The Set-XmlExDeclaration cmdlet set the Xml declaration on a XmlEx document.
#>
    [CmdletBinding(DefaultParameterSetName = 'XmlEx')]
    [Alias('XmlDeclaration')]
    [OutputType([System.Xml.XmlDeclaration])]
    param (
        ## Xml document 'version' declaration
        [Parameter(ValueFromPipelineByPropertyName, Position = 0, ParameterSetName = 'XmlEx')]
        [Parameter(ValueFromPipelineByPropertyName, Position = 0, ParameterSetName = 'XmlDocument')]
        [ValidateSet('1.0')]
        [System.String] $Version,

        ## Xml document 'encoding' declaration
        [Parameter(ValueFromPipelineByPropertyName, Position = 1, ParameterSetName = 'XmlEx')]
        [Parameter(ValueFromPipelineByPropertyName, Position = 1, ParameterSetName = 'XmlDocument')]
        [ValidateNotNullOrEmpty()]
        [System.String] $Encoding,

        ## Xml document 'standalone' declaration
        [Parameter(ValueFromPipelineByPropertyName, ParameterSetName = 'XmlEx')]
        [Parameter(ValueFromPipelineByPropertyName, ParameterSetName = 'XmlDocument')]
        [ValidateSet('Yes','No')]
        [System.String] $Standalone,

        ## Xml document to add the declaration to
        [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName, ParameterSetName = 'XmlDocument')]
        [ValidateNotNull()]
        [System.Xml.XmlDocument] $XmlDocument,

        ## Returns the created XmlDecalration object to the pipeline. By default, this cmdlet does not generate any output.
        [Parameter(ValueFromPipelineByPropertyName)]
        [System.Management.Automation.SwitchParameter] $PassThru
    )
    begin {

        if ($PSCmdlet.ParameterSetName -eq 'XmlDocument') {
            $_xmlExCurrentDocument = $XmlDocument;
        }

        if ($null -eq $_xmlExCurrentDocument) {
            throw ($localized.XmlExDocumentNotFoundError);
        }

    }
    process {

        if ($PSCmdlet.ParameterSetName -eq 'XmlEx') {
            $callingFunction = (Get-PSCallStack)[2];
            if ($callingFunction.FunctionName -ne 'New-XmlExDocument<Process>') {
                throw ($localized.XmlExInvalidCallOutsideScopeError -f 'XmlDecalration','XmlDocument');
            }
        }

        if (-not $PSBoundParameters.ContainsKey('Version')) {
            $Version = '1.0';
        }

        $xmlDeclaration = $_xmlExCurrentDocument.CreateXmlDeclaration($Version, $Encoding, $Standalone);
        [ref] $null = $_xmlExCurrentDocument.AppendChild($xmlDeclaration);

        if ($PassThru) {
            Write-Output -InputObject $xmlDeclaration;
        }

    }
} #end function Set-XmlExDeclaration
