function Resolve-XmlExNamespace {
<#
    .SYNOPSIS
        Resolves supplied prefix/namespace from the XmlEx namespace manager.
    .DESCRIPTION
        The Resolve-XmlExNamespace method resolves defined Xml namespaces
        within the XmlEx document.

        Namespaces can be resolved by prefix or Uri, with Prefix being
        checked first. If no match is found, the namespace Uri is checked.
        If the namespace is not defined, an entry is not created in the XmlEx
        namespace manager, but object is still returned.
#>
    [CmdletBinding()]
    [OutputType([System.Management.Automation.PSCustomObject])]
    param (
        ## Namespace prefix
        [Parameter(ValueFromPipeline, ValueFromPipelineByPropertyName, ParameterSetName = 'Namespace')]
        [System.String] $Prefix,

        ## Namespace Uri
        [Parameter(ValueFromPipeline, ValueFromPipelineByPropertyName, ParameterSetName = 'Namespace')]
        [System.String] $Namespace,

        ## Catch-all to enable splatting
        [Parameter(ValueFromRemainingArguments)]
        [System.Object[]] $RemainingArguments
    )
    process {

        if ($PSBoundParameters.ContainsKey('Prefix')) {
            ## Try matching on Prefix first
            foreach ($namespaceKey in $_xmlExDocumentNamespaces.Keys) {

                $ns = $_xmlExDocumentNamespaces[$namespaceKey];
                if ($ns.Prefix -eq $Prefix) {
                    $xmlNamespace = $ns;
                    break;
                }
            }
        }

        ## If we have no match, try matching on Uri
        if (($PSBoundParameters.ContainsKey('Namespace')) -and ($null -eq $xmlNamespace)) {

            foreach ($namespaceKey in $_xmlExDocumentNamespaces.Keys) {

                $ns = $_xmlExDocumentNamespaces[$namespaceKey];
                if ($ns.Uri -eq $Namespace) {
                    $xmlNamespace = $ns;
                    break;
                }
            }
        }

        if (($null -ne $xmlNamespace) -and ([System.String]::IsNullOrEmpty($xmlNamespace.Prefix))) {

            <#
                If we have a defined default namespace, remove the explicit namespace Uri, otherwise we'll end up with
                somthing like: d2p1:att2="value2" xmlns:d2p1="http://www.w3.org/XML/1998/namespace" when we add the
                object with a namespace.

                We don't want to modify the existing object, so create a new one
            #>
            $xmlNamespace = [PSCustomObject] @{
                Prefix = $null;
                Uri = $null;
                DisplayName = 'xmlns="{0}"' -f $Namespace;
            }
        }
        elseif ($null -eq $xmlNamespace) {

            ## We have no matching defined namespace, so create an namespace custom object

            $xmlNamespace = [PSCustomObject] @{
                Prefix = $Prefix;
                Uri = $Namespace;
                DisplayName = 'xmlns="{0}"' -f $Namespace;
            }

            if ($PSBoundParameters.ContainsKey('Prefix')) {
                $XmlNamespace.DisplayName = 'xmlns:{0}="{1}"' -f $Prefix, $Namespace;
            }
        }

        return $xmlNamespace;

    } #end process
} #end function Resolve-XmlExNamespace
