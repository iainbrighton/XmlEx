function Add-XmlExNamespace {
<#
    .SYNOPSIS
        Adds a XmlNamespace
    .DESCRIPTION
        The Add-XmlExNamespace cmdlet adds a Xml namespace to an existing XmlEx
        document namespace manager.
#>
    [CmdletBinding(DefaultParameterSetName = 'XmlEx')]
    [Alias('XmlNamespace')]
    param (
        ## Xml namespace prefix
        [Parameter(ValueFromPipelineByPropertyName, Position = 0, ParameterSetName = 'XmlEx')]
        [Parameter(ValueFromPipelineByPropertyName, Position = 0, ParameterSetName = 'XmlDocument')]
        [ValidateNotNullOrEmpty()]
        [System.String] $Prefix,

        ## Xml namespace uniform resource identifer
        [Parameter(Mandatory, ValueFromPipelineByPropertyName, Position = 1, ParameterSetName = 'XmlEx')]
        [Parameter(Mandatory, ValueFromPipelineByPropertyName, Position = 1, ParameterSetName = 'XmlDocument')]
        [ValidateNotNullOrEmpty()]
        [System.Uri] $Uri,

        ## Is the default Xml document namespace, automatically applied to all child elements, attributes and comments etc.
        [Parameter(ValueFromPipelineByPropertyName, ParameterSetName = 'XmlEx')]
        [Parameter(ValueFromPipelineByPropertyName, ParameterSetName = 'XmlDocument')]
        [ValidateNotNullOrEmpty()]
        [System.Management.Automation.SwitchParameter] $IsDefault,

        ## Xml document to add the namespace to
        [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName, ParameterSetName = 'XmlDocument')]
        [ValidateNotNull()]
        [System.Xml.XmlDocument] $XmlDocument
    )
    process {

        $callingFunction = (Get-PSCallStack)[2];
        if ($callingFunction.FunctionName -ne 'New-XmlExDocument<Process>') {
            throw ($localized.XmlExInvalidCallOutsideScopeError -f 'XmlNamespace','XmlDocument');
        }

        if ($PSBoundParameters.ContainsKey('Prefix')) {
            $xmlNamespaceKey = 'xmlns:{0}' -f $Prefix;
        }
        else {
            $xmlNamespaceKey = 'xmlns';
        }

        $xmlNamespace = [PSCustomObject] @{
            Prefix = $Prefix;
            Uri = $Uri.ToString();
            DisplayName = '{0}="{1}"' -f $xmlNamespaceKey, $Uri.ToString();
        };
        Write-Verbose -Message ($localized.SettingDocumentNamespace -f $xmlNamespace.DisplayName);
        $_xmlExDocumentNamespaces[$xmlNamespaceKey] = $xmlNamespace;

        if ($IsDefault) {

            Write-Verbose ($localized.SettingDefaultDocumentNamespace -f $xmlNamespace.Uri);
            Set-Variable -Name _xmlExCurrentNamespace -Value $xmlNamespace -Scope Script;

        } #end if default

    } #end process
} #end function XmlNamespace
