function Add-XmlExElement {
<#
    .SYNOPSIS
        Creates a new XmlEx document element.
#>
    [CmdletBinding(DefaultParameterSetName = 'XmlEx')]
    [Alias('XmlElement')]
    [OutputType([System.Xml.XmlElement])]
    param (
        ## Xml element name to add
        [Parameter(Mandatory, ValueFromPipelineByPropertyName, Position = 0, ParameterSetName = 'XmlEx')]
        [Parameter(Mandatory, ValueFromPipelineByPropertyName, Position = 0, ParameterSetName = 'XmlElement')]
        [Parameter(Mandatory, ValueFromPipelineByPropertyName, Position = 0, ParameterSetName = 'XmlDocument')]
        [ValidateNotNullOrEmpty()]
        [System.String] $Name,

        ## XmlEx element nested content
        [Parameter(ValueFromPipelineByPropertyName, Position = 1, ParameterSetName = 'XmlElement')]
        [Parameter(ValueFromPipelineByPropertyName, Position = 1, ParameterSetName = 'XmlDocument')]
        [Parameter(ValueFromPipelineByPropertyName, Position = 1, ParameterSetName = 'XmlEx')]
        [ValidateNotNull()]
        [System.Management.Automation.ScriptBlock] $ScriptBlock,

        ## Xml namespace assigned to the element
        [Parameter(ValueFromPipelineByPropertyName, ParameterSetName = 'XmlEx')]
        [Parameter(ValueFromPipelineByPropertyName, ParameterSetName = 'XmlElement')]
        [Parameter(ValueFromPipelineByPropertyName, ParameterSetName = 'XmlDocument')]
        [ValidateNotNullOrEmpty()]
        [System.Uri] $Namespace,

        ## Xml namespace prefixed assigned to the element
        [Parameter(ValueFromPipelineByPropertyName, ParameterSetName = 'XmlEx')]
        [Parameter(ValueFromPipelineByPropertyName, ParameterSetName = 'XmlElement')]
        [Parameter(ValueFromPipelineByPropertyName, ParameterSetName = 'XmlDocument')]
        [ValidateNotNullOrEmpty()]
        [System.String] $Prefix,

        ## Existing Xml element to add the element to
        [Parameter(ValueFromPipelineByPropertyName, ParameterSetName = 'XmlElement')]
        [ValidateNotNull()]
        [System.Xml.XmlElement] $XmlElement,

        ## Existing Xml document containing the Xml element to add to
        [Parameter(ValueFromPipelineByPropertyName, ParameterSetName = 'XmlDocument')]
        [ValidateNotNull()]
        [System.Xml.XmlDocument] $XmlDocument,

        ## Returns the created XmlElement object to the pipeline. By default, this cmdlet does not generate any output.
        [Parameter(ValueFromPipelineByPropertyName)]
        [System.Management.Automation.SwitchParameter] $PassThru
    )
    begin {

        if ($PSCmdlet.ParameterSetName -eq 'XmlDocument') {

            $_xmlExCurrentDocument = $XmlDocument;
            $_xmlExCurrentElement = $XmlDocument;
        }
        elseif ($PSCmdlet.ParameterSetName -eq 'XmlElement') {

            Write-Debug ("Inferring document from element '{0}'," -f $Name);
            $_xmlExCurrentDocument = $XmlElement.OwnerDocument;
            $_xmlExCurrentElement = $XmlElement;
        }

        if (($PSBoundParameters.ContainsKey('Namespace')) -or
                ($PSBoundParameters.ContainsKey('Prefix'))) {

            [ref] $null = $PSBoundParameters.Remove('Name');
            $_xmlExCurrentNamespace = Resolve-XmlExNamespace @PSBoundParameters;
        }

        if ($null -eq $_xmlExCurrentDocument) {
            throw ($localized.XmlExDocumentNotFoundError);
        }

        if ($null -eq $_xmlExCurrentElement) {
            throw ($localized.XmlExElementNotFoundError);
        }

    } #end begin
    process {

        $elementDisplayName = $Name;
        if (-not [System.String]::IsNullOrEmpty($_xmlExCurrentNamespace.Prefix)) {
            $elementDisplayName = '{0}:{1}' -f $_xmlExCurrentNamespace.Prefix, $Name;
        }

        $_xmlExCurrentElementIndent ++;
        $padding = ''.PadRight($_xmlExCurrentElementIndent);
        $paddedMessage = '{0}{1}' -f $padding, ($localized.AddingElement -f $elementDisplayName, $_xmlExCurrentElement.LocalName);
        Write-Verbose -Message $paddedMessage;

        $xmlElement = $_xmlExCurrentDocument.CreateElement(
                                    $_xmlExCurrentNamespace.Prefix, $Name, $_xmlExCurrentNamespace.Uri);

        $_xmlExCurrentElement = $_xmlExCurrentElement.AppendChild($xmlElement);

        if ($PSBoundParameters.ContainsKey('ScriptBlock')) {
            [ref] $null = & $ScriptBlock;
        }

        if ($PassThru) {
            Write-Output -InputObject $_xmlExCurrentElement;
        }

    } #end process
} #end function XmlElement
