function Set-XmlExConfigKeyValue {
    [CmdletBinding(SupportsShouldProcess, DefaultParameterSetName = 'Path')]
    param (
        # Specifies a path to one or more locations. Wildcards are permitted.
        [Parameter(Mandatory, Position = 0, ParameterSetName = 'Path', ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [ValidateNotNullOrEmpty()]
        [SupportsWildcards()]
        [System.String[]] $Path,

        # Specifies a path to one or more locations. Unlike the Path parameter, the value of the LiteralPath parameter is
        # used exactly as it is typed. No characters are interpreted as wildcards. If the path includes escape characters,
        # enclose it in single quotation marks. Single quotation marks tell Windows PowerShell not to interpret any
        # characters as escape sequences.
        [Parameter(Mandatory, Position = 0, ParameterSetName = 'LiteralPath', ValueFromPipelineByPropertyName)]
        [Alias('PSPath')]
        [ValidateNotNullOrEmpty()]
        [System.String[]] $LiteralPath,

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

        ## Specifies the target Xml document file should be created if it does not exist.
        [Parameter(ValueFromPipelineByPropertyName)]
        [System.Management.Automation.SwitchParameter] $Force
    )
    begin {

        [ref] $null = $PSBoundParameters.Remove('Path');
        [ref] $null = $PSBoundParameters.Remove('LiteralPath');
        $paths = @();

    }
    process {
        
        if ($PSCmdlet.ParameterSetName -eq 'Path') {

            foreach ($filePath in $Path) {

                if (-not $Force) {
                    
                    if (-not (Test-Path -Path $filePath)) {

                        $errorMessage = $localized.CannotFindPathError -f $filePath;
                        $ex = New-Object System.Management.Automation.ItemNotFoundException $errorMessage;
                        $category = [System.Management.Automation.ErrorCategory]::ObjectNotFound;
                        $errorRecord = New-Object System.Management.Automation.ErrorRecord $ex, 'PathNotFound', $category, $filePath;
                        $PSCmdlet.WriteError($errorRecord);
                        continue;
                    }

                    # Resolve any wildcards that might be in the path
                    $provider = $null;
                    $paths += $psCmdlet.SessionState.Path.GetResolvedProviderPathFromPSPath($filePath, [ref] $provider);

                }
                else {

                    $paths += $PSCmdlet.SessionState.Path.GetUnresolvedProviderPathFromPSPath($filePath);

                }

            } #end foreach path
        }
        else {

            foreach ($filePath in $LiteralPath) {

                if (-not $Force) {

                    if (-not (Test-Path -LiteralPath $filePath)) {

                        $errorMessage = $localized.CannotFindPathError -f $filePath;
                        $ex = New-Object System.Management.Automation.ItemNotFoundException $errorMessage;
                        $category = [System.Management.Automation.ErrorCategory]::ObjectNotFound;
                        $errorRecord = New-Object System.Management.Automation.ErrorRecord $ex, 'PathNotFound', $category, $filePath;
                        $PSCmdlet.WriteError($errorRecord);
                        continue;
                    }

                }

                # Resolve any relative paths
                $paths += $PSCmdlet.SessionState.Path.GetUnresolvedProviderPathFromPSPath($filePath);

            } #end foreach literal path
        }

    } #end process
    end {

        foreach ($filePath in $paths) {

            Write-Verbose -Message ($localized.ProcessingDocument -f $filePath);
            $xmlDocument = Assert-XmlExFilePath -Path $filePath -Ensure 'Present';;
            Assert-XmlExXPath -XmlDocument $xmlDocument @PSBoundParameters;
            
            $verboseMessage = $localized.SavingDocument -f $filePath;
            $warningConfirmationMessage = $localized.ShouldProcessWarning;
            $warningDescriptionMessage = $localized.ShouldProcessOperationWarning -f 'Save', $filePath;

            if ($Force -or ($PSCmdlet.ShouldProcess($verboseMessage, $warningConfirmationMessage, $warningDescriptionMessage))) {

                $xmlDocument.Save($filePath);
            }
        }

    } #end
} #end function
