$repoRoot = (Resolve-Path "$PSScriptRoot\..\..").Path;

#Style rules based on Pester v. 4.0.2-rc2
Describe 'Style rules' -Tags "Style" {

    $excludedPaths = @(
                        '.git*',
                        '.vscode',
                        'DSCResources', # We'll take the public DSC resources as-is
                        'Release',
                        '*.png',
                        '*.enc',
                        '*.dll',
                        'appveyor-tools',
                        'TestResults.xml',
                        'Tests',
                        'Docs'
                    );

    Get-ChildItem -Path $repoRoot -Exclude $excludedPaths |
        ForEach-Object {
            Get-ChildItem -Path $_.FullName -Recurse |
                Where-Object { $_ -is [System.IO.FileInfo] } |
                    ForEach-Object {

                        It "$($_.FullName) contains no trailing whitespace" {
                            $badLines = @(
                                $lines = [System.IO.File]::ReadAllLines($_.FullName)
                                $lineCount = $lines.Count

                                for ($i = 0; $i -lt $lineCount; $i++) {
                                    if ($lines[$i] -match '\s+$') {
                                        'File: {0}, Line: {1}' -f $_.FullName, ($i + 1)
                                    }
                                }
                            )

                            $badLines.Count | Should Be 0
                        }

                        It "$($_.FullName) end with a newline" {

                            $string = [System.IO.File]::ReadAllText($_.FullName)
                            ($string.Length -gt 0 -and $string[-1] -ne "`n") | Should Be $false
                        }
                    }
        }

}
