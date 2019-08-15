;DoWpro installer script
;Using NSIS Modern User Interface

;--------------------------------
;Include Modern UI

  !include "Sections.nsh"
  !include "MUI2.nsh"

;--------------------------------
;General

  ;Name and file
  Name "DoWpro Ladder Client"
  OutFile "DoWpro Ladder.exe"
  
  !define MUI_ICON ".\Resources\Soulstorm.ico"
  !define MUI_UNICON ".\Resources\Soulstorm.ico"
  !define MUI_HEADERIMAGE
  !define MUI_HEADERIMAGE_RIGHT
  !define MUI_HEADERIMAGE_BITMAP ".\Resources\HeaderImage.bmp"

  ;Default installation folder
  InstallDir "$PROGRAMFILES\Steam\steamapps\common\Dawn of War Soulstorm"
  
  ;Get installation folder from registry if available
  InstallDirRegKey HKLM "SOFTWARE\THQ\Dawn of War - Soulstorm" "installlocation"

  ;Request application privileges for Windows Vista
  RequestExecutionLevel admin
  
;--------------------------------
;Interface Settings

  !define MUI_ABORTWARNING
  
;--------------------------------
;Pages

  !define MUI_WELCOMEFINISHPAGE_BITMAP ".\Resources\WelcomeScreenImage.bmp"
  !define MUI_WELCOMEPAGE_TITLE $(DESC_WelcomePageTitle)
  !define MUI_WELCOMEPAGE_TITLE_3LINES
  !define MUI_WELCOMEPAGE_TEXT $(DESC_WelcomePageText)
  !insertmacro MUI_PAGE_WELCOME
  !insertmacro MUI_PAGE_DIRECTORY
  !insertmacro MUI_PAGE_COMPONENTS
  
  !insertmacro MUI_PAGE_INSTFILES
  
  !insertmacro MUI_UNPAGE_CONFIRM
  !insertmacro MUI_UNPAGE_INSTFILES
  
;--------------------------------
;Languages
 
  !define MUI_LANGDLL_ALLLANGUAGES
  
  !insertmacro MUI_LANGUAGE "English"
  !insertmacro MUI_LANGUAGE "French"
  !insertmacro MUI_LANGUAGE "Russian"

;--------------------------------
;Installer Sections
Section "!$(DESC_SectionMainFilesTitle)" SectionMainFiles ;Always selected
  SectionIn RO
  
  ; show details by default
  SetDetailsView show

  DetailPrint "++ In the darkest of moments, the Emperor’s light shines brightest ++"  
  DetailPrint "++ Build routine Seven Two One initiated ++"

  IfFileExists "$WINDIR\Microsoft.NET\Framework64\v4.0.30319\InstallUtil.exe" 0 installutil_not_found
	DetailPrint "++ InstallUtil found... Proceeding ++"
	
	SetOutPath "$INSTDIR\DoWproLadder"
    
	DetailPrint "++ Cleaning ++"
	
	nsExec::Exec '"$WINDIR\Microsoft.NET\Framework64\v4.0.30319\InstallUtil.exe" /u "$INSTDIR\DoWproLadder\DoWproReplayWatcher.Service.exe"' $0
	Pop $0
	${If} $0 == 0
		DetailPrint "++ Service unregistration complete ++"
	${Else}
		DetailPrint "++ Service unregistration failure; Archmagos 00101101 suggests the service wasn't installed in the first place ++"
	${EndIf}
	
	
	RMDir /r "$INSTDIR\DoWproLadder"
	DetailPrint "++ Copying new files ++"
	File /r ".\..\..\dowpro-replay-watcher-client\DoWproReplayWatcher.Service\bin\Release\*.*"
  
	DetailPrint "++ Creating Uninstaller ++"
	WriteUninstaller "$INSTDIR\UninstallDoWproLadder.exe"

	DetailPrint "++ Registering service ++"
	nsExec::Exec '"$WINDIR\Microsoft.NET\Framework64\v4.0.30319\InstallUtil.exe" "$INSTDIR\DoWproLadder\DoWproReplayWatcher.Service.exe"' $0
	Pop $0
	${If} $0 == 0
		DetailPrint "++ Service registration complete ++"
	${Else}
		DetailPrint "++ Service registration failure ++"
		DetailPrint "++ Please report to the closest techpriest ++"
	${EndIf}
	
goto end_of_test ;<== important for not continuing on the else branch
installutil_not_found:
	DetailPrint "++ Error : InstallUtil not found... Are you sure .Net Framework is installed on this cogitator? ++"
	DetailPrint "++ Please report to the closest techpriest ++"
	MessageBox MB_OK|MB_ICONSTOP "Error : InstallUtil not found... Are you sure .Net Framework is installed on this cogitator? Please report to the closest techpriest."
	Quit
end_of_test:

DetailPrint "++ Revere the Omnissiah, for it is the source of all power ++"
DetailPrint "++ The flesh is weak. The weak shall perish ++"

SectionEnd

;--------------------------------
; Languages files

!ifdef LANG_FRENCH
	!include ".\Languages\lang_fr.nsh"
!endif
!ifdef LANG_ENGLISH
	!include ".\Languages\lang_en.nsh"
!endif
!ifdef LANG_RUSSIAN
	!include ".\Languages\lang_ru.nsh"
!endif

;--------------------------------
;Descriptions

  ;Assign language strings to sections
  !insertmacro MUI_FUNCTION_DESCRIPTION_BEGIN
    !insertmacro MUI_DESCRIPTION_TEXT ${SectionMainFiles} $(DESC_SectionMainFiles)
  !insertmacro MUI_FUNCTION_DESCRIPTION_END
  
;--------------------------------
;Uninstaller Section

Section Uninstall
  ; show details by default
  SetDetailsView show
  
  DetailPrint "++ Thought begets Heresy; Heresy begets Retribution ++"
  DetailPrint "++ Purge routine initiated ++"

  DetailPrint "++ Removing service ... ++"
  nsExec::Exec '"$WINDIR\Microsoft.NET\Framework64\v4.0.30319\InstallUtil.exe" /u "$INSTDIR\DoWproLadder\DoWproReplayWatcher.Service.exe"' $0
  Pop $0
  ${If} $0 == 0
	DetailPrint "++ Service unregistration complete ++"
  ${Else}
	DetailPrint "++ Service unregistration failure; Archmagos 00101101 suggests the service wasn't installed in the first place ++"
  ${EndIf}

  DetailPrint "++ Removing Uninstaller ... ++"
  Delete "$INSTDIR\UninstallDoWproLadder.exe"
  
  DetailPrint "++ Deleting DoWpro ladder client files ... ++"
  RMDir /r "$INSTDIR\DoWproLadder"

  DetailPrint "++ Purge complete ++"
  DetailPrint "++ Hail the Omnissiah ++"
  DetailPrint "++ Hope is the first step on the road to disappointment ++"
SectionEnd