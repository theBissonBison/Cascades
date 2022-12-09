;ACTIVE BRANCH
;upgrade to use OnMessage()

;add support to grab timestamped videos after timestamp
;improve firefox grabtabs

#NoEnv
;#Warn ;::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
SendMode Input
#UseHook
SetWorkingDir %A_ScriptDir%
#persistent
#singleinstance force
EnvGet, LocalAppData, LocalAppData
EnvGet, USERPROFILE, USERPROFILE
CoordMode, Tooltip, Screen
MainClickedOn = 1
IniRead, HelperScript, %LocalAppData%\Cascades\ini\2.ini, section1, HelperScript
if HelperScript = 1
{
	MainClickedOn = 0
	HelperScript = 0
	IniWrite, 0, %LocalAppData%\Cascades\ini\2.ini, section1, HelperScript
}

IniRead, Genesis, %LocalAppData%\Cascades\ini\1.ini, Identity, Genesis
if (Genesis != 1)
{
	gosub SettingsDefault
	IniWrite, 1, %LocalAppData%\Cascades\ini\1.ini, Identity, Genesis
}

intro:

IniRead, Downloads, %LocalAppData%\Cascades\ini\1.ini, section1, Downloads
IniRead, Videos, %LocalAppData%\Cascades\ini\1.ini, section1, Videos
IniRead, Music, %LocalAppData%\Cascades\ini\1.ini, section1, Music
IniRead, Desktop, %LocalAppData%\Cascades\ini\1.ini, section1, Desktop
IniRead, Documents, %LocalAppData%\Cascades\ini\1.ini, section1, Documents
IniRead, Custom, %LocalAppData%\Cascades\ini\1.ini, section1, Custom

IniRead, VFolderBind, %LocalAppData%\Cascades\ini\1.ini, section1, VFolderBind
IniRead, MFolderBind, %LocalAppData%\Cascades\ini\1.ini, section1, MFolderBind
IniRead, VideosConfig, %LocalAppData%\Cascades\ini\1.ini, section1, VideosConfig
IniRead, MusicConfig, %LocalAppData%\Cascades\ini\1.ini, section1, MusicConfig
IniRead, endingVm, %LocalAppData%\Cascades\ini\1.ini, section1, endingVm
IniRead, endingVv, %LocalAppData%\Cascades\ini\1.ini, section1, endingVv
IniRead, endingVmBind, %LocalAppData%\Cascades\ini\1.ini, section1, endingVmBind
IniRead, endingVvBind, %LocalAppData%\Cascades\ini\1.ini, section1, endingVvBind

IniRead, MusicFormatA, %LocalAppData%\Cascades\ini\1.ini, section1, MusicFormatA ;mp3
IniRead, endingV, %LocalAppData%\Cascades\ini\1.ini, section1, endingV ;1
IniRead, ShowListGUI, %LocalAppData%\Cascades\ini\1.ini, section1, ShowListGUI
IniRead, ShowListPop, %LocalAppData%\Cascades\ini\1.ini, section1, ShowListPop
IniRead, GrabCompletePop, %LocalAppData%\Cascades\ini\1.ini, section1, GrabCompletePop
IniRead, Genwrit, %LocalAppData%\Cascades\ini\1.ini, section1, Genwrit


IniRead, hotkeyD, %LocalAppData%\Cascades\ini\1.ini, section1, hotkeyD ;!d
IniRead, hotkeyV, %LocalAppData%\Cascades\ini\1.ini, section1, hotkeyV ;!v
IniRead, hotkeyM, %LocalAppData%\Cascades\ini\1.ini, section1, hotkeyM ;!m
IniRead, hotkeyG, %LocalAppData%\Cascades\ini\1.ini, section1, hotkeyG ;!g
IniRead, hotkeyL, %LocalAppData%\Cascades\ini\1.ini, section1, hotkeyL ;!l
IniRead, hotkeyA, %LocalAppData%\Cascades\ini\1.ini, section1, hotkeyA ;!a

IniRead, hotkeyGon, %LocalAppData%\Cascades\ini\1.ini, section1, hotkeyGon
IniRead, hotkeyLon, %LocalAppData%\Cascades\ini\1.ini, section1, hotkeyLon
IniRead, hotkeyAon, %LocalAppData%\Cascades\ini\1.ini, section1, hotkeyAon

IniRead, RadioGroupChecked1, %LocalAppData%\Cascades\ini\1.ini, section1, RadioGroupChecked1
IniRead, RadioGroupChecked2, %LocalAppData%\Cascades\ini\1.ini, section1, RadioGroupChecked2
IniRead, FolderChoiceDrop, %LocalAppData%\Cascades\ini\1.ini, section1, FolderChoiceDrop

CtrlArray := ["", "^"]
ShiftArray := ["", "+"]
WindowsArray := ["", "#"]
AltArray := ["", "!"]
MusicFormatArray := ["flac","m4a","mp3","ogg","wav"]
FolderArray := [Downloads, Videos, Music, Desktop, Documents, Custom]
BlankArray := []

if VFolderBind = 1
{
	VideosConfig := Videos
}
if VFolderBind = 1
{
	MusicConfig := Music
}

if endingVvBind = 1
{
	endingVv := endingV
}
if endingVmBind = 1
{
	endingVm := endingV
}

VideoFormat = mp4
MusicFormat := MusicFormatArray[MusicFormatA]
ModernBrowsers := "ApplicationFrameWindow,Chrome_WidgetWin_0,Chrome_WidgetWin_1,Maxthon3Cls_MainFrm,MozillaWindowClass,Slimjet_WidgetWin_1"
LegacyBrowsers := "IEFrame,OperaWindowClass"


Run, %comspec% /c ""%LocalAppData%\Cascades\yt-dlp.exe" "-U"", , Hide

Hotkey, %hotkeyD%, MainLine, off
Hotkey, %hotkeyV%, VideoLine, off
Hotkey, %hotkeyM%, MusicLine, off
Hotkey, %hotkeyG%, IconLine, off
Hotkey, %hotkeyL%, LLine, off
Hotkey, %hotkeyA%, ALine, off

Hotkey, %hotkeyD%, MainLine, on
Hotkey, %hotkeyV%, VideoLine, on
Hotkey, %hotkeyM%, MusicLine, on
if hotkeyGon = 1
{	
	Hotkey, %hotkeyG%, IconLine, on
}
if hotkeyLon = 1
{	
	Hotkey, %hotkeyL%, LLine, on
}
if hotkeyAon = 1
{	
	Hotkey, %hotkeyA%, ALine, on
}
HotkeysOn = 1

if MainClickedOn = 1
{
	MainClickedOn = 0
	goto IconLine
}
return


VideoLine:
Line = 1
goto Search

MusicLine:
Line = 2
goto Search

ALine:
Line = 4
OGClip = %Clipboard%
URLinClip = 0
URLFound = 0
VideoURL := ""
PlaylistTrue = 0
SetTitleMatchMode, RegEx
if WinActive("Google Chrome") OR WinActive("Microsoft Edge") OR WinActive("Mozilla Firefox")
{
	VideoURL := GetActiveBrowserURL()
	URLFound = 1
}
if URLFound = 0
{
	if RegExMatch(OGClip, "(\.com|\.net|\.org|http)")
	{
		VideoURL = %OGClip%
		URLFound = 1
		URLinClip = 1
	}
}

if URLFound = 0
{
	if WinExist("Google Chrome") OR WinExist("Microsoft Edge") OR WinExist("Mozilla Firefox")
	{
		WinActivate
		VideoURL := GetActiveBrowserURL()
		URLFound = 1
	}
}
if URLFound = 0
{
	ToolTip, No video URL found., 760, 365
	SetTimer, RemoveToolTip, -3000
	goto IconLine
}
SetTitleMatchMode, 1
Clipboard := ""
Gui, Destroy
if URLinClip = 0
{
	Clipboard = %OGClip%
} else {
	Clipboard := ""
}
NonYoutubeSite = 1
PlaylistTrue = 0
goto ALineInterrupt

LLine:
Line = 5
ListActiveHwnd := WinExist("A")
if !WinExist("ahk_id" GUIHwnd)
{
	gosub IconLine
}
Line = 5
if !WinExist("ahk_id" hwndlistbutton)
{
	gosub ListButton1
}
Line = 5
goto GrabTabs

IconLine:
Line = 3
goto GUI

settingsbutton:
if WinExist("ahk_id" hwndsettingsbutton)
{
	Gui, %hwndsettingsbutton%:Destroy		
}
Gui, New
Gui, +hwndhwndsettingsbutton

aaaArray := ["d", "v", "m"]
hotkeyArray := [hotkeyD, hotkeyV, hotkeyM]
Loop, 3
{
	aaa := aaaArray[A_Index]
	hkvar := hotkeyArray[A_Index]
	ctrl%aaa% := 0
	shift%aaa% := 0
	windows%aaa% := 0
	alt%aaa% := 0
	key%aaa% := 0
	
	if RegExMatch(hkvar, "\^")
	{
		ctrl%aaa% := 1
	}
	if RegExMatch(hkvar, "\+")
	{
		shift%aaa% := 1
	}
	if RegExMatch(hkvar, "#")
	{
		windows%aaa% := 1
	}
	if RegExMatch(hkvar, "!")
	{
		alt%aaa% := 1
	}
	key%aaa% := RegExReplace(hkvar, "(\+|\^|#|!)", Replacement := "")
}

Gui, Font, s10, Segoe UI
Gui, Add, Text, x10 y10,Downloads folder:
Gui, add, Edit, x10 y30 w400 vFSFdown
GuiControl,, FSFdown, %Downloads%
Gui, Add, Button, x415 y29 w30 gFSFdown, . . .

Gui, Add, Text, x10 y70,Videos folder:
Gui, add, Edit, x10 y90 w400 vFSFvid
GuiControl,, FSFvid, %Videos%
Gui, Add, Button, x415 y89 w30 gFSFvid, . . .

Gui, Add, Text, x10 y130,Music folder:
Gui, add, Edit, x10 y150 w400 vFSFmus
GuiControl,, FSFmus, %Music%
Gui, Add, Button, x415 y149 w30 gFSFmus, . . .

Gui, Add, Text, x10 y190,Desktop folder:
Gui, add, Edit, x10 y210 w400 vFSFdesk
GuiControl,, FSFdesk, %Desktop%
Gui, Add, Button, x415 y209 w30 gFSFdesk, . . .

Gui, Add, Text, x10 y250,Documents folder:
Gui, add, Edit, x10 y270 w400 vFSFdoc
GuiControl,, FSFdoc, %Documents%
Gui, Add, Button, x415 y269 w30 gFSFdoc, . . .

Gui, Add, Text, x490 y12,Interactive [D]ownload hotkey (default: Alt+D):
Gui, Add, CheckBox, x490 y37 vctrld checked%ctrld%, Ctrl
Gui, Add, CheckBox, x490 y62 vshiftd checked%shiftd%, Shift
Gui, Add, CheckBox, x580 y37 vwindowsd checked%windowsd%, Windows
Gui, Add, CheckBox, x580 y62 valtd checked%altd%, Alt
Gui, Add, Hotkey, x490 y92 vkeyd Limit190, %keyd%

Gui, Add, Text, x490 y142,Quick [V]ideo download hotkey (default: Alt+V):
Gui, Add, CheckBox, x490 y167 vctrlv checked%ctrlv%, Ctrl
Gui, Add, CheckBox, x490 y192 vshiftv checked%shiftv%, Shift
Gui, Add, CheckBox, x580 y167 vwindowsv checked%windowsv%, Windows
Gui, Add, CheckBox, x580 y192 valtv checked%altv%, Alt
Gui, Add, Hotkey, x490 y222 vkeyv Limit190, %keyv%

Gui, Add, Text, x490 y272,Quick [M]usic download hotkey (default: Alt+M):
Gui, Add, CheckBox, x490 y297 vctrlm checked%ctrlm%, Ctrl
Gui, Add, CheckBox, x490 y322 vshiftm checked%shiftm%, Shift
Gui, Add, CheckBox, x580 y297 vwindowsm checked%windowsm%, Windows
Gui, Add, CheckBox, x580 y322 valtm checked%altm%, Alt
Gui, Add, Hotkey, x490 y352 vkeym Limit190, %keym%


Gui, Add, Text, x15 y320, Action on download completion:
Gui, Add, DropDownList, choose%endingV% vendingV AltSubmit, Standard Notification|Do nothing|Pop-up|Open containing folder

Gui, Add, Text, x15 y380, Audio Format:
Gui, Add, DropDownList, choose%MusicFormatA% vMusicFormatA AltSubmit, flac|m4a|mp3|ogg|wav

Gui, Add, Button, x250 y390 gSettingsAdvanced, Advanced settings and `nbonus hotkeys menu
Gui, Add, Button, x480 y410 gSettingsCancel, Cancel
Gui, Add, Button, x545 y410 gSettingsDefault, Revert to Defaults
Gui, Add, Button, x675 y410 gSettingsApply, Apply changes

Gui, Show, w800 h450, Cascades Settings
return







SettingsApply:
Gui, Submit
Gui, Destroy

Hotkey, %hotkeyD%, MainLine, off
Hotkey, %hotkeyV%, VideoLine, off
Hotkey, %hotkeyM%, MusicLine, off

ctrld := ctrlArray[ctrld + 1]
shiftd := shiftArray[shiftd + 1]
windowsd := windowsArray[windowsd + 1]
altd := altArray[altd + 1]
hk1 = %ctrld%%shiftd%%windowsd%%altd%%keyd%
if (hk1 != hotkeyD)
{
	hotkeyD = %hk1%
	IniWrite, %hotkeyD%, %LocalAppData%\Cascades\ini\1.ini, section1, hotkeyD
}

ctrlv := CtrlArray[ctrlv + 1]
shiftv := ShiftArray[shiftv + 1]
windowsv := WindowsArray[windowsv + 1]
altv := AltArray[altv + 1]
hk2 = %ctrlv%%shiftv%%windowsv%%altv%%keyv%
if (hk2 != hotkeyV)
{
	hotkeyV = %hk2%
	IniWrite, %hotkeyV%, %LocalAppData%\Cascades\ini\1.ini, section1, hotkeyV
}

ctrlm := CtrlArray[ctrlm + 1]
shiftm := ShiftArray[shiftm + 1]
windowsm := WindowsArray[windowsm + 1]
altm := AltArray[altm + 1]
hk3 = %ctrlm%%shiftm%%windowsm%%altm%%keym%
if (hk3 != hotkeyM)
{
	hotkeyM = %hk3%
	IniWrite, %hotkeyM%, %LocalAppData%\Cascades\ini\1.ini, section1, hotkeyM
}  

Downloads = %FSFdown%
Videos = %FSFvid%
Music = %FSFmus%
Desktop = %FSFdesk%
Documents = %FSFdoc%
IniWrite, %Downloads%, %LocalAppData%\Cascades\ini\1.ini, section1, Downloads
IniWrite, %Videos%, %LocalAppData%\Cascades\ini\1.ini, section1, Videos
IniWrite, %Music%, %LocalAppData%\Cascades\ini\1.ini, section1, Music
IniWrite, %Desktop%, %LocalAppData%\Cascades\ini\1.ini, section1, Desktop
IniWrite, %Documents%, %LocalAppData%\Cascades\ini\1.ini, section1, Documents
IniWrite, %EndingV%, %LocalAppData%\Cascades\ini\1.ini, section1, endingV
IniWrite, %MusicFormatA%, %LocalAppData%\Cascades\ini\1.ini, section1, MusicFormatA
gosub intro
WinActivate, ahk_id %GUIHwnd%
return

SettingsCancel:
Gui, cancel
Gui, Destroy
WinActivate, ahk_id %GUIHwnd%
return

SettingsDefault:
if (Genesis = 1)
{
	Gui, cancel
	Gui, Destroy
}

if (HotkeysOn = 1)
{	
	Hotkey, %hotkeyD%, MainLine, off
	Hotkey, %hotkeyV%, VideoLine, off
	Hotkey, %hotkeyM%, MusicLine, off
	Hotkey, %hotkeyG%, IconLine, off
	Hotkey, %hotkeyA%, ALine, off
	Hotkey, %hotkeyL%, LLine, off
}

IniWrite, %USERPROFILE%\Downloads, %LocalAppData%\Cascades\ini\1.ini, section1, Downloads
IniWrite, %USERPROFILE%\Videos, %LocalAppData%\Cascades\ini\1.ini, section1, Videos
IniWrite, %USERPROFILE%\Music, %LocalAppData%\Cascades\ini\1.ini, section1, Music
IniWrite, %USERPROFILE%\Desktop, %LocalAppData%\Cascades\ini\1.ini, section1, Desktop
IniWrite, %USERPROFILE%\Documents, %LocalAppData%\Cascades\ini\1.ini, section1, Documents
IniWrite, %USERPROFILE%\Downloads, %LocalAppData%\Cascades\ini\1.ini, section1, Custom

IniWrite, 3, %LocalAppData%\Cascades\ini\1.ini, section1, MusicFormatA
IniWrite, 1, %LocalAppData%\Cascades\ini\1.ini, section1, endingV
IniWrite, 0, %LocalAppData%\Cascades\ini\1.ini, section1, ShowListGUI
IniWrite, 0, %LocalAppData%\Cascades\ini\1.ini, section1, ShowListPop
IniWrite, 0, %LocalAppData%\Cascades\ini\1.ini, section1, GrabCompletePop
IniWrite, 0, %LocalAppData%\Cascades\ini\1.ini, section1, Genwrit

IniWrite, 0, %LocalAppData%\Cascades\ini\2.ini, section1, HelperScript

IniWrite, !d, %LocalAppData%\Cascades\ini\1.ini, section1, hotkeyD
IniWrite, !v, %LocalAppData%\Cascades\ini\1.ini, section1, hotkeyV
IniWrite, !m, %LocalAppData%\Cascades\ini\1.ini, section1, hotkeyM
IniWrite, !g, %LocalAppData%\Cascades\ini\1.ini, section1, hotkeyG
IniWrite, !a, %LocalAppData%\Cascades\ini\1.ini, section1, hotkeyA
IniWrite, !l, %LocalAppData%\Cascades\ini\1.ini, section1, hotkeyL

IniWrite, 1, %LocalAppData%\Cascades\ini\1.ini, section1, hotkeyGon
IniWrite, 1, %LocalAppData%\Cascades\ini\1.ini, section1, hotkeyLon
IniWrite, 1, %LocalAppData%\Cascades\ini\1.ini, section1, hotkeyAon

;IniWrite, 1, %LocalAppData%\Cascades\ini\1.ini, section1, RadioGroup
IniWrite, 1, %LocalAppData%\Cascades\ini\1.ini, section1, RadioGroupChecked1
IniWrite, 0, %LocalAppData%\Cascades\ini\1.ini, section1, RadioGroupChecked2
IniWrite, 1, %LocalAppData%\Cascades\ini\1.ini, section1, FolderChoiceDrop

IniWrite, %USERPROFILE%\Videos, %LocalAppData%\Cascades\ini\1.ini, section1, VideosConfig
IniWrite, %USERPROFILE%\Music, %LocalAppData%\Cascades\ini\1.ini, section1, MusicConfig
IniWrite, 1, %LocalAppData%\Cascades\ini\1.ini, section1, VFolderBind
IniWrite, 1, %LocalAppData%\Cascades\ini\1.ini, section1, MFolderBind

IniWrite, 1, %LocalAppData%\Cascades\ini\1.ini, section1, endingVm
IniWrite, 1, %LocalAppData%\Cascades\ini\1.ini, section1, endingVv
IniWrite, 1, %LocalAppData%\Cascades\ini\1.ini, section1, endingVmBind
IniWrite, 1, %LocalAppData%\Cascades\ini\1.ini, section1, endingVvBind

if (Genesis != 1)
{
	IniWrite, 0, %LocalAppData%\Cascades\ini\2.ini, section1, HelperScript
	return
} else {
	IniWrite, 1, %LocalAppData%\Cascades\ini\1.ini, section1, HelperScript
}
gosub intro
goto settingsbutton

SettingsAdvanced:
aaaArray := ["g", "l", "a"]
hotkeyArray := [hotkeyG, hotkeyL, hotkeyA]
Loop, 3
{
	aaa := aaaArray[A_Index]
	hkvar := hotkeyArray[A_Index]
	ctrl%aaa% := 0
	shift%aaa% := 0
	windows%aaa% := 0
	alt%aaa% := 0
	key%aaa% := 0
	
	if RegExMatch(hkvar, "\^")
	{
		ctrl%aaa% := 1
	}
	if RegExMatch(hkvar, "\+")
	{
		shift%aaa% := 1
	}
	if RegExMatch(hkvar, "#")
	{
		windows%aaa% := 1
	}
	if RegExMatch(hkvar, "!")
	{
		alt%aaa% := 1
	}
	key%aaa% := RegExReplace(hkvar, "(\+|\^|#|!)", Replacement := "")
}

if WinExist("ahk_id" hwndSettingsAdvanced)
{
	Gui, %hwndSettingsAdvanced%:Destroy	
}
Gui, New
Gui, +hwndhwndSettingsAdvanced
Gui, Font, s10, Segoe UI

Gui, Add, Text, x490 y10,Directly open main menu [G]UI (default: Alt+G):
Gui, Add, CheckBox, x490 y35 vhotkeyGon checked%hotkeyGon%, Hotkey on/off
Gui, Add, CheckBox, x490 y60 vctrlg checked%ctrlg%, Ctrl
Gui, Add, CheckBox, x490 y85 vshiftg checked%shiftg%, Shift
Gui, Add, CheckBox, x580 y60 vwindowsg checked%windowsg%, Windows
Gui, Add, CheckBox, x580 y85 valtg checked%altg%, Alt
Gui, Add, Hotkey, x490 y115 vkeyg Limit190, %keyg%

Gui, Add, Text, x490 y165,Grab [L]inks from open browser (default: Alt+L):
Gui, Add, CheckBox, x490 y190 vhotkeyLon checked%hotkeyLon%, Hotkey on/off
Gui, Add, CheckBox, x490 y215 vctrll checked%ctrll%, Ctrl
Gui, Add, CheckBox, x490 y240 vshiftl checked%shiftl%, Shift
Gui, Add, CheckBox, x580 y215 vwindowsl checked%windowsl%, Windows
Gui, Add, CheckBox, x580 y240 valtl checked%altl%, Alt
Gui, Add, Hotkey, x490 y270 vkeyl Limit190, %keyl%

Gui, Add, Text, x490 y320,Download [A]ny link, regardless of website`n- grabs active tab URL blindly (default: Alt+A):
Gui, Add, CheckBox, x490 y365 vhotkeyAon checked%hotkeyAon%, Hotkey on/off
Gui, Add, CheckBox, x490 y390 vctrla checked%ctrla%, Ctrl
Gui, Add, CheckBox, x490 y415 vshifta checked%shifta%, Shift
Gui, Add, CheckBox, x580 y390 vwindowsa checked%windowsa%, Windows
Gui, Add, CheckBox, x580 y415 valta checked%alta%, Alt
Gui, Add, Hotkey, x490 y445 vkeya Limit190, %keya%

Gui, Add, Button, x590 y495 gSettingsCancelAdvanced, Cancel
Gui, Add, Button, x650 y495 gSettingsApplyAdvanced, Apply changes

Gui, Add, Text, x10 y10,Video-hotkey download destination folder:
Gui, add, Edit, x10 y30 w400 vVideosConfig gVedited
GuiControl,, VideosConfig, %VideosConfig%
Gui, Add, Button, x415 y29 w30 gVideosConfig, . . .

Gui, Add, Text, x10 y80,Music-hotkey download destination folder:
Gui, add, Edit, x10 y100 w400 vMusicConfig
GuiControl,, MusicConfig, %MusicConfig%
Gui, Add, Button, x415 y99 w30 gMusicConfig, . . .

Gui, Add, Text, x15 y140, Action on video-hotkey download completion:
Gui, Add, DropDownList, choose%endingVv% vendingVv gendingVv AltSubmit, Standard Notification|Do nothing|Pop-up|Open containing folder

Gui, Add, Text, x15 y220, Action on music-hotkey download completion:
Gui, Add, DropDownList, choose%endingVm% vendingVm gendingVm AltSubmit, Standard Notification|Do nothing|Pop-up|Open containing folder

Gui, Show,, Advanced Options
return


VideosConfig:
FileSelectFolder, VideosConfig1,,3,Choose folder:
if (VideosConfig1 = "")
{
	msgbox, Folder selection failed.
	VideosConfig1 := VideosConfig
}
GuiControl,, VideosConfig, %VideosConfig1%
WinActivate, ahk_id %hwndSettingsAdvanced%
goto Vedited

MusicConfig:
FileSelectFolder, MusicConfig1,,3,Choose folder:
if (MusicConfig1 = "")
{
	msgbox, Folder selection failed.
	MusicConfig1 := MusicConfig
}
GuiControl,, MusicConfig, %MusicConfig1%
WinActivate, ahk_id %hwndSettingsAdvanced%
goto Vedited

Vedited:
VFolderBind1 = 0
return
Medited:
MFolderBind1 = 0
return
endingVm:
endingVmBind1 = 0
return
endingVv:
endingVvBind1 = 0
return

SettingsCancelAdvanced:
Gui, cancel
Gui, Destroy
WinActivate, ahk_id %hwndsettingsbutton%
return

SettingsApplyAdvanced:
Gui, Submit
Gui, Destroy

Hotkey, %hotkeyG%, IconLine, off
Hotkey, %hotkeyA%, ALine, off
Hotkey, %hotkeyL%, LLine, off

ctrlg := ctrlArray[ctrlg + 1]
shiftg := shiftArray[shiftg + 1]
windowsg := windowsArray[windowsg + 1]
altg := altArray[altg + 1]
hk1 = %ctrlg%%shiftg%%windowsg%%altg%%keyg%
if (hk1 != hotkeyG)
{
	hotkeyG = %hk1%
	IniWrite, %hotkeyG%, %LocalAppData%\Cascades\ini\1.ini, section1, hotkeyG
}
ctrll := CtrlArray[ctrll + 1]
shiftl := ShiftArray[shiftl + 1]
windowsl := WindowsArray[windowsl + 1]
altl := AltArray[altl + 1]
hk2 = %ctrll%%shiftl%%windowsl%%altl%%keyl%
if (hk2 != hotkeyL)
{
	hotkeyL = %hk2%
	IniWrite, %hotkeyL%, %LocalAppData%\Cascades\ini\1.ini, section1, hotkeyL
}
ctrla := CtrlArray[ctrla + 1]
shifta := ShiftArray[shifta + 1]
windowsa := WindowsArray[windowsa + 1]
alta := AltArray[alta + 1]
hk3 = %ctrla%%shifta%%windowsa%%alta%%keya%
if (hk3 != hotkeyA)
{
	hotkeyA = %hk3%
	IniWrite, %hotkeyA%, %LocalAppData%\Cascades\ini\1.ini, section1, hotkeyA
}

IniWrite, %hotkeyGon%, %LocalAppData%\Cascades\ini\1.ini, section1, hotkeyGon
IniWrite, %hotkeyLon%, %LocalAppData%\Cascades\ini\1.ini, section1, hotkeyLon
IniWrite, %hotkeyAon%, %LocalAppData%\Cascades\ini\1.ini, section1, hotkeyAon

if VFolderBind1 = 0
{
	VFolderBind := VFolderBind1
	IniWrite, %VFolderBind%, %LocalAppData%\Cascades\ini\1.ini, section1, VFolderBind	
}
if VFolderBind1 = 0
{
	MFolderBind := MFolderBind1
	IniWrite, %MFolderBind%, %LocalAppData%\Cascades\ini\1.ini, section1, MFolderBind
}

if endingVvBind1 = 0
{
	endingVvBind := endingVvBind1
	IniWrite, %endingVvBind%, %LocalAppData%\Cascades\ini\1.ini, section1, endingVvBind
}
if endingVmBind1 = 0
{
	endingVmBind := endingVmBind1
	IniWrite, %endingVmBind%, %LocalAppData%\Cascades\ini\1.ini, section1, endingVmBind
}
IniWrite, %VideosConfig%, %LocalAppData%\Cascades\ini\1.ini, section1, VideosConfig
IniWrite, %MusicConfig%, %LocalAppData%\Cascades\ini\1.ini, section1, MusicConfig
IniWrite, %endingVm%, %LocalAppData%\Cascades\ini\1.ini, section1, endingVm
IniWrite, %endingVv%, %LocalAppData%\Cascades\ini\1.ini, section1, endingVv

gosub intro
WinActivate, ahk_id %hwndsettingsbutton%
return

FSFdown:
FileSelectFolder, FSFdown,,3,Choose downloads folder:
if (FSFdown = "")
{
	msgbox, Folder selection failed.
	FSFdown := Downloads
}
GuiControl,, FSFdown, %FSFdown%
WinActivate, ahk_id %hwndsettingsbutton%
return

FSFvid:
FileSelectFolder, FSFvid,,3,Choose videos folder:
if (FSFvid = "")
{
	msgbox, Folder selection failed.
	FSFvid := Videos
}
GuiControl,, FSFvid, %FSFvid%
WinActivate, ahk_id %hwndsettingsbutton%
return

FSFmus:
FileSelectFolder, FSFmus,,3,Choose music folder:
if (FSFmus = "")
{
	msgbox, Folder selection failed.
	FSFmus := Music
}
GuiControl,, FSFmus, %FSFmus%
WinActivate, ahk_id %hwndsettingsbutton%
return

FSFdesk:
FileSelectFolder, FSFdesk,,3,Choose desktop folder:
if (FSFdesk = "")
{
	msgbox, Folder selection failed.
	FSFdesk := Desktop
}
GuiControl,, FSFdesk, %FSFdesk%
WinActivate, ahk_id %hwndsettingsbutton%
return

FSFdoc:
FileSelectFolder, FSFdoc,,3,Choose documents folder:
if (FSFdoc = "")
{
	msgbox, Folder selection failed.
	FSFdoc := Documents
}
GuiControl,, FSFdoc, %FSFdoc%
WinActivate, ahk_id %hwndsettingsbutton%
return



MainLine:
Line = 0

Search:
OGClip = %Clipboard%
URLinClip = 0
URLFound = 0
VideoURL := ""
PlaylistTrue = 0
SetTitleMatchMode, RegEx
if WinActive("YouTube.*Google Chrome") OR WinActive("YouTube.*Microsoft Edge") OR WinActive("YouTube.*Mozilla Firefox")
{
	BrowserURL := GetActiveBrowserURL()
	if RegExMatch(BrowserURL, "youtube\.com")
	{
		VideoURL = %BrowserURL%
		URLFound = 1
	}
	
}
if URLFound = 0
{
	if RegExMatch(OGClip, "youtube\.com")
	{
		VideoURL = %OGClip%
		URLFound = 1
		URLinClip = 1
	}
}

if URLFound = 0
{
	if WinExist("YouTube.*Google Chrome") OR WinExist("YouTube.*Microsoft Edge") OR WinExist("YouTube.*Mozilla Firefox")
	{
		WinActivate
		BrowserURL := GetActiveBrowserURL()
		if RegExMatch(BrowserURL, "youtube\.com")
		{
			VideoURL = %BrowserURL%
			URLFound = 1
		}
	}
}
if URLFound = 0
{
	ToolTip, No video URL found., 760, 365
	SetTimer, RemoveToolTip, -3000
	goto IconLine
}
if RegExMatch(VideoURL, "[&\?]list=(?!WL)")
{
	PlaylistTrue = 1
}
SetTitleMatchMode, 1
Clipboard := ""
VideoTitle := ""
if PlaylistTrue = 0
{
	if Line = 0
	{
		ToolTip, Getting video title, 150, 150
	} else {
		ToolTip, Initiating download, 150, 150
	}
	RunWait, %comspec% /c ""%LocalAppData%\Cascades\yt-dlp.exe" "-e" "%VideoURL%" | clip", , Hide
	ToolTip
	VideoTitle = %clipboard%
	VideoTitle := RegExReplace(VideoTitle, "[<>\|\\/]", Replacement := "-")
	VideoTitle := RegExReplace(VideoTitle, "Æ", Replacement := "'")
	StringReplace, VideoTitle, VideoTitle,`n,%A_Space%,All
	StringReplace, VideoTitle, VideoTitle,`r,%A_Space%,All
	StringReplace, VideoTitle, VideoTitle,`r`n,%A_Space%,All
	VideoTitle := RegExReplace(VideoTitle, "[\s]+$", Replacement := "")
}
if URLinClip = 0
{
	Clipboard = %OGClip%
} else {
	Clipboard := ""
}
if Line = 1
{
	goto VideoDownloadTree
}
if Line = 2
{
	goto MusicDownloadTree
}

GUI:
NonYoutubeSite = 0
ALineInterrupt:
URLlisttag = 0
URLEditList := BlankArray

if Line = 3
{
	PlaylistTrue = 0
	VideoTitle := ""
	VideoURL := ""
}

if WinExist("ahk_id" GUIHwnd)
{
	Gui, %GUIHwnd%:Destroy
}
Gui, New
Gui, +hwndGUIHwnd
Gui, Font, s11, Segoe UI

Gui, Add, Text, x30 y10, Format:
Gui, Add, Radio, gsub1 Checked%RadioGroupChecked1% vRadioGroup, Video
Gui, Add, Radio,  gsub2 Checked%RadioGroupChecked2%, Audio

Gui, Add, Text, x130 y10, Folder:
Gui, Add, DropDownList, choose%FolderChoiceDrop% vFolderChoiceDrop gFolderSelection AltSubmit Hwndfolderdrop, Downloads|Videos|Music|Desktop|Documents|Custom

Gui, Add, CheckBox, Checked%NonYoutubeSite% hwndNonYoutubeSitebox vNonYoutubeSite gNonYoutubeSiteGUI, URL is for a non-Youtube site

Gui, Add, Button, gsettingsbutton x360 y15 w75 h25, Settings

if PlaylistTrue = 1
{
	Gui, Add, Text, x25 y100 HwndFilename,Playlist folder name:
	Gui, add, Edit, w400 vVideoTitle hwndVideoTitlehwnd
} else {
	if Line = 0
	{
		Gui, Add, Text, x25 y100 HwndFilename,File name:
		Gui, add, Edit, w400 vVideoTitle hwndVideoTitlehwnd
		GuiControl,, VideoTitle, %videotitle%
		
	} else {
		Gui, Add, Text, x25 y100 HwndFilename,File/playlist name:
		Gui, add, Edit, w400 vVideoTitle hwndVideoTitlehwnd
	}
}


if Line = 0
{
	if PlaylistTrue = 0
	{
		Gui, Add, Text, ,Video URL:
	} else {
		Gui, Add, Text, ,Playlist URL:
	}
} else {
	Gui, Add, Text, ,Video/playlist URL:
}
Gui, Add, Edit, w370 Hwndvideourlbox vVideoURL
Gui, Add, Button, gfolderselectbutton x300 y37.5 w40 h30, . . .
Gui, Add, Button, glistbutton x400 y191.5 w45 h30, List

if (Line = 0 OR Line = 4)
{
	GuiControl,, VideoURL, %VideoURL%
}

if NonYoutubeSite = 1
{
	GuiControl,, VideoTitle, Original video title will be used.	
}

Gui, Add, Button, gcancelbutton x230 y240 w100 h25, Cancel
Gui, Add, Button, gdownloadbutton Default x335 y240 w100 h25, Download

if PlaylistTrue = 1
{
	Gui, Show, w450 h280, Cascades: Playlist -- Download Options
} else {
	if (Line = 3 OR Line = 4)
	{
		Gui, Show, w450 h280, Cascades: Download Options
	} else {
		Gui, Show, w450 h280, Cascades: %videotitle% -- Download Options
	}
}

if Genwrit = 0
{
	if WinExist("ahk_id" hwndGenwritPopup)
	{
		Gui, %hwndGenwritPopup%:Destroy
	}
	Gui, New
	Gui, +hwndhwndgenwritPopup
	Gui, Font, s10, Segoe UI
	Gui, Add, Text, x10 y10 w300, Placeholder`n
	Gui, Add, Checkbox, vGenwritPop gGenwritPop, Don't show again
	Gui, Add, Button, gGenwritPopButton, OK
	Gui, Show
	return
	
	GenwritPopButton:
	Gui, Submit
	Gui, Destroy
	return
	
	GenwritPop:
	IniWrite, 1, %LocalAppData%\Cascades\ini\1.ini, section1, Genwrit	
	return
}

return

sub1:
GuiControl, Choose, %FolderDrop%, 2
return

sub2:
GuiControl, Choose, %FolderDrop%, 3
return

FolderSelection:
GuiControlGet, FolderChoiceSpy,, %folderdrop%
if FolderChoiceSpy = 6
{
	goto folderselectbutton1
}
return

NonYoutubeSiteGUI:
GuiControlGet, NonYoutubeSiteSpy,, %NonYoutubeSitebox%
if NonYoutubeSiteSpy = 1
{
	GuiControl,, VideoTitle, Original video title will be used.	
} else {
	GuiControl,, VideoTitle,
}
return

folderselectbutton1:
MsgBox,4,Testing,Change custom folder path?
IfMsgBox Yes
	goto folderselectbutton
else
	return

folderselectbutton:
FileSelectFolder, Customtemp,,3,Select folder for download:
if (Customtemp = "")
{
	msgbox, Folder selection failed.
	GuiControl,Choose, %FolderDrop%, 1
} else {
	Custom = %Customtemp%
	GuiControl,Choose, %FolderDrop%, 6
	IniWrite, %Custom%, %LocalAppData%\Cascades\ini\1.ini, section1, Custom
}
return

;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

listbutton:
Line = 0

listbutton1:
URLArray := BlankArray
;URLArray.Delete(URLArray.MinIndex(), URLArray.MaxIndex())

if WinExist("ahk_id" hwndlistbutton)
{
	Gui, %hwndlistbutton%:Destroy
}
;^+q::
Gui, New
Gui, +hwndhwndlistbutton
Gui, Font, s11, Segoe UI
Gui, Add, Text,, Enter a list of video URLs to download. This list can be`nseparated by linebreaks (enter), commas, or semi-colons.
Gui, Font, s11, Consolas
Gui, Add, Edit, w450 h500 vURLEditList hwndURLEditListID
GuiControl,, URLEditList, %URLEditList%

Gui, Font, s10, Segoe UI
Gui, Add, Button, ggrabtabs x10 y563, Grab URL list from browser tabs
Gui, Add, Button, x412 y563 gcancellist, Cancel
Gui, Add, Button, xp-70 yp+32 gSubmitlist, Send to Download

Gui, Show, , URL List Options

if ShowListPop = 0
{
	if WinExist("ahk_id" hwndShowListButtonPopup)
	{
		Gui, %hwndShowListButtonPopup%:Destroy
	}
	Gui, New
	Gui, +hwndhwndShowListButtonPopup
	Gui, Font, s10, Segoe UI
	Gui, Add, Text, x10 y10 w300, The list feature allows you to add multiple URLs to download simultaneously. These URLs can be from YouTube or other media sites (eg. Vimeo, Soundcloud) - most sites will download successfully.`n`nGot several videos open in your browser you want to download? Use the "Grab URL list from browser tabs" button!`n`nMake sure to check the estimated playlist number on the main page before hitting download - automatic behavior is to download ALL videos from playlist URLs...so you might find the download quite massive if you aren't careful.`n
	Gui, Add, Checkbox, vShowListPop gShowListPop, Don't show again
	Gui, Add, Button, gShowListPopButton, OK
	Gui, Show
	return
	
	ShowListPopButton:
	Gui, Submit
	Gui, Destroy
	return
	
	ShowListPop:
	IniWrite, 1, %LocalAppData%\Cascades\ini\1.ini, section1, ShowListPop
	return
	
	
}

return

cancellist:
Gui, Cancel
Gui, Destroy
WinActivate, ahk_id %hGUIhwnd%
return

Submitlist:
Gui, %hwndlistbutton%:Default
Gui, Submit
Gui, Destroy
URLlisttag = 1
RAWUrlList := URLEditList
ditto := RegExReplace(RAWUrlList, "[`n`r;]", Replacement := ",")
ditto := RegExReplace(ditto, ",+", Replacement := ",")
ditto := RegExReplace(ditto, "\s", Replacement := "")
ditto := RegExReplace(ditto, "[`t`n`r]", Replacement := "")
ditto := RegExReplace(ditto, "h*t*p*s*:\/\/w{0,3}\.?", Replacement := "")

For i, value in StrSplit(ditto, ","), uniques := {}, ditto2 := "" ;removing non-unique elements from string
	if !uniques.HasKey(value)
		ditto2 .= value . "`n" , uniques[value] := true

ditto2 := RegExReplace(ditto2, "\s+", Replacement := "`n")
URLEditList := ditto2

ditto2 := RegExReplace(ditto2, "[`n`r;]", Replacement := ",")
ditto2 := RegExReplace(ditto2, "`t", Replacement := "")
ditto2 := RegExReplace(ditto2, "\s", Replacement := "")
ditto2 := RegExReplace(ditto2, ",+", Replacement := ",")

URLArray := StrSplit(ditto2, ",", Replacement := "`t`n`r,")

tempArray := [] ;clean blanks from Array
loop, % URLArray.count()
{
	tempvar := URLArray[A_Index]
	if RegExMatch(tempvar, "\S")
	{
		tempArray.push(tempvar)
	}
}
URLArray := tempArray

Playlistcount = 0
Loop, % URLArray.Count()
{
	URLoutput := URLArray[A_Index]
	if RegExMatch(URLoutput, "youtube\.com")
	{
		if RegExMatch(URLoutput, "[&\?]list=(?!WL)")
		{
			Playlistcount := Playlistcount + 1
		}
	}
}

URLnumber := URLArray.Count()
Gui, %GUIHwnd%:Default
GuiControl,, %videourlbox%, URL List -- %URLnumber% links, %Playlistcount% playlists detected  .  .  .  .  .  .  .  .  .  .  .  .  .  .  .  .
GuiControl, Move, %Filename%, W200
GuiControl,, %Filename%, Batch-download folder name:
GuiControlGet, NonYoutubeSiteSpy,, %NonYoutubeSitebox%
if NonYoutubeSiteSpy = 1
{
	GuiControl,, %VideoTitlehwnd%
	GuiControl,, %NonYoutubeSitebox%, 0
}
GuiControl, Hide, %NonYoutubeSitebox%
WinActivate, ahk_id %GUIhwnd%
return

;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::



ShowListGUI:
IniWrite, 1, %LocalAppData%\Cascades\ini\1.ini, section1, ShowListGUI
return

ShowListGUIButton:
Gui, Submit
Gui, Destroy
goto ShowListGUIButton2

GrabTabs:
if Line = 5
{
	WinActivate, ahk_id %ListActiveHwnd%
} else {
	if ShowListGUI = 0
	{
		if WinExist("ahk_id" hwndShowListGUI)
		{
			Gui, %hwndShowListGUI%:Destroy
		}
		Gui, New
		Gui, +hwndhwndShowListGUI
		Gui, Font, s10, Segoe UI
		Gui, Add, Text, x10 y10, After pressing the "OK" button, open/click on a browser window with the YouTube links`nyou want to add to your URL download list.`n`nWAIT for the tabs to be checked automatically - YouTube URLs will appear in the list box.`nThis can take up to 10 seconds - do not interrupt.`nThis feature only works for CHROME!`n`nTIPS:`nVideo information will be automatically acquired.`nYou can use this button multiple times to grab tabs from more windows if you wish.`nIt is okay if the window contains non-Youtube tabs.`n
		Gui, Add, Checkbox, vShowListGUI gShowListGUI, Don't show again
		Gui, Add, Button, x425 w100 gShowListGUIButton, OK
		Gui, Show
		return
	}
}

ShowListGUIButton2:
if (Line != 5)
{
	SetTitleMatchMode, RegEx
	WinWaitActive, (Google Chrome|Mozilla Firefox),,10 ;Firefox undergoing validation!!!   |Mozilla Firefox|Microsoft Edge Add more Browsers::::::::::::::::::::::::::::::::::::::::::::::
	if ErrorLevel
	{
		MsgBox, No browser window selected.`nCommand cancelled.
		return
	}
	SetTitleMatchMode, 1
}

GrabTabsArray := BlankArray
FirstTabFound = 0
SecondTabFound = 0
;FastChrome = 0
InitialURL := ""
SecondURL := ""
IUnoHTTP := ""
SUnoHTTP := ""
;if WinActive("Google Chrome")
;{
	;FastChrome = 1
;}

SetTimer, TIMEOUT, Off
SetTimer, TIMEOUT, Delete
TIMEOUT = 0
Tooltip, Please do not interrupt.`nTab acquisition in progress., 150, 150
SetTimer, TIMEOUT, 12000

InitialURL := GetActiveBrowserURL()
GrabTabsArray.Push(InitialURL)
IUnoHTTP := RegExReplace(InitialURL, "h*t*p*s*:\/\/w{0,3}\.?", Replacement := "")
send, ^{tab}
SecondURL := GetActiveBrowserURL()
GrabTabsArray.Push(SecondURL)
SUnoHTTP := RegExReplace(SecondURL, "h*t*p*s*:\/\/w{0,3}\.?", Replacement := "")

While((FirstTabFound = 0 OR SecondTabFound = 0) AND TIMEOUT = 0)
{
	send, ^{tab}
	WorkingURL := GetActiveBrowserURL()
	GrabTabsArray.Push(WorkingURL)
	WUnoHTTP := RegExReplace(WorkingURL, "h*t*p*s*:\/\/w{0,3}\.?", Replacement := "")
	if FirstTabFound = 0
	{
		if InStr(WUnoHTTP, IUnoHTTP) AND InStr(IUnoHTTP, WUnoHTTP)
		{
			FirstTabFound = 1
		}
	} else {
		if InStr(WUnoHTTP, SUnoHTTP) AND InStr(SUnoHTTP, WUnoHTTP)
		{
			SecondTabFound = 1
		}
	}
}
	;if FastChrome = 0   - add at end of loop
	;{
		;sleep, 50
	;}


FirstTabFound = 0
While(FirstTabFound = 0 AND TIMEOUT = 0)
{	
	send, ^+{tab}
	WorkingURL := GetActiveBrowserURL()
	WUnoHTTP := RegExReplace(WorkingURL, "h*t*p*s*:\/\/w{0,3}\.?", Replacement := "")
	if InStr(WUnoHTTP, IUnoHTTP) AND InStr(IUnoHTTP, WUnoHTTP)
	{
		FirstTabFound = 1
	}
	sleep 50
}

Tooltip
iTimeOut = 0
if TIMEOUT = 1
{
	iTimeOut = 1
}
;Clean Array

GrabTabsURLCount := GrabTabsArray.Count()
Loop, %GrabTabsURLCount%
{
	CurrentVal := GrabTabsArray[A_Index]
	if not RegExMatch(CurrentVal, "youtube\.com")
	{
		GrabTabsArray.RemoveAt(A_Index)
		GrabTabsArray.InsertAt(A_Index,"@@@")
	}
}

killstring := "" ;Necesary to clear vars in order to maintain integrity
killval := ""
for kk,killval in GrabTabsArray              ; loop, getting each KKth item, storing in killval - opposite of stringsplit
	killstring .= "," . killval ; replace `n to make different middle char
killstring := substr(killstring,2)

killstring := RegExReplace(killstring, "@@@,?", Replacement := "")
killstring := RegExReplace(killstring, "h*t*p*s*:\/\/w{0,3}\.?", Replacement := "")
killstring := regexreplace(killstring, "(?<=,)y?o?u?t?u?be\.com/playlist\?list=WL,", Replacement := "")
killstring := regexreplace(killstring, "^y?o?u?t?u?be\.com/playlist\?list=WL,", Replacement := "")
killstring := regexreplace(killstring, ",y?o?u?t?u?be\.com/playlist\?list=WL$", Replacement := "")

For i, value in StrSplit(killstring, ","), uniques := {}, StringNew := "" ;removing non-unique elements from string
	if !uniques.HasKey(value)
		StringNew .= value . "," , uniques[value] := true

finalstring := RegExReplace(Stringnew, ",", Replacement := "`n")

Gui, %hwndlistbutton%:Default
GuiControlGet, CurrentContents ,,%URLEditListID%

if (CurrentContents = "")
{
	GuiControl,, %URLEditListID%, %finalstring%
} else {
	GuiControl,, %URLEditListID%, %CurrentContents%`n%finalstring%
}

WinActivate, ahk_id %hwndlistbutton%


SetTimer, TIMEOUT, Off
SetTimer, TIMEOUT, Delete
TIMEOUT = 0

Gui, Color, Lime
sleep, 1000
Gui, Color, White

if iTimeOut = 1
{
	msgbox, Process timed out before looping through all tabs.
}

if GrabCompletePop = 0
{
	if WinExist("ahk_id" hwndGrabCompletePop)
	{
		Gui, %hwndGrabCompletePop%:Destroy
	}
	Gui, New
	Gui, +hwndhwndGrabCompletePop
	Gui, Font, s10, Segoe UI
	Gui, Add, Text, x10 y10 w300, Video URLs imported.`n`nYou can use the Grab URLs button again, add more URLs manually, or hit "Send to Download" if these are all the videos you want.`n
	Gui, Add, Checkbox, vGrabCompletePop gGrabCompletePop, Don't show again
	Gui, Add, Button, gGrabCompletePopButton, OK
	Gui, Show
	return
	
	GrabCompletePopButton:
	Gui, Submit
	Gui, Destroy
	return
	
	GrabCompletePop:
	IniWrite, 1, %LocalAppData%\Cascades\ini\1.ini, section1, GrabCompletePop
	return
}
Return

TIMEOUT:
TIMEOUT = 1
return

RemoveToolTip:
ToolTip
return

cancelbutton:
Gui, cancel
Gui, Destroy
exit

downloadbutton:
Gui, Submit
Gui, Destroy

RadioGroupChecked1 := 2 - RadioGroup
RadioGroupChecked2 := RadioGroup - 1
IniWrite, %RadioGroupChecked1%, %LocalAppData%\Cascades\ini\1.ini, section1, RadioGroupChecked1
IniWrite, %RadioGroupChecked2%, %LocalAppData%\Cascades\ini\1.ini, section1, RadioGroupChecked2
;IniWrite, %RadioGroup%, %LocalAppData%\Cascades\ini\1.ini, section1, RadioGroup
IniWrite, %FolderChoiceDrop%, %LocalAppData%\Cascades\ini\1.ini, section1, FolderChoiceDrop

FolderArray := [Downloads, Videos, Music, Desktop, Documents, Custom]
DownloadRoot := FolderArray[FolderChoiceDrop]

if URLlisttag = 1
{
	goto URLlistpath
}

if NonYoutubeSite = 1
{
	if (VideoURL = "")
	{
		msgbox, Please enter video URL and title to start download.
		goto Gui
	}
	goto NonYoutubeRedirect
}

if Line = 3
{
	if (VideoURL = "") OR (VideoTitle = "")
	{
		msgbox, Please enter video URL and title to start download.
		goto Gui
	}
	if RegExMatch(VideoURL, "[&\?]list=(?!WL)")
	{
		PlaylistTrue = 1
	}
}
gosub CleanTitle

if PlaylistTrue = 1
{
	goto Playlistvariant
}

if RadioGroup = 1 ;video
{
	RunWait, %comspec% /c ""%LocalAppData%\Cascades\yt-dlp.exe" "--no-mtime" "--newline" "-i" "-o" "%DownloadRoot%\%VideoTitle%.`%(ext)s" "-f" "%VideoFormat%" "--ignore-config" "--hls-prefer-native" "--ffmpeg-location" "%LocalAppData%\Cascades\FFMPEG\ffmpeg.exe" "%VideoURL%"", , hide
	Format := VideoFormat
}
if RadioGroup = 2 ;music
{
	RunWait, %comspec% /c ""%LocalAppData%\Cascades\yt-dlp.exe" "--no-mtime" "--newline" "-i" "-o" "%DownloadRoot%\%VideoTitle%.`%(ext)s" "-x" "-v" "--ignore-config" "--hls-prefer-native" "--audio-format" "%MusicFormat%" "--no-break-per-input" "--ffmpeg-location" "%LocalAppData%\Cascades\FFMPEG\ffmpeg.exe" "%VideoURL%"", , hide
	Format := MusicFormat
}
goto endingR

NonYoutubeRedirect:
if RadioGroup = 1 ;video
{
	RunWait, %comspec% /c ""%LocalAppData%\Cascades\yt-dlp.exe" "--no-mtime" "--newline" "-i" "-o" "%DownloadRoot%\`%(title)s.`%(ext)s" "-f" "%VideoFormat%" "--ignore-config" "--hls-prefer-native" "--ffmpeg-location" "%LocalAppData%\Cascades\FFMPEG\ffmpeg.exe" "%VideoURL%"", , hide
}
if RadioGroup = 2 ;music
{
	RunWait, %comspec% /c ""%LocalAppData%\Cascades\yt-dlp.exe" "--no-mtime" "--newline" "-i" "-o" "%DownloadRoot%\`%(title)s.`%(ext)s" "-x" "-v" "--ignore-config" "--hls-prefer-native" "--audio-format" "%MusicFormat%" "--no-break-per-input" "--ffmpeg-location" "%LocalAppData%\Cascades\FFMPEG\ffmpeg.exe" "%VideoURL%"", , hide
}
goto endingP

URLlistpath:
if (VideoTitle = "")
{
	InputBox, VideoTitle,Name folder,Please provide a batch-download folder name:
}
gosub CleanTitle
Playlistcount := BlankArray
;Playlistcount.Delete(Playlistcount.MinIndex(), Playlistcount.MaxIndex())
DownloadRoot = %DownloadRoot%\%VideoTitle%
OGClip := Clipboard

Loop, % URLArray.Count()
{
	URLoutput := URLArray[A_Index]
	VideoURL := URLoutput
	if RegExMatch(URLoutput, "youtube\.com")
	{
		if RegExMatch(URLoutput, "[&\?]list=(?!WL)")
		{
			VideoURL := URLoutput
			Playlistcount.Push(A_Index)
			RunWait, %comspec% /c ""%LocalAppData%\Cascades\yt-dlp.exe" "-e" "%VideoURL%" | clip", , Hide
			VideoTitle = %clipboard%
			Clipboard := OGClip
			VideoTitle := RegExReplace(VideoTitle, "[<>\|\\/]", Replacement := "-")
			VideoTitle := RegExReplace(VideoTitle, "\?", Replacement := "？")
			VideoTitle := RegExReplace(VideoTitle, ":", Replacement := "꞉")
			VideoTitle := RegExReplace(VideoTitle, "[""]", Replacement := "'")
			VideoTitle := RegExReplace(VideoTitle, "\*", Replacement := "⁎")
			StringReplace, VideoTitle, VideoTitle,`n,%A_Space%,All
			StringReplace, VideoTitle, VideoTitle,`r,%A_Space%,All
			StringReplace, VideoTitle, VideoTitle,`r`n,%A_Space%,All
			VideoTitle := RegExReplace(VideoTitle, "[\s]+$", Replacement := "")
			Playlistnumber := Playlistcount.Count()
			ListPLRoot = Playlist %Playlistnumber% - %VideoTitle%
			
			if RadioGroup = 1 ;video
			{
				RunWait, %comspec% /c ""%LocalAppData%\Cascades\yt-dlp.exe" "--no-mtime" "--newline" "-i" "-o" "%DownloadRoot%\%ListPLRoot%\`%(title)s.`%(ext)s" "-f" "%VideoFormat%" "--ignore-config" "--hls-prefer-native" "--ffmpeg-location" "%LocalAppData%\Cascades\FFMPEG\ffmpeg.exe" "%VideoURL%"", , hide
			}
			if RadioGroup = 2 ;music
			{
				RunWait, %comspec% /c ""%LocalAppData%\Cascades\yt-dlp.exe" "--no-mtime" "--newline" "-i" "-o" "%DownloadRoot%\%ListPLRoot%\`%(title)s.`%(ext)s" "-x" "-v" "--ignore-config" "--hls-prefer-native" "--audio-format" "%MusicFormat%" "--no-break-per-input" "--ffmpeg-location" "%LocalAppData%\Cascades\FFMPEG\ffmpeg.exe" "%VideoURL%"", , hide
			}
		}
	}
	
	if RadioGroup = 1 ;video
	{
		RunWait, %comspec% /c ""%LocalAppData%\Cascades\yt-dlp.exe" "--no-mtime" "--newline" "-i" "-o" "%DownloadRoot%\`%(title)s.`%(ext)s" "-f" "%VideoFormat%" "--ignore-config" "--hls-prefer-native" "--ffmpeg-location" "%LocalAppData%\Cascades\FFMPEG\ffmpeg.exe" "%VideoURL%"", , hide
	}
	if RadioGroup = 2 ;music
	{
		RunWait, %comspec% /c ""%LocalAppData%\Cascades\yt-dlp.exe" "--no-mtime" "--newline" "-i" "-o" "%DownloadRoot%\`%(title)s.`%(ext)s" "-x" "-v" "--ignore-config" "--hls-prefer-native" "--audio-format" "%MusicFormat%" "--no-break-per-input" "--ffmpeg-location" "%LocalAppData%\Cascades\FFMPEG\ffmpeg.exe" "%VideoURL%"", , hide
	}
}

if endingV = 1
{
	Gui, Font, s10, Segoe UI
	Gui, Add, Text,,Download complete at:`n%DownloadRoot%
	Gui, Font, s11, Segoe UI
	Gui, Add, Button, x175 y55 Default w80 gending1, OK
	Gui, Add, Button,x15 y55 w150 gOiF2, Open in Folder
	Gui, Show,, Download complete	
	return
}
if endingV = 2
{
	goto ending
}
if endingV = 3
{
	ToolTip, Download complete.
	sleep, 2000
	ToolTip
	goto ending
}
if endingV = 4
{
	goto OiF22
}
return

Playlistvariant:
if (VideoTitle = "")
{
	InputBox, VideoTitle,Name folder,Please provide a playlist folder name:
}
DownloadRoot = %DownloadRoot%\%VideoTitle%
if RadioGroup = 1 ;video
{
	RunWait, %comspec% /c ""%LocalAppData%\Cascades\yt-dlp.exe" "--no-mtime" "--newline" "-i" "-o" "%DownloadRoot%\`%(title)s.`%(ext)s" "-f" "%VideoFormat%" "--ignore-config" "--hls-prefer-native" "--ffmpeg-location" "%LocalAppData%\Cascades\FFMPEG\ffmpeg.exe" "%VideoURL%"", , hide
}
if RadioGroup = 2 ;music
{
	RunWait, %comspec% /c ""%LocalAppData%\Cascades\yt-dlp.exe" "--no-mtime" "--newline" "-i" "-o" "%DownloadRoot%\`%(title)s.`%(ext)s" "-x" "-v" "--ignore-config" "--hls-prefer-native" "--audio-format" "%MusicFormat%" "--no-break-per-input" "--ffmpeg-location" "%LocalAppData%\Cascades\FFMPEG\ffmpeg.exe" "%VideoURL%"", , hide
}
goto endingP


endingR:
if endingV = 1
{
	
	if WinExist("ahk_id" hwndendingR)
	{
		Gui, %hwndendingR%:Destroy		
	}
	Gui, New
	Gui, +hwndhwndendingR
	Gui, Font, s10, Segoe UI
	Gui, Add, Text,,File Downloaded to:`n%DownloadRoot%\%VideoTitle%.%Format%
	Gui, Font, s11, Segoe UI	
	Gui, Add, Button, x175 y55 Default w80 gending1, OK
	Gui, Add, Button,x15 y55 w150 gOiF1, Open in Folder
	Gui, Show,, File Downloaded
	return
}
if endingV = 2
{
	goto ending
}
if endingV = 3
{
	ToolTip, File Downloaded.
	sleep, 2000
	ToolTip
	goto ending
}
if endingV = 4
{
	goto OiF11
}


endingP:
if endingV = 1
{
	if WinExist("ahk_id" hwndendingP)
	{
		Gui, %hwndendingP%:Destroy		
	}
	Gui, New
	Gui, +hwndhwndendingP
	Gui, Font, s10, Segoe UI
	if NonYoutubeSite = 0
		Gui, Add, Text,,Playlist downloaded to:`n%DownloadRoot%
	if NonYoutubeSite = 1
		Gui, Add, Text,,Download complete at:`n%DownloadRoot%	
	Gui, Add, Button, x175 y55 Default w80 gending1, OK
	Gui, Add, Button,x15 y55 w150 gOiF2, Open in Folder
	if NonYoutubeSite = 0
		Gui, Show,, Playlist downloaded
	if NonYoutubeSite = 1
		Gui, Show,, Download complete	
	return
}
if endingV = 2
{
	goto ending
}
if endingV = 3
{
	if NonYoutubeSite = 0
		ToolTip, Playlist downloaded.
	if NonYoutubeSite = 1
		ToolTip, Download complete.
	sleep, 2000
	ToolTip
	goto ending
}
if endingV = 4
{
	goto OiF22
}


OiF1:
Gui, Submit
Gui, Destroy
FullPath1 = %DownloadRoot%\%VideoTitle%.%Format%
explorerpath:="explorer /select," FullPath1
Run, %explorerpath%
goto ending

OiF11:
FullPath1 = %DownloadRoot%\%VideoTitle%.%Format%
explorerpath:= "explorer /select," FullPath1
Run, %explorerpath%
goto ending

OiF2:
Gui, Submit
Gui, Destroy
Run, explorer "%DownloadRoot%"
goto ending

OiF22:
Run, explorer "%DownloadRoot%"
goto ending

ending1:
Gui, Submit
Gui, Destroy
goto ending

ending:
exit



VideoDownloadTree:
DownloadRoot = %VideosConfig%
gosub CleanTitle

if PlaylistTrue = 1
{
	goto PlaylistvariantVT
}
RunWait, %comspec% /c ""%LocalAppData%\Cascades\yt-dlp.exe" "--no-mtime" "--newline" "-i" "-o" "%DownloadRoot%\%VideoTitle%.`%(ext)s" "-f" "%VideoFormat%" "--ignore-config" "--hls-prefer-native" "--ffmpeg-location" "%LocalAppData%\Cascades\FFMPEG\ffmpeg.exe" "%VideoURL%"", , hide
Format := VideoFormat
if endingVv = 1
{
	if WinExist("ahk_id" hwndVideoDownloadTree)
	{
		Gui, %hwndVideoDownloadTree%:Destroy		
	}
	Gui, New
	Gui, +hwndhwndVideoDownloadTree
	Gui, Font, s10, Segoe UI
	Gui, Add, Text,,File Downloaded to:`n%DownloadRoot%\%VideoTitle%.%Format%
	Gui, Font, s11, Segoe UI	
	Gui, Add, Button, x175 y55 Default w80 gending1, OK
	Gui, Add, Button,x15 y55 w150 gOiF1, Open in Folder
	Gui, Show,, File Downloaded
	return
}
if endingVv = 2
{
	goto ending
}
if endingVv = 3
{
	ToolTip, File Downloaded.
	sleep, 2000
	ToolTip
	goto ending
}
if endingVv = 4
{
	goto OiF11
}

PlaylistvariantVT:
if (VideoTitle = "")
{
	InputBox, VideoTitle,Name folder,Please provide a playlist folder name:
}
DownloadRoot = %DownloadRoot%\%VideoTitle%
RunWait, %comspec% /c ""%LocalAppData%\Cascades\yt-dlp.exe" "--no-mtime" "--newline" "-i" "-o" "%DownloadRoot%\`%(title)s.`%(ext)s" "-f" "%VideoFormat%" "--ignore-config" "--hls-prefer-native" "--ffmpeg-location" "%LocalAppData%\Cascades\FFMPEG\ffmpeg.exe" "%VideoURL%"", , hide
if endingVv = 1
{
	if WinExist("ahk_id" hwndPlaylistvariantVT)
	{
		Gui, %hwndPlaylistvariantVT%:Destroy		
	}
	Gui, New
	Gui, +hwndhwndPlaylistvariantVT
	Gui, Font, s10, Segoe UI
	if NonYoutubeSite = 0
		Gui, Add, Text,,Playlist downloaded to:`n%DownloadRoot%
	if NonYoutubeSite = 1
		Gui, Add, Text,,Download complete at:`n%DownloadRoot%	
	Gui, Add, Button, x175 y55 Default w80 gending1, OK
	Gui, Add, Button,x15 y55 w150 gOiF2, Open in Folder
	if NonYoutubeSite = 0
		Gui, Show,, Playlist downloaded
	if NonYoutubeSite = 1
		Gui, Show,, Download complete	
	return
}
if endingVv = 2
{
	goto ending
}
if endingVv = 3
{
	if NonYoutubeSite = 0
		ToolTip, Playlist downloaded.
	if NonYoutubeSite = 1
		ToolTip, Download complete.
	sleep, 2000
	ToolTip
	goto ending
}
if endingVv = 4
{
	goto OiF22
}


MusicDownloadTree:
DownloadRoot = %MusicConfig%
gosub CleanTitle

if PlaylistTrue = 1
{
	goto PlaylistvariantMT
}
RunWait, %comspec% /c ""%LocalAppData%\Cascades\yt-dlp.exe" "--no-mtime" "--newline" "-i" "-o" "%DownloadRoot%\%VideoTitle%.`%(ext)s" "-x" "-v" "--ignore-config" "--hls-prefer-native" "--audio-format" "%MusicFormat%" "--no-break-per-input" "--ffmpeg-location" "%LocalAppData%\Cascades\FFMPEG\ffmpeg.exe" "%VideoURL%"", , hide
Format := MusicFormat
if endingVm = 1
{
	if WinExist("ahk_id" hwndMusicDownloadTree)
	{
		Gui, %hwndMusicDownloadTree%:Destroy		
	}
	Gui, New
	Gui, +hwndhwndMusicDownloadTree
	Gui, Font, s10, Segoe UI
	Gui, Add, Text,,File Downloaded to:`n%DownloadRoot%\%VideoTitle%.%Format%
	Gui, Font, s11, Segoe UI	
	Gui, Add, Button, x175 y55 Default w80 gending1, OK
	Gui, Add, Button,x15 y55 w150 gOiF1, Open in Folder
	Gui, Show,, File Downloaded
	return
}
if endingVm = 2
{
	goto ending
}
if endingVm = 3
{
	ToolTip, File Downloaded.
	sleep, 2000
	ToolTip
	goto ending
}
if endingVm = 4
{
	goto OiF11
}

PlaylistvariantMT:
if (VideoTitle = "")
{
	InputBox, VideoTitle,Name folder,Please provide a playlist folder name:
}
DownloadRoot = %DownloadRoot%\%VideoTitle%
RunWait, %comspec% /c ""%LocalAppData%\Cascades\yt-dlp.exe" "--no-mtime" "--newline" "-i" "-o" "%DownloadRoot%\`%(title)s.`%(ext)s" "-x" "-v" "--ignore-config" "--hls-prefer-native" "--audio-format" "%MusicFormat%" "--no-break-per-input" "--ffmpeg-location" "%LocalAppData%\Cascades\FFMPEG\ffmpeg.exe" "%VideoURL%"", , hide
if endingVm = 1
{
	if WinExist("ahk_id" hwndPlaylistvariantMT)
	{
		Gui, %hwndPlaylistvariantMT%:Destroy		
	}
	Gui, New
	Gui, +hwndhwndPlaylistvariantMT
	Gui, Font, s10, Segoe UI
	if NonYoutubeSite = 0
		Gui, Add, Text,,Playlist downloaded to:`n%DownloadRoot%
	if NonYoutubeSite = 1
		Gui, Add, Text,,Download complete at:`n%DownloadRoot%	
	Gui, Add, Button, x175 y55 Default w80 gending1, OK
	Gui, Add, Button,x15 y55 w150 gOiF2, Open in Folder
	if NonYoutubeSite = 0
		Gui, Show,, Playlist downloaded
	if NonYoutubeSite = 1
		Gui, Show,, Download complete	
	return
}
if endingVm = 2
{
	goto ending
}
if endingVm = 3
{
	if NonYoutubeSite = 0
		ToolTip, Playlist downloaded.
	if NonYoutubeSite = 1
		ToolTip, Download complete.
	sleep, 2000
	ToolTip
	goto ending
}
if endingVm = 4
{
	goto OiF22
}

CleanTitle:
VideoTitle := RegExReplace(VideoTitle, "[<>\|\\/]", Replacement := "-")
VideoTitle := RegExReplace(VideoTitle, "\?", Replacement := "？")
VideoTitle := RegExReplace(VideoTitle, ":", Replacement := "꞉")
VideoTitle := RegExReplace(VideoTitle, "[""]", Replacement := "'")
VideoTitle := RegExReplace(VideoTitle, "\*", Replacement := "⁎")
StringReplace, VideoTitle, VideoTitle,`n,%A_Space%,All
StringReplace, VideoTitle, VideoTitle,`r,%A_Space%,All
StringReplace, VideoTitle, VideoTitle,`r`n,%A_Space%,All
VideoTitle := RegExReplace(VideoTitle, "[\s]+$", Replacement := "")
Return



;Get Browser URL Lib
GetActiveBrowserURL() {
	global ModernBrowsers, LegacyBrowsers
	WinGetClass, sClass, A
	If sClass In % ModernBrowsers
		Return GetBrowserURL_ACC(sClass)
	Else If sClass In % LegacyBrowsers
		Return GetBrowserURL_DDE(sClass) ; empty string if DDE not supported (or not a browser)
	Else
		Return ""
}

GetBrowserURL_DDE(sClass) {
	WinGet, sServer, ProcessName, % "ahk_class " sClass
	StringTrimRight, sServer, sServer, 4
	iCodePage := A_IsUnicode ? 0x04B0 : 0x03EC ; 0x04B0 = CP_WINUNICODE, 0x03EC = CP_WINANSI
	DllCall("DdeInitialize", "UPtrP", idInst, "Uint", 0, "Uint", 0, "Uint", 0)
	hServer := DllCall("DdeCreateStringHandle", "UPtr", idInst, "Str", sServer, "int", iCodePage)
	hTopic := DllCall("DdeCreateStringHandle", "UPtr", idInst, "Str", "WWW_GetWindowInfo", "int", iCodePage)
	hItem := DllCall("DdeCreateStringHandle", "UPtr", idInst, "Str", "0xFFFFFFFF", "int", iCodePage)
	hConv := DllCall("DdeConnect", "UPtr", idInst, "UPtr", hServer, "UPtr", hTopic, "Uint", 0)
	hData := DllCall("DdeClientTransaction", "Uint", 0, "Uint", 0, "UPtr", hConv, "UPtr", hItem, "UInt", 1, "Uint", 0x20B0, "Uint", 10000, "UPtrP", nResult) ; 0x20B0 = XTYP_REQUEST, 10000 = 10s timeout
	sData := DllCall("DdeAccessData", "Uint", hData, "Uint", 0, "Str")
	DllCall("DdeFreeStringHandle", "UPtr", idInst, "UPtr", hServer)
	DllCall("DdeFreeStringHandle", "UPtr", idInst, "UPtr", hTopic)
	DllCall("DdeFreeStringHandle", "UPtr", idInst, "UPtr", hItem)
	DllCall("DdeUnaccessData", "UPtr", hData)
	DllCall("DdeFreeDataHandle", "UPtr", hData)
	DllCall("DdeDisconnect", "UPtr", hConv)
	DllCall("DdeUninitialize", "UPtr", idInst)
	csvWindowInfo := StrGet(&sData, "CP0")
	StringSplit, sWindowInfo, csvWindowInfo, `" ;"; comment to avoid a syntax highlighting issue in autohotkey.com/boards
	Return sWindowInfo2
}

GetBrowserURL_ACC(sClass) {
	global nWindow, accAddressBar
	If (nWindow != WinExist("ahk_class " sClass)) ; reuses accAddressBar if it's the same window
	{
		nWindow := WinExist("ahk_class " sClass)
		accAddressBar := GetAddressBar(Acc_ObjectFromWindow(nWindow))
	}
	Try sURL := accAddressBar.accValue(0)
	If (sURL == "") {
		WinGet, nWindows, List, % "ahk_class " sClass ; In case of a nested browser window as in the old CoolNovo (TO DO: check if still needed)
		If (nWindows > 1) {
			accAddressBar := GetAddressBar(Acc_ObjectFromWindow(nWindows2))
			Try sURL := accAddressBar.accValue(0)
		}
	}
	If ((sURL != "") and (SubStr(sURL, 1, 4) != "http")) ; Modern browsers omit "http://"
		sURL := "http://" sURL
	If (sURL == "")
		nWindow := -1 ; Don't remember the window if there is no URL
	Return sURL
}

; "GetAddressBar" based in code by uname
; Found at http://autohotkey.com/board/topic/103178-/?p=637687

GetAddressBar(accObj) {
	Try If ((accObj.accRole(0) == 42) and IsURL(accObj.accValue(0)))
	Return accObj
	Try If ((accObj.accRole(0) == 42) and IsURL("http://" accObj.accValue(0))) ; Modern browsers omit "http://"
	Return accObj
	For nChild, accChild in Acc_Children(accObj)
		If IsObject(accAddressBar := GetAddressBar(accChild))
			Return accAddressBar
}

IsURL(sURL) {
	Return RegExMatch(sURL, "^(?<Protocol>https?|ftp)://(?<Domain>(?:[\w-]+\.)+\w\w+)(?::(?<Port>\d+))?/?(?<Path>(?:[^:/?# ]*/?)+)(?:\?(?<Query>[^#]+)?)?(?:\#(?<Hash>.+)?)?$")
}

; The code below is part of the Acc.ahk Standard Library by Sean (updated by jethrow)
; Found at http://autohotkey.com/board/topic/77303-/?p=491516

Acc_Init()
{
	static h
	If Not h
		h:=DllCall("LoadLibrary","Str","oleacc","Ptr")
}
Acc_ObjectFromWindow(hWnd, idObject = 0)
{
	Acc_Init()
	If DllCall("oleacc\AccessibleObjectFromWindow", "Ptr", hWnd, "UInt", idObject&=0xFFFFFFFF, "Ptr", -VarSetCapacity(IID,16)+NumPut(idObject==0xFFFFFFF0?0x46000000000000C0:0x719B3800AA000C81,NumPut(idObject==0xFFFFFFF0?0x0000000000020400:0x11CF3C3D618736E0,IID,"Int64"),"Int64"), "Ptr*", pacc)=0
		Return ComObjEnwrap(9,pacc,1)
}
Acc_Query(Acc) {
	Try Return ComObj(9, ComObjQuery(Acc,"{618736e0-3c3d-11cf-810c-00aa00389b71}"), 1)
}
Acc_Children(Acc) {
	If ComObjType(Acc,"Name") != "IAccessible"
		ErrorLevel := "Invalid IAccessible Object"
	Else {
		Acc_Init(), cChildren:=Acc.accChildCount, Children:=[]
		If DllCall("oleacc\AccessibleChildren", "Ptr",ComObjValue(Acc), "Int",0, "Int",cChildren, "Ptr",VarSetCapacity(varChildren,cChildren*(8+2*A_PtrSize),0)*0+&varChildren, "Int*",cChildren)=0 {
			Loop %cChildren%
				i:=(A_Index-1)*(A_PtrSize*2+8)+8, child:=NumGet(varChildren,i), Children.Insert(NumGet(varChildren,i-8)=9?Acc_Query(child):child), NumGet(varChildren,i-8)=9?ObjRelease(child):
			Return Children.MaxIndex()?Children:
		} Else
			ErrorLevel := "AccessibleChildren DllCall Failed"
	}
}