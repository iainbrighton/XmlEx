function Assert-XmlExFilePath {
<#
    .SYNOPSIS
        Ensures the target Xml document XPath does or doesn't exist.
    
    .DESCRIPTION
        Ensures that the specified Xml document XPath location does or does not exist. If the path does not exist, the
        cmdlet will create the Xml document XPath.
    #>
    [CmdletBinding(SupportsShouldProcess)]
    param (
        # Specifies a path to the Xml document.
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [System.String] $Path,

        ## Specifies whether the Xml document should or should not exist.
        [Parameter(ValueFromPipelineByPropertyName)]
        [ValidateSet('Present','Absent')]
        [System.String] $Ensure = 'Present'
    )
    process {

        if ($Ensure -eq 'Present') {

            if (Test-Path -Path $Path -PathType Leaf) {
            
                $xmlDocument = New-Object -TypeName System.Xml.XmlDocument;
                $xmlDocument.Load($Path);
            }
            else {

                Write-Verbose -Message ("Xml document '{0}' does not exist. Attempting to create.." -f $Path);

                $parentPath = Split-Path -Path $Path -Parent
                if (-not (Test-Path -Path $parentPath -PathType Container)) {

                    Write-Verbose -Message ("Parent directory '{0}' does not exist. Attempting to create.." -f $parentPath);
                    $newItemParams = @{
                        Path = Split-Path -Path $parentPath -Parent;
                        Name = Split-Path -Path $parentPath -Leaf;
                        ItemType = 'Directory';
                        Force = $true;;
                    }
                    [ref] $null = New-Item @newItemParams;
                }

                $xmlDocument = New-XmlExDocument -Verbose:$false {
                    
                    ## Ensure we have a declaration
                    Set-XmlExDeclaration
                }
            }

            return $xmlDocument;

        }
        elseif ($Ensure -eq 'Absent') {

            if (Test-Path -Path $Path -PathType Leaf) {

                Write-Verbose -Message ("Xml document '{0}' exists. Attempting to remove.." -f $Path);
                Remove-Item -Path $Path -Force;

            }
        }

    } #end process    
} #end function
