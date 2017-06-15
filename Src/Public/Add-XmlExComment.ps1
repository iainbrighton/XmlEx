function Add-XmlExComment {
<#
    .SYNOPSIS
        Adds a XmlComment
    .DESCRIPTION
        The Add-XmlExComment cmdlet adds a System.Xml.XmlComment to a XmlEx
        document or existing System.Xml.XmlDocument object.
#>
    [CmdletBinding(DefaultParameterSetName = 'XmlEx')]
    [Alias('XmlComment')]
    [OutputType([System.Xml.XmlComment])]
    param (
        ## Comment to insert into the Xml document
        [Parameter(Mandatory, ValueFromPipeline, Position = 0, ParameterSetName = 'XmlEx')]
        [Parameter(Mandatory, ValueFromPipeline, Position = 0, ParameterSetName = 'XmlElement')]
        [ValidateNotNullOrEmpty()]
        [System.String] $Comment,

        ## Existing Xml element to add the comment to
        [Parameter(Mandatory, ValueFromPipelineByPropertyName, ParameterSetName = 'XmlElement')]
        [ValidateNotNull()]
        [System.Xml.XmlElement] $XmlElement,

        ## Returns the XmlComment to the pipeline. By default, this cmdlet does not generate any output.
        [Parameter(ValueFromPipelineByPropertyName)]
        [System.Management.Automation.SwitchParameter] $PassThru
    )
    begin {

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
        $paddedMessage = '{0}{1}' -f $padding, ($localized.AddingComment -f $_xmlExCurrentElement.LocalName);
        Write-Verbose -Message $paddedMessage;

        $xmlComment = $_xmlExCurrentDocument.CreateComment($Comment);
        [ref] $null = $_xmlExCurrentElement.AppendChild($xmlComment);

        if ($PassThru) {
            Write-Output -InputObject $xmlComment;
        }

    } #end process
} #end function XmlComment
