function Assert-XmlExXPath {
<#
    .SYNOPSIS
        Ensures that the specified XPath and element/attribute is present in an Xml document.
#>
    [CmdletBinding(SupportsShouldProcess)]
    param (
        ## Specifies the Xml document to add the Xml element/attribute to.
        [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [System.Xml.XmlDocument] $XmlDocument,

        ## Specifies the XPath location of the parent Xml element within the document to update.
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [System.String] $XPath,

        ## Specifies the name of the Xml element or Xml attribute to update.
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [System.String] $Name,

        ## Specifies the value of the Xml element or Xml attribute to update.
        [Parameter(ValueFromPipelineByPropertyName)]
        [System.String] $Value,

        ## Specifies the target is an attribute. Defaults to an element.
        [Parameter(ValueFromPipelineByPropertyName)]
        [System.Management.Automation.SwitchParameter] $IsAttribute,

        ## Specifies the target Xml element should be created if it does not exist.
        [Parameter(ValueFromPipelineByPropertyName)]
        [System.Management.Automation.SwitchParameter] $Force
    )
    begin {

        $XPath = $XPath.Trim('/');
        if (-not $IsAttribute) {

            ## We have an element so ensure it's added to the path..
            $XPath = '{0}/{1}' -f $XPath, $Name;
        }

    }
    process {

        ## Ensure all the path elements exist.
        foreach ($xpathNode in $XPath.Split('/')) {

            $currentPath = '{0}/{1}' -f $currentPath, $xpathNode;
            $xmlNode = $xmlDocument.SelectSingleNode($currentPath);

            if ($null -eq $xmlNode) {

                ## Create the element
                $verboseMessage = $localized.AppendingXmlElementPath -f $currentPath;
                $warningConfirmationMessage = $localized.ShouldProcessWarning;
                $warningDescriptionMessage = $localized.ShouldProcessOperationWarning -f 'Append', $xpathNode;
                if ($Force -or ($PSCmdlet.ShouldProcess($verboseMessage, $warningConfirmationMessage, $warningDescriptionMessage))) {

                    $xmlNode = $currentNode.AppendChild($XmlDocument.CreateElement($xpathNode));
                }
            }

            $currentNode = $xmlNode;

        }

        if ($IsAttribute) {

            ## Create the element
            $attributePath = '{0}[@{1}]' -f $currentPath, $xpathNode;
            $verboseMessage = $localized.AppendingXmlAttributePath -f $attributePath;
            $warningConfirmationMessage = $localized.ShouldProcessWarning;
            $warningDescriptionMessage = $localized.ShouldProcessOperationWarning -f 'Append', $attributePath;
            if ($Force -or ($PSCmdlet.ShouldProcess($verboseMessage, $warningConfirmationMessage, $warningDescriptionMessage))) {

                Add-XmlExAttribute -Name $Name -Value $Value -XmlElement $currentNode;
            }

        }
        else {

            $textNodePath = '{0}[#text]' -f $currentPath;
            $verboseMessage = $localized.AppendingXmlTextNodePath -f $textNodePath;
            $warningConfirmationMessage = $localized.ShouldProcessWarning;
            $warningDescriptionMessage = $localized.ShouldProcessOperationWarning -f 'Append', $textNodePath;
            if ($Force -or ($PSCmdlet.ShouldProcess($verboseMessage, $warningConfirmationMessage, $warningDescriptionMessage))) {

                if ($currentNode.'#text') {

                    # Add-XmlExText appends the value to the text node?!
                    $currentNode.'#text' = $Value;

                }
                else {

                    Add-XmlExText -XmlElement $currentNode -Text $Value;

                }

            }

        }

    } #end process
} #end function
