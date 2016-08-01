@{
    RootModule = 'XmlEx.psm1';
    ModuleVersion = '0.9.1';
    GUID = '2a98010d-0e5f-4779-b3b5-5f0b66fea533';
    Author = 'Iain Brighton';
    CompanyName = 'Virtual Engine';
    Copyright = '(c) 2016 Iain Brighton. All rights reserved.';
    Description = 'The XmlEx module implements a simple PowerShell DSL for the creation and manipulation of XML documents.';
    PowerShellVersion = '3.0';
    AliasesToExport = @('XmlAttribute','XmlComment','XmlDeclaration','XmlDocument','XmlElement','XmlNamespace','XmlText');
    FunctionsToExport = @('Add-XmlExAttribute','Add-XmlExComment','Add-XmlExElement','Add-XmlExNamespace','Add-XmlExText','Format-XmlEx','New-XmlExDocument','Set-XmlExDeclaration');
    PrivateData = @{
        PSData = @{  # Private data to pass to the module specified in RootModule/ModuleToProcess
            Tags = @('IainBrighton','XML','Powershell','DSL');
            LicenseUri = 'https://github.com/IainBrighton/XmlEx/blob/master/LICENSE';
            ProjectUri = 'https://github.com/IainBrighton/XmlEx';
            IconUri = 'https://raw.githubusercontent.com/IainBrighton/XmlEx/master/xml-tool-icon-53260.png';
        } # End of PSData hashtable
    } # End of PrivateData hashtable
}
