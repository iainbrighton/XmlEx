# XmlEx

XmlEx (XML EXtensions) provides a PowerShell domain-specific language (DSL) to easily create and update XML documents without having to understand or manipulate the underlying [System.Xml.XmlDocument] objects. XmlEx provides a simple way to:

* Create and append XML documents in PowerShell
* Manage XML document namespaces and prefixes

## Why?

Traditionally, creating XML documents with PowerShell is slow, cumbersome and errorprone. I discovered this whilst developing the [PScribo](http://github.com/iainbrighton/PScribo) plugin to create Word documents.
After my eyes started to bleed looking at the code, I decided there had to be an easier way and `XmlEx` is a result of this!

Take the following short XML document as an example:
```XML
<?xml version="1.0" encoding="utf-8" standalone="yes"?>
<w:document xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main" xmlns:xml="http://www.w3.org/XML/1998/namespace">
  <w:body>
    <w:p>
      <w:pPr>
        <w:pStyle w:val="MyStyle" />
        <w:spacing w:before="160" w:after="160" />
      </w:pPr>
      <w:r>
        <w:t />
      </w:r>
    </w:p>
  </w:body>
</w:document>
```
To generate this in PowerShell code requires something similar to this:

```powershell
$xmlDocument = New-Object -TypeName 'System.Xml.XmlDocument';
$xmlnsMain = 'http://schemas.openxmlformats.org/wordprocessingml/2006/main';
[ref] $null = $xmlDocument.AppendChild($xmlDocument.CreateXmlDeclaration('1.0', 'utf-8', 'yes'));
$documentXml = $xmlDocument.AppendChild($xmlDocument.CreateElement('w', 'document', $xmlnsMain));
[ref] $null = $xmlDocument.DocumentElement.SetAttribute('xmlns:xml', 'http://www.w3.org/XML/1998/namespace');

$body = $documentXml.AppendChild($xmlDocument.CreateElement('w', 'body', $xmlnsMain));

$p = $body.AppendChild($XmlDocument.CreateElement('w', 'p', $xmlnsMain));
$pPr = $p.AppendChild($XmlDocument.CreateElement('w', 'pPr', $xmlnsMain));

$pStyle = $pPr.AppendChild($XmlDocument.CreateElement('w', 'pStyle', $xmlnsMain));
[ref] $null = $pStyle.SetAttribute('val', $xmlnsMain, 'MyStyle');

$spacing = $pPr.AppendChild($XmlDocument.CreateElement('w', 'spacing', $xmlnsMain));
[ref] $null = $spacing.SetAttribute('before', $xmlnsMain, 160);
[ref] $null = $spacing.SetAttribute('after', $xmlnsMain, 160);

$r = $p.AppendChild($XmlDocument.CreateElement('w', 'r', $xmlnsMain));
$t = $r.AppendChild($XmlDocument.CreateElement('w', 't', $xmlnsMain));
```
Using `XmlEx`, this can be simply written as:

```powershell
$xmlDocument = XmlDocument {
    XmlDeclaration -Encoding 'utf-8' -Standalone 'yes'
    XmlNamespace -Prefix xml -Uri 'http://www.w3.org/XML/1998/namespace'
    XmlElement document -Prefix w -Namespace 'http://schemas.openxmlformats.org/wordprocessingml/2006/main' {
        XmlElement body {
            XmlElement p {
                XmlElement pPr {
                    XmlElement pStyle {
                        XmlAttribute 'val' 'MyStyle'
                    }
                    XmlElement spacing {
                        XmlAttribute 'before' '160'
                        XmlAttribute 'after' '160'
                    }
                }
                XmlElement r {
                    XmlElement t
                }
            }
        }
    }
}
```

## Quick start

* Install XmlEx module from the [PowerShell Gallery](https://powershellgallery.com):

```powershell
Install-Module -Name XmlEx -Scope CurrentUser
Import-Module XmlEx
```

There are examples in module's \Examples folder.
