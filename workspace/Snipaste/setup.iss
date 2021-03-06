; Script generated by the Inno Setup Script Wizard.
; SEE THE DOCUMENTATION FOR DETAILS ON CREATING INNO SETUP SCRIPT FILES!

#define MyAppName "Snipaste??ͼ????"
#define MyAppVersion "1.0"
#define MyAppPublisher "Canplayer"

[Setup]
; NOTE: The value of AppId uniquely identifies this application. Do not use the same AppId value in installers for other applications.
; (To generate a new GUID, click Tools | Generate GUID inside the IDE.)
AppId={{785B09AB-4B96-466A-A6FB-E7EE7F5A470A}
AppName={#MyAppName}
AppVersion={#MyAppVersion}
;AppVerName={#MyAppName} {#MyAppVersion}
AppPublisher={#MyAppPublisher}
DefaultDirName=C:\Apps\Snipaste
DisableDirPage=yes
DefaultGroupName={#MyAppName}
DisableProgramGroupPage=yes
; Uncomment the following line to run in non administrative install mode (install for current user only.)
;PrivilegesRequired=lowest
OutputDir=C:\Users\Canplayer\Desktop
OutputBaseFilename=mysetup
Compression=lzma
SolidCompression=yes
WizardStyle=modern

[Languages]
Name: "chinesesimplified"; MessagesFile: "compiler:Languages\ChineseSimplified.isl"

[Files]
Source: "D:\OneDrive\workspace\hnszlyyimp\workspace\Snipaste\program\*"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs createallsubdirs
; NOTE: Don't use "Flags: ignoreversion" on any shared system files

[Registry]
Root:HKCR; Subkey: "snipaste"; Flags: "uninsdeletekey"
Root:HKCR; Subkey: "snipaste"; ValueType: string; ValueName: ""; ValueData: "URL:snipaste protocol";
Root:HKCR; Subkey: "snipaste"; ValueType: string; ValueName: "URL Protocol"; ValueData: ""

Root:HKCR; Subkey: "snipaste\DefaultIcon"; Flags: "uninsdeletekey"
Root:HKCR; Subkey: "snipaste\DefaultIcon"; ValueType: string; ValueName: ""; ValueData: "Snipaste.exe"

Root:HKCR; Subkey: "snipaste\Shell"; Flags: "uninsdeletekey"
Root:HKCR; Subkey: "snipaste\Shell"; ValueType: none; ValueName: ""; ValueData: ""

Root:HKCR; Subkey: "snipaste\Shell\Open"; Flags: "uninsdeletekey"
Root:HKCR; Subkey: "snipaste\Shell\Open"; ValueType: none; ValueName: ""; ValueData: ""

Root:HKCR; Subkey: "snipaste\Shell\Open\Command"; Flags: "uninsdeletekey"
Root:HKCR; Subkey: "snipaste\Shell\Open\Command"; ValueType: string; ValueName: ""; ValueData: """C:\Apps\Snipaste\snipasterun.exe"" %1"