; Script generated by the Inno Setup Script Wizard.
; SEE THE DOCUMENTATION FOR DETAILS ON CREATING INNO SETUP SCRIPT FILES!

#define MyAppName "Visual Leak Detector"
#define MyAppVersion "2.5.1"
#define MyAppPublisher "VLD Team"
#define MyAppURL "http://vld.codeplex.com/"
#define MyAppRegKey "Software\Visual Leak Detector"

[Setup]
; NOTE: The value of AppId uniquely identifies this application.
; Do not use the same AppId value in installers for other applications.
; (To generate a new GUID, click Tools | Generate GUID inside the IDE.)
AppId={{851FBFF7-5148-40A2-A654-942BE80F5B90}
AppName={#MyAppName}
AppVersion={#MyAppVersion}
;AppVerName={#MyAppName} {#MyAppVersion}
AppPublisher={#MyAppPublisher}
AppPublisherURL={#MyAppURL}
AppSupportURL={#MyAppURL}
AppUpdatesURL={#MyAppURL}
DefaultDirName={reg:HKLM\{#MyAppRegKey},InstallPath|{pf}\{#MyAppName}}
DefaultGroupName={#MyAppName}
LicenseFile=license-free.txt
OutputBaseFilename=vld-{#MyAppVersion}-setup
Compression=lzma
SolidCompression=True
MinVersion=0,6.0
; Tell Windows Explorer to reload the environment
ChangesEnvironment=yes
AllowNoIcons=yes
DisableDirPage=auto
DirExistsWarning=no
WizardImageFile=compiler:WizModernImage-IS.bmp
WizardSmallImageFile=WizSmallImage.bmp

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"

[Icons]
Name: "{group}\View Documentation"; Filename: "http://vld.codeplex.com/documentation"

[Files]
Source: "dbghelp\x64\dbghelp.dll"; DestDir: "{app}\bin\Win64"; Flags: ignoreversion
Source: "dbghelp\x64\Microsoft.Windows.DebuggersAndTools.manifest"; DestDir: "{app}\bin\Win64"; Flags: ignoreversion
Source: "dbghelp\x86\dbghelp.dll"; DestDir: "{app}\bin\Win32"; Flags: ignoreversion
Source: "dbghelp\x86\Microsoft.Windows.DebuggersAndTools.manifest"; DestDir: "{app}\bin\Win32"; Flags: ignoreversion
Source: "..\src\bin\Win32\Release-v140\vld.lib"; DestDir: "{app}\lib\Win32"; Flags: ignoreversion
Source: "..\src\bin\Win32\Release-v140\vld_x86.dll"; DestDir: "{app}\bin\Win32"; Flags: ignoreversion
Source: "..\src\bin\Win32\Release-v140\vld_x86.pdb"; DestDir: "{app}\bin\Win32"; Flags: ignoreversion
Source: "..\src\bin\x64\Release-v140\vld.lib"; DestDir: "{app}\lib\Win64"; Flags: ignoreversion
Source: "..\src\bin\x64\Release-v140\vld_x64.dll"; DestDir: "{app}\bin\Win64"; Flags: ignoreversion
Source: "..\src\bin\x64\Release-v140\vld_x64.pdb"; DestDir: "{app}\bin\Win64"; Flags: ignoreversion
Source: "..\src\vld.h"; DestDir: "{app}\include"; Flags: ignoreversion
Source: "..\src\vld_def.h"; DestDir: "{app}\include"; Flags: ignoreversion
Source: "..\vld.ini"; DestDir: "{app}"; Flags: ignoreversion
Source: "..\AUTHORS.txt"; DestDir: "{app}"; Flags: ignoreversion
Source: "..\CHANGES.txt"; DestDir: "{app}"; Flags: ignoreversion
Source: "..\COPYING.txt"; DestDir: "{app}"; Flags: ignoreversion

[Tasks]
Name: "modifypath"; Description: "Add VLD directory to your environmental path"
Name: "modifyVS2008Props"; Description: "Add VLD directory to VS 2008"
Name: "modifyVS2010Props"; Description: "Add VLD directory to VS 2010 - VS 2015"

[ThirdParty]
UseRelativePaths=True

[Registry]
Root: "HKLM32"; Subkey: "{#MyAppRegKey}"; Flags: uninsdeletekeyifempty
Root: "HKLM32"; Subkey: "{#MyAppRegKey}"; ValueType: string; ValueName: "InstalledVersion"; ValueData: "{#MyAppVersion}"
Root: "HKLM32"; Subkey: "{#MyAppRegKey}"; ValueType: string; ValueName: "InstallPath"; ValueData: "{app}"
Root: "HKLM32"; Subkey: "{#MyAppRegKey}"; ValueType: string; ValueName: "IniFile"; ValueData: "{app}\vld.ini"

Root: "HKLM64"; Subkey: "{#MyAppRegKey}"; Flags: uninsdeletekeyifempty
Root: "HKLM64"; Subkey: "{#MyAppRegKey}"; ValueType: string; ValueName: "InstalledVersion"; ValueData: "{#MyAppVersion}"
Root: "HKLM64"; Subkey: "{#MyAppRegKey}"; ValueType: string; ValueName: "InstallPath"; ValueData: "{app}"
Root: "HKLM64"; Subkey: "{#MyAppRegKey}"; ValueType: string; ValueName: "IniFile"; ValueData: "{app}\vld.ini"

[Code]
type
  TKey = string;
  TValue = string;
  TKeyValue = record
    Key: TKey;
    Value: TValue;
  end;
  TKeyValueList = array of TKeyValue;

const
    ModPathName = 'modifypath';
    ModPathType = 'system';

function ModPathDir(): TArrayOfString;
begin
    setArrayLength(Result, 2);
    Result[0] := ExpandConstant('{app}\bin\Win32');
    Result[1] := ExpandConstant('{app}\bin\Win64');
end;

#include "modpath.iss"

function GetUninstallString(regPath: string): String;
var
  sUnInstPath: String;
  sUnInstString: String;
begin
  sUnInstPath := ExpandConstant(regPath);
  sUnInstString := '';
  if not RegQueryStringValue(HKLM, sUnInstPath, 'UninstallString', sUnInstString) then
    RegQueryStringValue(HKCU, sUnInstPath, 'UninstallString', sUnInstString);
  Result := sUnInstString;
end;

function UninstallOldVersion(regPath: string; params: string): Boolean;
var
  iResultCode: Integer;
begin
  // default return value
  Result := False;

  if SuppressibleMsgBox('VLD is already installed. Uninstall the current version?',
    mbConfirmation, MB_YESNO, IDYES) = IDYES then
  begin
    regPath := RemoveQuotes(regPath);
    if Exec(regPath, params,'', SW_HIDE, ewWaitUntilTerminated, iResultCode) then
      Result := True;
  end
end;

function UninstallOldVersions(): Boolean;
var
  nsisUnInstallString: String;
  isUnInstallString: String;
begin
  nsisUnInstallString := GetUninstallString('Software\Microsoft\Windows\CurrentVersion\Uninstall\Visual Leak Detector');
  isUnInstallString := GetUninstallString('Software\Microsoft\Windows\CurrentVersion\Uninstall\{#emit SetupSetting("AppId")}_is1');
  Result := True;
  if (nsisUnInstallString <> '') then
  begin
    Result := UninstallOldVersion(nsisUnInstallString, '/S');
  end
  else if (isUnInstallString <> '') then
  begin
    Result := UninstallOldVersion(isUnInstallString, '/SILENT /NORESTART /SUPPRESSMSGBOXES');
  end;
end;

function Count(What, Where: String): Integer;
begin
  Result := 0;
  if Length(What) = 0 then
    exit;
  while Pos(What,Where)>0 do
  begin
    Where := Copy(Where,Pos(What,Where)+Length(What),Length(Where));
    Result := Result + 1;
  end;
end;

procedure Explode(var ADest: TKeyValueList; aText, aSeparator: String);
var tmp: Integer;
  item: TKeyValue;
begin
  SetArrayLength(ADest, (Count(aSeparator,aText) / 2) + 1);
  tmp := 0;
  repeat
    item.Key := '';
    item.Value := '';
    if Pos(aSeparator,aText)>0 then
    begin
      item.Key := Copy(aText,1,Pos(aSeparator,aText)-1);
      aText := Copy(aText,Pos(aSeparator,aText)+Length(aSeparator),Length(aText));
    end else
    begin
      item.Key := aText;
      aText := '';
    end;
    if Pos(aSeparator,aText)>0 then
    begin
      item.Value := Copy(aText,1,Pos(aSeparator,aText)-1);
      aText := Copy(aText,Pos(aSeparator,aText)+Length(aSeparator),Length(aText));
    end else
    begin
      item.Value := aText;
      aText := '';
    end;
    ADest[tmp] := item;
    tmp := tmp + 1;
  until Length(aText)=0;
end;

function Merge(ADest: TKeyValueList; aSeparator: String): String;
var i, n, l: Integer;
  str: String;
begin
  n := GetArrayLength(ADest);
  l := n + (n - 1);
  if l < 0 then l := 0;
  Result := '';
  for i := 0 to n - 1 do
  begin
    str := ADest[i].Key + aSeparator + ADest[i].Value;
    Result := Result + str;
    if i < n - 1 then Result := Result + aSeparator;
  end;
end;

function UpdatePath(dirList: String; path: String): String;
begin
  if dirList = '' then
    Result := path
  else if Pos(path, dirList) = 0 then
    Result := path + ';' + dirList
  else
    Result := dirList;
end;

procedure UpdatePaths(var dirList: string; path32: string; path64: string);
var map: TKeyValueList;
  i: Integer;
begin
  Explode(map, dirList, '|');
  for i := 0 to GetArrayLength(map) - 1 do
  begin
    if map[i].Key = 'Win32' then map[i].Value := UpdatePath(map[i].Value, path32)
    else if map[i].Key = 'x64' then map[i].Value := UpdatePath(map[i].Value, path64);
  end;
  dirList := Merge(map, '|');
  Log(dirList);
end;

procedure ModifySettings(filename: string);
var
  XMLDocument: Variant;
  XMLParent, XMLNode, XMLNodes: Variant;
  IncludeDirectoriesNode: Variant;
  AdditionalIncludeDirectories: string;
  LibraryDirectoriesNode: Variant;
  AdditionalLibraryDirectories: string;
  libfolder: string;
begin
  XMLDocument := CreateOleObject('Msxml2.DOMDocument.3.0');
  try
    XMLDocument.async := False;
    XMLDocument.load(filename);
    if (XMLDocument.parseError.errorCode = 0) then
    begin
      XMLDocument.setProperty('SelectionLanguage', 'XPath');
      XMLNodes := XMLDocument.SelectNodes('//UserSettings/ToolsOptions/ToolsOptionsCategory[@name="Projects"]/ToolsOptionsSubCategory[@name="VCDirectories"]');
      if XMLNodes.Length = 0 then
        Exit;
      XMLParent := XMLNodes.Item[0];
      XMLNodes := XMLParent.SelectNodes('//PropertyValue[@name="LibraryDirectories"]');
      if XMLNodes.Length > 0 then
        LibraryDirectoriesNode := XMLNodes.Item[0];
      XMLNodes := XMLParent.SelectNodes('//PropertyValue[@name="IncludeDirectories"]');
      if XMLNodes.Length > 0 then
        IncludeDirectoriesNode := XMLNodes.Item[0];
      AdditionalIncludeDirectories := '';
      if not VarIsNull(IncludeDirectoriesNode) then
        AdditionalIncludeDirectories := IncludeDirectoriesNode.Text;
      AdditionalLibraryDirectories := '';
      if not VarIsNull(LibraryDirectoriesNode) then
        AdditionalLibraryDirectories := LibraryDirectoriesNode.Text;
      UpdatePaths(AdditionalIncludeDirectories, ExpandConstant('{app}\include'), ExpandConstant('{app}\include'));
      UpdatePaths(AdditionalLibraryDirectories, ExpandConstant('{app}\lib\Win32'), ExpandConstant('{app}\lib\Win64'));
      IncludeDirectoriesNode.Text := AdditionalIncludeDirectories;
      LibraryDirectoriesNode.Text := AdditionalLibraryDirectories;
      XMLDocument.save(filename);
    end;
  except
    ShowExceptionMessage;
  end;
end;

procedure ModifyVS2008Settings();
var
  Path, CurSettings: string;
begin
  if RegQueryStringValue(HKEY_CURRENT_USER, 'Software\Microsoft\VisualStudio\9.0',
     'VisualStudioLocation', Path) then
  begin
    StringChangeEx(Path, '%USERPROFILE%', GetEnv('USERPROFILE'), True);
    if RegQueryStringValue(HKEY_CURRENT_USER, 'Software\Microsoft\VisualStudio\9.0\Profile',
       'AutoSaveFile', CurSettings) then
    begin
      StringChangeEx(CurSettings, '%vsspv_visualstudio_dir%', Path, True);
      ModifySettings(CurSettings);
    end;
  end;
end;

function EncodeString(str: string): string;
begin
  Result := str;
  StringChangeEx(Result, '(', '%28', True);
  StringChangeEx(Result, ')', '%29', True);
end;

procedure UpdateString(var dirList: string; path: string; suffix: string);
begin
  if dirList = '' then
    dirList := path + suffix
  else if (Pos(path, dirList) = 0) and (Pos(EncodeString(path), dirList) = 0) then
    dirList := path + dirList;
  Log(dirList);
end;

procedure ModifyProps(filename: string; libfolder: string);
var
  XMLDocument: Variant;
  XMLParent, IdgNode, XMLNode, XMLNodes: Variant;
  IncludeDirectoriesNode: Variant;
  AdditionalIncludeDirectories: string;
  DynamicLibraryDirectoriesNode: Variant;
  AdditionalDynamicLibraryDirectories: string;
  StaticLibraryDirectoriesNode: Variant;
  AdditionalStaticLibraryDirectories: string;
begin
  if not FileExists(filename) then
    Exit;
  XMLDocument := CreateOleObject('Msxml2.DOMDocument.3.0');
  try
    XMLDocument.async := False;
    XMLDocument.load(filename);
    if (XMLDocument.parseError.errorCode = 0) then
    begin
      XMLDocument.setProperty('SelectionLanguage', 'XPath');
      XMLDocument.setProperty('SelectionNamespaces', 'xmlns:b=''http://schemas.microsoft.com/developer/msbuild/2003''');
      XMLNodes := XMLDocument.SelectNodes('//b:Project');
      if XMLNodes.Length = 0 then
        Exit;
      IdgNode := XMLNodes.Item[0];
      XMLNodes := IdgNode.SelectNodes('//b:ItemDefinitionGroup');
      if XMLNodes.Length > 0 then
        IdgNode := XMLNodes.Item[0]
      else
      begin
        XMLNode := XMLDocument.CreateNode(1, 'ItemDefinitionGroup',
                    'http://schemas.microsoft.com/developer/msbuild/2003');
        IdgNode := IdgNode.AppendChild(XMLNode);
      end;

      XMLNodes := IdgNode.SelectNodes('//b:ClCompile');
      if XMLNodes.Length > 0 then
        XMLParent := XMLNodes.Item[0]
      else
      begin
        XMLNode := XMLDocument.CreateNode(1, 'ClCompile',
                    'http://schemas.microsoft.com/developer/msbuild/2003');
        XMLParent := IdgNode.AppendChild(XMLNode);
      end;
      XMLNodes := XMLParent.SelectNodes('//b:ClCompile/b:AdditionalIncludeDirectories');
      if XMLNodes.Length > 0 then
        IncludeDirectoriesNode := XMLNodes.Item[0]
      else
      begin
        XMLNode := XMLDocument.CreateNode(1, 'AdditionalIncludeDirectories',
                    'http://schemas.microsoft.com/developer/msbuild/2003');
        IncludeDirectoriesNode := XMLParent.AppendChild(XMLNode);
      end;

      XMLNodes := IdgNode.SelectNodes('//b:Link');
      if XMLNodes.Length > 0 then
        XMLParent := XMLNodes.Item[0]
      else
      begin
        XMLNode := XMLDocument.CreateNode(1, 'Link',
                    'http://schemas.microsoft.com/developer/msbuild/2003');
        XMLParent := IdgNode.AppendChild(XMLNode);
      end;
      XMLNodes := XMLParent.SelectNodes('//b:Link/b:AdditionalLibraryDirectories');
      if XMLNodes.Length > 0 then
        DynamicLibraryDirectoriesNode := XMLNodes.Item[0]
      else
      begin
        XMLNode := XMLDocument.CreateNode(1, 'AdditionalLibraryDirectories',
                    'http://schemas.microsoft.com/developer/msbuild/2003');
        DynamicLibraryDirectoriesNode := XMLParent.AppendChild(XMLNode);
      end;

      XMLNodes := IdgNode.SelectNodes('//b:Lib');
      if XMLNodes.Length > 0 then
        XMLParent := XMLNodes.Item[0]
      else
      begin
        XMLNode := XMLDocument.CreateNode(1, 'Lib',
                    'http://schemas.microsoft.com/developer/msbuild/2003');
        XMLParent := IdgNode.AppendChild(XMLNode);
      end;
      XMLNodes := XMLParent.SelectNodes('//b:Lib/b:AdditionalLibraryDirectories');
      if XMLNodes.Length > 0 then
        StaticLibraryDirectoriesNode := XMLNodes.Item[0]
      else
      begin
        XMLNode := XMLDocument.CreateNode(1, 'AdditionalLibraryDirectories',
                    'http://schemas.microsoft.com/developer/msbuild/2003');
        StaticLibraryDirectoriesNode := XMLParent.AppendChild(XMLNode);
      end;

      AdditionalIncludeDirectories := '';
      if not VarIsNull(IncludeDirectoriesNode) then
        AdditionalIncludeDirectories := IncludeDirectoriesNode.Text;
      AdditionalDynamicLibraryDirectories := '';;
      if not VarIsNull(DynamicLibraryDirectoriesNode) then
        AdditionalDynamicLibraryDirectories := DynamicLibraryDirectoriesNode.Text;
      AdditionalStaticLibraryDirectories := '';;
      if not VarIsNull(StaticLibraryDirectoriesNode) then
        AdditionalStaticLibraryDirectories := StaticLibraryDirectoriesNode.Text;
      UpdateString(AdditionalIncludeDirectories, ExpandConstant('{app}\include;'), '%(AdditionalIncludeDirectories)');
      UpdateString(AdditionalDynamicLibraryDirectories, ExpandConstant('{app}\lib\' + libfolder + ';'), '%(AdditionalLibraryDirectories)');
      UpdateString(AdditionalStaticLibraryDirectories, ExpandConstant('{app}\lib\' + libfolder + ';'), '%(AdditionalLibraryDirectories)');
      IncludeDirectoriesNode.Text := AdditionalIncludeDirectories;
      DynamicLibraryDirectoriesNode.Text := AdditionalDynamicLibraryDirectories;
      StaticLibraryDirectoriesNode.Text := AdditionalStaticLibraryDirectories;
      XMLDocument.save(filename);
    end;
  except
    ShowExceptionMessage;
  end;
end;

procedure ModifyAllProps();
var
  Path: string;
begin
  Path := GetEnv('LOCALAPPDATA')+'\Microsoft\MSBuild\v4.0\';
  if DirExists(Path) then
  begin
    ModifyProps(Path + 'Microsoft.Cpp.Win32.user.props', 'Win32');
    ModifyProps(Path + 'Microsoft.Cpp.x64.user.props', 'Win64');
  end;
end;

procedure CurStepChanged(CurStep: TSetupStep);
begin
  if CurStep = ssInstall then
  begin
    if not UninstallOldVersions() then
      Abort();
    if IsTaskSelected('modifyVS2008Props') then
      ModifyVS2008Settings();
    if IsTaskSelected('modifyVS2010Props') then
      ModifyAllProps();
  end;
  CurStepChangedModPath(CurStep);
end;

procedure CurUninstallStepChanged(CurUninstallStep: TUninstallStep);
begin
  CurUninstallStepChangedModPath(CurUninstallStep);
end;

function NextButtonClick(CurPageID: Integer): Boolean;
begin
  Result := True;
 
  if CurPageID = wpReady then
    SuppressibleMsgBox('Please close Visual Studio before starting the installation.', mbInformation, MB_OK, IDOK);
end;