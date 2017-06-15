function Add-XmlExText {
<#
    .SYNOPSIS
        Adds a XmlText node.
    .DESCRIPTION
        The Add-XmlExText cmdlet adds a System.Xml.XmlTextNode to a XmlEx
        document or existing System.Xml.XmlDocument object.
#>
    [CmdletBinding(DefaultParameterSetName = 'XmlEx')]
    [Alias('XmlText')]
    [OutputType([System.Xml.XmlText])]
    param (
        ## Xml text to add
        [Parameter(Mandatory, ValueFromPipeline, Position = 0, ParameterSetName = 'XmlEx')]
        [Parameter(Mandatory, ValueFromPipeline, Position = 0, ParameterSetName = 'XmlElement')]
        [ValidateNotNullOrEmpty()]
        [System.String] $Text,

        ## Existing Xml element to add the text node to
        [Parameter(Mandatory, ValueFromPipelineByPropertyName, ParameterSetName = 'XmlElement')]
        [ValidateNotNull()]
        [System.Xml.XmlElement] $XmlElement,

        ## Returns the created  XmlText object to the pipeline. By default, this cmdlet does not generate any output.
        [Parameter(ValueFromPipelineByPropertyName)]
        [System.Management.Automation.SwitchParameter] $PassThru
    )
    begin {

        $callingFunction = (Get-PSCallStack)[2];
        if ($callingFunction.FunctionName -eq 'New-XmlExDocument<Process>') {
            throw ($localized.XmlExInvalidCallWithinScopeError -f 'XmlText','XmlDocument','XmlElement');
        }

        if ($PSCmdlet.ParameterSetName -eq 'XmlElement') {

            Write-Debug ("Inferring document from element '{0}'," -f $Name);
            $_xmlExCurrentDocument = $XmlElement.OwnerDocument;
            $_xmlExCurrentElement = $XmlElement;
        }

        if ($null -eq $_xmlExCurrentDocument) {
            throw ($localized.XmlExDocumentNotFoundError);
        }

        if ($null -eq $_xmlExCurrentElement) {
            throw ($localized.XmlExElementNotFoundError);
        }

    } #end begin
    process {

        $padding = '';
        if ($_xmlExCurrentElementIndent) {
            $padding = ''.PadRight($_xmlExCurrentElementIndent +1);
        }
        $paddedMessage = '{0}{1}' -f $padding, ($localized.AddingTextNode -f $_xmlExCurrentElement.LocalName);
        Write-Verbose -Message $paddedMessage;

        $xmlTextNode = $_xmlExCurrentDocument.CreateTextNode($Text);
        [ref] $null = $_xmlExCurrentElement.AppendChild($xmlTextNode);

        if ($PassThru) {
            Write-Output -InputObject $xmlTextNode;
        }

    } #end process
} #end function XmlText
