; Custom NSIS installer for Inkline with GH_TOKEN setup
!include "MUI2.nsh"
!include "x64.nsh"
!include "WinVer.nsh"

; Basic settings
Name "Inkline"
OutFile "$OUTDIR\Inkline.exe"
InstallDir "$PROGRAMFILES\Inkline"

; MUI Settings
!insertmacro MUI_PAGE_WELCOME
!insertmacro MUI_PAGE_DIRECTORY
Page custom SetupGHToken
!insertmacro MUI_PAGE_INSTFILES
!insertmacro MUI_PAGE_FINISH

!insertmacro MUI_LANGUAGE "English"

; Custom page for GitHub Token
Function SetupGHToken
  nsDialogs::Create 1018
  Pop $0
  
  ${NSD_CreateLabel} 0 0 100% 30u "Inkline uses GitHub Releases for auto-updates.$\nEnter your GitHub personal access token (optional).$\nYou can skip this and set it later."
  Pop $1
  
  ${NSD_CreateLabel} 0 40u 100% 10u "GitHub Token:"
  Pop $2
  
  ${NSD_CreateText} 0 50u 100% 12u ""
  Pop $3
  
  ${NSD_CreateLabel} 0 70u 100% 20u "Note: The token will be stored in your system environment variables.$\nMake sure you have 'repo' permissions enabled on your token."
  Pop $4
  
  nsDialogs::Show
  
  Pop $5
  
  ${If} $5 == "success"
    ${NSD_GetText} $3 $GH_TOKEN_VALUE
    
    ${If} $GH_TOKEN_VALUE != ""
      ; Store token in Windows environment variable (HKCU)
      WriteRegExpandStr HKCU "Environment" "GH_TOKEN" "$GH_TOKEN_VALUE"
      
      ; Notify the system of the change
      SendMessage ${HWND_BROADCAST} ${WM_SETTINGCHANGE} 0 "STR:Environment" /TIMEOUT=5000
    ${EndIf}
  ${EndIf}
FunctionEnd

Section "Install"
  SetOutPath "$INSTDIR"
  
  ; Files are handled by electron-builder
  ; This section just ensures the installation path is created
  
  ; Create start menu shortcut
  CreateDirectory "$SMPROGRAMS\Inkline"
  CreateShortCut "$SMPROGRAMS\Inkline\Inkline.lnk" "$INSTDIR\Inkline.exe"
  CreateShortCut "$DESKTOP\Inkline.lnk" "$INSTDIR\Inkline.exe"
SectionEnd

Section "Uninstall"
  ; Remove shortcuts
  Delete "$SMPROGRAMS\Inkline\Inkline.lnk"
  RMDir "$SMPROGRAMS\Inkline"
  Delete "$DESKTOP\Inkline.lnk"
  
  ; Remove GH_TOKEN from environment (optional)
  DeleteRegValue HKCU "Environment" "GH_TOKEN"
  SendMessage ${HWND_BROADCAST} ${WM_SETTINGCHANGE} 0 "STR:Environment" /TIMEOUT=5000
SectionEnd
