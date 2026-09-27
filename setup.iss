[Setup]
AppName=Social Tsunami
AppVersion=1.0.0
AppPublisher=Jacky Phuti
DefaultDirName={userappdata}\Programs\Social Tsunami
DefaultGroupName=Social Tsunami
DisableProgramGroupPage=yes
PrivilegesRequired=lowest
OutputDir=installer_output
OutputBaseFilename=Social_Tsunami_Setup
Compression=lzma2/ultra64
SolidCompression=yes
WizardStyle=modern
ArchitecturesInstallIn64BitMode=x64

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"

[Tasks]
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}"

[Files]
Source: "dist\SocialTsunami.exe"; DestDir: "{app}"; Flags: ignoreversion
Source: "dist\SocialTsunami.pck"; DestDir: "{app}"; Flags: ignoreversion

[Icons]
Name: "{group}\Social Tsunami"; Filename: "{app}\SocialTsunami.exe"
Name: "{group}\{cm:UninstallProgram,Social Tsunami}"; Filename: "{uninstallexe}"
Name: "{autodesktop}\Social Tsunami"; Filename: "{app}\SocialTsunami.exe"; Tasks: desktopicon

[Run]
Filename: "{app}\SocialTsunami.exe"; Description: "{cm:LaunchProgram,Social Tsunami}"; Flags: nowait postinstall skipifsilent
