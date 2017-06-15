function Add-XmlExAttribute {
<#
    .SYNOPSIS
        Adds a XmlAttribute
    .DESCRIPTION
        The Add-XmlExAttribute cmdlet adds a System.Xml.XmlAttribute to a XmlEx
        document or existing System.Xml.XmlDocument object.
#>
    [CmdletBinding(DefaultParameterSetName = 'XmlEx')]
    [Alias('XmlAttribute')]
    [OutputType([System.Xml.XmlAttribute])]
    param (
        ## Xml attribute name to add
        [Parameter(Mandatory, Position = 0, ParameterSetName = 'XmlEx')]
        [Parameter(Mandatory, Position = 0, ParameterSetName = 'XmlElement')]
        [ValidateNotNullOrEmpty()]
        [System.String] $Name,

        ## Xml attribute value to add
        [Parameter(Mandatory, Position = 1, ParameterSetName = 'XmlEx')]
        [Parameter(Mandatory, Position = 1, ParameterSetName = 'XmlElement')]
        [ValidateNotNull()]
        [System.Object] $Value,

        ## Xml namespace assigned to the attribute
        [Parameter(ParameterSetName = 'XmlEx')]
        [Parameter(ParameterSetName = 'XmlElement')]
        [ValidateNotNullOrEmpty()]
        [System.Uri] $Namespace,

        ## Xml namespace prefixed assigned to the element
        [Parameter(ValueFromPipelineByPropertyName, ParameterSetName = 'XmlEx')]
        [Parameter(ValueFromPipelineByPropertyName, ParameterSetName = 'XmlElement')]
        [ValidateNotNullOrEmpty()]
        [System.String] $Prefix,

        ## Existing Xml element to add the attribute to
        [Parameter(Mandatory, ValueFromPipelineByPropertyName, ParameterSetName = 'XmlElement')]
        [ValidateNotNull()]
        [System.Xml.XmlElement] $XmlElement,

        ## Returns the create XmlAttrbiute object to the pipeline. By default, this cmdlet does not generate any output.
        [Parameter(ValueFromPipelineByPropertyName)]
        [System.Management.Automation.SwitchParameter] $PassThru
    )
    begin {

        if ($PSCmdlet.ParameterSetName -eq 'XmlElement') {

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

        $attributeDisplayName = $Name;
        if (-not [System.String]::IsNullOrEmpty($_xmlExCurrentNamespace.Prefix)) {
            $attributeDisplayName = '{0}:{1}' -f $_xmlExCurrentNamespace.Prefix, $Name;
        }

        $_xmlExCurrentElementIndent ++;
        $padding = ''.PadRight($_xmlExCurrentElementIndent);
        $paddedMessage = '{0}{1}' -f $padding, ($localized.AddingAttribute -f $attributeDisplayName, $_xmlExCurrentElement.LocalName);
        Write-Verbose -Message $paddedMessage;

        $xmlAttribute = $_xmlExCurrentDocument.CreateAttribute($_xmlExCurrentNamespace.Prefix, $Name, $_xmlExCurrentNamespace.Uri);
        $xmlAttribute.InnerText = $Value;

        if ($_xmlExCurrentElement -is [System.Xml.XmlDocument]) {

            if ($null -eq $_xmlExCurrentDocument.DocumentElement) {
                throw ($localized.XmlExDocumentMissingXmlElementError);
            }

            [ref] $null = $_xmlExCurrentDocument.DocumentElement.SetAttributeNode($xmlAttribute);
        }
        else {

            [ref] $null = $_xmlExCurrentElement.SetAttributeNode($xmlAttribute);
        }

        if ($PassThru) {

            Write-Output -InputObject $xmlAttribute;
        }

    } #end process
} #end function XmlAttribute
