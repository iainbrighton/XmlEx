## Import localisation strings
if (Test-Path -Path (Join-Path -Path $PSScriptRoot -ChildPath $PSUICulture)) {

    $importLocalizedDataParams = @{
        BindingVariable = 'localized';
        FileName = 'XmlEx.Resources.psd1';
        BaseDirectory = Join-Path -Path $PSScriptRoot -ChildPath $PSUICulture;
    }
}
else {

    # fallback to en-US
    $importLocalizedDataParams = @{
        BindingVariable = 'localized';
        FileName = 'XmlEx.Resources.psd1';
        BaseDirectory = Join-Path -Path $PSScriptRoot -ChildPath 'en-US';
    }
}
Import-LocalizedData @importLocalizedDataParams;

## Import the \Lib files. This permits loading of the module's functions for unit testing, without having to unload/load the module.
$moduleRoot = Split-Path -Path $MyInvocation.MyCommand.Path -Parent;
$moduleSrcPath = Join-Path -Path $moduleRoot -ChildPath 'Src';
Get-ChildItem -Path $moduleSrcPath -Include '*.ps1' -Recurse |
    ForEach-Object {
        Write-Verbose -Message ('Importing library\source file ''{0}''.' -f $_.FullName);
        . $_.FullName;
    }
