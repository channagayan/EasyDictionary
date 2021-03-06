#cs ----------------------------------------------------------------------------

 EasyDictionary Version: 1.0
 Author:Channa Gayan

 Script Function:
	Capture words and copy to clipboard
	display popup with captured word
	Ctrl+Click 
	Tray menu (settings, about, help, exit)

#ce ----------------------------------------------------------------------------
#include <MouseOnEvent.au3>
#include <GUIConstants.au3>
#include "ModernMenuRaw.au3" ;  constants are declared here
#include <Settings.au3>
#include <About.au3>
#include <Help.au3>
#include<Error_UDF.au3>
#include <Misc.au3>
#include <Array.au3>
#include<_SysTray.au3>

Opt("TrayIconHide", 1)

Global $oMyError = ObjEvent("AutoIt.Error","_RestartProgram") 					; global error handling object ;currently restart script
Global $iPrimary_DblClk_Event = 0 												; to handle the double click event
Opt("WinTitleMatchMode", 2) 													;change winwaitactive function mode to match window title substring
_MouseSetOnEvent($MOUSE_PRIMARYDBLCLK_EVENT, '_DblClk_Event')
_ClearSysTray()																	; clears system tray icons when restart
$dll = DllOpen("user32.dll")
Local $dbname=@ScriptDir & "\EnglishSinhala.accdb" 								; database must be there in the same folder with the script
Local $helpFile=@ScriptDir & "\Help\EasyDictionary Help.txt"
$adoCon = ObjCreate("ADODB.Connection")
$adoCon.Open("Driver={Microsoft Access Driver (*.mdb, *.accdb)}; DBQ=" & $dbname & ";Uid=;Pwd=;") ;Use this line if using MS Access 2007 and using the .accdb file extension
$adoRs = ObjCreate("ADODB.Recordset")

   
$adoRs.CursorType = 1
$adoRs.LockType = 3

$click_setting=IniRead(@ScriptDir & "\Settings.ini", "Settings", "Click", "0") ; read settings file for user settings
$bubble_timer=IniRead(@ScriptDir & "\Settings.ini", "Settings", "Time", "5")


$hMainGUI		= GUICreate("Sample Menu") 										; main gui.. currently it is dissabled. To enable uncomment GuiSetState()

SetGreenMenuColors()
SetBlueTrayColors()

_SetFlashTimeOut(250)


; File-Menu
$FileMenu		= GUICtrlCreateMenu("&File")
$nSideItem1		= _CreateSideMenu($FileMenu)
_SetSideMenuText($nSideItem1, "My File Menu")
_SetSideMenuColor($nSideItem1, 0xFFFFFF) 										; default color - white
_SetSideMenuBkColor($nSideItem1, 0x921801) 										; bottom start color - dark blue
_SetSideMenuBkGradColor($nSideItem1, 0xFBCE92) 									; top end color - light blue

; You can also set a side menu bitmap
; !Must be min. 8bppand "bmp"-format
; Samples:
; _SetSideMenuImage($nSideItem1, @ScriptDir & "\test.bmp")
; _SetSideMenuImage($nSideItem1, "test.exe", 178) ; Load the bitmap resource ordinal number 178 from 'test.exe'
; _SetSideMenuImage($nSideItem1, "mydll.dll", "#120") ; Load the bitmap resource with name '120' from 'mydll.dll'

$OpenItem		= _GUICtrlCreateODMenuItem("&Open..." & @Tab & "Ctrl+O", $FileMenu)
_GUICtrlODMenuItemSetIcon(-1, "shell32.dll", -4)
_GUICtrlODMenuItemSetSelIcon(-1, "shell32.dll", -5)
$SaveItem		= _GUICtrlCreateODMenuItem("&Save" & @Tab & "Ctrl+S", $FileMenu, "shell32.dll", -7)
_GUICtrlODMenuItemSetSelIcon(-1, "shell32.dll", -79)
_GUICtrlCreateODMenuItem("", $FileMenu) ; Separator
$RecentMenu		= _GUICtrlCreateODMenu("Recent Files", $FileMenu)
_GUICtrlCreateODMenuItem("", $FileMenu) ; Separator
$ExitItem		= _GUICtrlCreateODMenuItem("E&xit", $FileMenu, "shell32.dll", -28)

; Tools-Menu
$ToolsMenu		= GUICtrlCreateMenu("&Tools")
$CalcItem		= _GUICtrlCreateODMenuItem("Calculator", $ToolsMenu, "calc.exe", 0)
$CmdItem		= _GUICtrlCreateODMenuItem("CMD", $ToolsMenu, "cmd.exe", 0)
$EditorItem		= _GUICtrlCreateODMenuItem("Editor", $ToolsMenu, "notepad.exe", 0)
$RegeditItem	= _GUICtrlCreateODMenuItem("Regedit", $ToolsMenu, "regedit.exe", 0)

; View-Menu
$ViewMenu		= GUICtrlCreateMenu("&View")
$ViewColorMenu	= _GUICtrlCreateODMenu("Menu Colors", $ViewMenu, "mspaint.exe", 0)
$nSideItem2		= _CreateSideMenu($ViewColorMenu)
_SetSideMenuText($nSideItem2, "Choose a color")
_SetSideMenuColor($nSideItem2, 0x00FFFF)
_SetSideMenuBkColor($nSideItem2, 0xD00000)

$SetDefClrItem	= _GUICtrlCreateODMenuItem("Default", $ViewColorMenu, "", 0, 1)
_GUICtrlCreateODMenuItem("", $ViewColorMenu) ; Separator
$SetRedClrItem	= _GUICtrlCreateODMenuItem("Red", $ViewColorMenu, "", 0, 1)
$SetGrnClrItem	= _GUICtrlCreateODMenuItem("Green", $ViewColorMenu, "", 0, 1)
GUICtrlSetState(-1, $GUI_CHECKED)
$SetBlueClrItem	= _GUICtrlCreateODMenuItem("Blue", $ViewColorMenu, "", 0, 1)
_GUICtrlCreateODMenuItem("", $ViewColorMenu) ; Separator
$SetOLBlueItem	= _GUICtrlCreateODMenuItem("Outlook-Blue", $ViewColorMenu, "", 0, 1)
$SetOLSlvItem	= _GUICtrlCreateODMenuItem("Outlook-Silver", $ViewColorMenu, "", 0, 1)
$ViewStateItem	= _GUICtrlCreateODMenuItem("Enable Config", $ViewMenu)
GUICtrlSetState(-1, $GUI_CHECKED)

; Help-Menu
$HelpMenu		= GUICtrlCreateMenu("&?")
$HelpItem		= _GUICtrlCreateODMenuItem("Help Topics" & @Tab & "F1", $HelpMenu, "shell32.dll", -24)
_GUICtrlCreateODMenuItem("", $HelpMenu) ; Separator
$AboutItem		= _GUICtrlCreateODMenuItem("About...", $HelpMenu)

; You can also the same things on context menus
$GUIContextMenu	= GUICtrlCreateContextMenu(-1)
$ConAboutItem	= _GUICtrlCreateODMenuItem("About...", $GUIContextMenu, "explorer.exe", -8)
_GUICtrlCreateODMenuItem("", $GUIContextMenu) ; Separator
$ConExitItem	= _GUICtrlCreateODMenuItem("Exit", $GUIContextMenu, "shell32.dll", -28)

;GUISetState()

																											; start of tray design/////////////////////
; *** Create the tray icon ***
$nTrayIcon1		= _TrayIconCreate("Tools", "shell32.dll", -13)
_TrayIconSetClick(-1, 16)
_TrayIconSetState() ; Show the tray icon

; *** Create the tray context menu ***
$nTrayMenu1		= _TrayCreateContextMenu() 														; is the same like _TrayCreateContextMenu(-1) or _TrayCreateContextMenu($nTrayIcon1)
$nSideItem3		= _CreateSideMenu($nTrayMenu1)
_SetSideMenuText($nSideItem3, $PROJECT_NAME)
_SetSideMenuColor($nSideItem3, 0x00FFFF) ; yellow; default color - white
_SetSideMenuBkColor($nSideItem3, 0x802222) ; bottom start color - dark blue
_SetSideMenuBkGradColor($nSideItem3, 0x4477AA) ; top end color - orange
;_SetSideMenuImage($nSideItem3, "shell32.dll", 309, TRUE)


$TraySettings		= _TrayCreateItem("Settings")
_TrayItemSetIcon(-1, "shell32.dll", -25)
$TrayHelp		= _TrayCreateItem("Help")
_TrayItemSetIcon(-1, "shell32.dll", -24)
$TrayAbout		= _TrayCreateItem("About")
_TrayItemSetIcon(-1, "shell32.dll", -9)
$TrayRun		= _TrayCreateItem("Run...")
_TrayItemSetIcon(-1, "shell32.dll", -25)
_TrayCreateItem("")
_TrayItemSetIcon(-1, "", 0)
$TrayExit		= _TrayCreateItem("Exit")
_TrayItemSetIcon(-1, "shell32.dll", -28)



; WM_MEASUREITEM and WM_DRAWITEM are registered in 
; "ModernMenu.au3" so they don"t need to registered here
; Also OnAutoItExit() is in "ModernMenu.au3" to cleanup the
; menu imagelist and font

Dim $nTrayIcon2 = 0


; Main GUI Loop

While 1
	$Msg = GUIGetMsg()
	;Ctrl_click_word()                                          ; word capturing and tooltip display ctrl + click
   If WinActive("Reader") Or WinActive("Notepad") Or WinActive("Word") Then
	If $click_setting=0 Then
	  If $iPrimary_DblClk_Event Then								; double click event call
		$iPrimary_DblClk_Event = 0
		_Display_meaning()										;  double click word get
		;ToolTip('Primary Mouse Button Double Clicked.')
	  EndIf
   Else 
	  If _IsPressed("01", $dll) And _IsPressed("11", $dll) Then    ; ctrl click event call
		 Sleep(300)
		 MouseClick("left")
		 _Display_meaning()
	  EndIf
   EndIf
	 If _IsPressed("01",$dll) Then ToolTip("")              ; to remove the tooltip on next click
   EndIf
	Switch $Msg
		Case $GUI_EVENT_CLOSE, $ExitItem, $ConExitItem,$TrayExit
			ExitLoop
		Case $AboutItem, $ConAboutItem
			Msgbox(64, "About", "Menu color sample by Holger Kotsch")
			_GUICtrlODMenuItemSetText($OpenItem, "Open thisone or not..." & @Tab & "Ctrl+O")
			_GUICtrlODMenuItemSetText($ConAboutItem, "About this demo")
			
		Case $ViewStateItem
			If BitAnd(GUICtrlRead($ViewStateItem), $GUI_CHECKED) Then
				GUICtrlSetState($ViewStateItem, $GUI_UNCHECKED)
				GUICtrlSetState($ViewColorMenu, $GUI_DISABLE)
			Else
				GUICtrlSetState($ViewStateItem, $GUI_CHECKED)
				GUICtrlSetState($ViewColorMenu, $GUI_ENABLE)
			EndIf
			
		Case $SetDefClrItem
			SetCheckedItem($SetDefClrItem)
			SetDefaultMenuColors()
			
		Case $SetRedClrItem
			SetCheckedItem($SetRedClrItem)
			SetRedMenuColors()
			
		Case $SetGrnClrItem
			SetCheckedItem($SetGrnClrItem)
			SetGreenMenuColors()
			
		Case $SetBlueClrItem
			SetCheckedItem($SetBlueClrItem)
			SetBlueMenuColors()

		Case $SetOLBlueItem
			SetCheckedItem($SetOLBlueItem)
			SetOLBlueColors()
		
		Case $SetOLSlvItem
			SetCheckedItem($SetOLSlvItem)
			SetOLSilverColors()
		 Case $TraySettings
			Settings_window()
		Case $TrayHelp
			Run("Notepad.exe " & $helpFile) 	
		 Case $TrayAbout
			About_window()
		 Case $TrayHelp
			If $nTrayIcon2 = 0 Then
				$nTrayIcon2 = _TrayIconCreate("New message", "shell32.dll", -14, "MyTrayTipCallBack")
				_TrayIconSetState(-1, 5) ; Show icon and start flashing -> 1 + 4
			Else
				_TrayIconSetState($nTrayIcon2, 5) ; Show icon and start flashing -> 1 + 4
			EndIf
			
			_TrayTip($nTrayIcon2, "New message", "A new message has arrived." & @CRLF & "Please click here to read...", 15, $NIIF_INFO)							
	EndSwitch
WEnd

_TrayIconDelete($nTrayIcon1)


If $nTrayIcon2 > 0 Then _TrayIconDelete($nTrayIcon2)

Exit


Func MyTrayTipCallBack($nID, $nMsg)
	Switch $nID
		Case $nTrayIcon2
			Switch $nMsg
				Case $NIN_BALLOONUSERCLICK, $NIN_BALLOONTIMEOUT
					_TrayIconSetState($nTrayIcon2, 8) ; Stop icon flashing
					If $nMsg = $NIN_BALLOONUSERCLICK Then MsgBox(64, "Information", "This could be your message.")
					_TrayIconSetState($nTrayIcon2, 2) ; Hide icon
			EndSwitch
			
		
	EndSwitch
EndFunc


Func SetCheckedItem($DefaultItem)
	GUICtrlSetState($SetDefClrItem, $GUI_UNCHECKED)
	GUICtrlSetState($SetRedClrItem, $GUI_UNCHECKED)
	GUICtrlSetState($SetGrnClrItem, $GUI_UNCHECKED)
	GUICtrlSetState($SetBlueClrItem, $GUI_UNCHECKED)
	GUICtrlSetState($SetOLBlueItem, $GUI_UNCHECKED)
	GUICtrlSetState($SetOLSlvItem, $GUI_UNCHECKED)
	
	GUICtrlSetState($DefaultItem, $GUI_CHECKED)
EndFunc


Func SetDefaultMenuColors()
	_SetMenuBkColor(0xFFFFFF)
	_SetMenuIconBkColor(0xDBD8D8)
	_SetMenuSelectBkColor(0xD2BDB6)
	_SetMenuSelectRectColor(0x854240)
	_SetMenuSelectTextColor(0x000000)
	_SetMenuTextColor(0x000000)
EndFunc


Func SetRedMenuColors()
	_SetMenuBkColor(0xAADDFF)
	_SetMenuIconBkColor(0x5566BB)
	_SetMenuSelectBkColor(0x70A0C0)
	_SetMenuSelectRectColor(0x854240)
	_SetMenuSelectTextColor(0x000000)
	_SetMenuTextColor(0x000000)
EndFunc


Func SetGreenMenuColors()
	_SetMenuBkColor(0xAAFFAA)
	_SetMenuIconBkColor(0x66BB66)
	_SetMenuSelectBkColor(0xBBCC88)
	_SetMenuSelectRectColor(0x222277)
	_SetMenuSelectTextColor(0x770000)
	_SetMenuTextColor(0x000000)
EndFunc


Func SetBlueMenuColors()
	_SetMenuBkColor(0xFFB8B8)
	_SetMenuIconBkColor(0xBB8877)
	_SetMenuSelectBkColor(0x662222)
	_SetMenuSelectRectColor(0x4477AA)
	_SetMenuSelectTextColor(0x66FFFF)
	_SetMenuTextColor(0x000000)
EndFunc


Func SetBlueTrayColors()
	_SetTrayBkColor(0xFFD8C0)
	_SetTrayIconBkColor(0xEE8877)
	_SetTrayIconBkGrdColor(0x703330)
	_SetTraySelectBkColor(0x662222)
	_SetTraySelectRectColor(0x4477AA)
	_SetTraySelectTextColor(0x66FFFF)
	_SetTrayTextColor(0x000000)
EndFunc


Func SetOLBlueColors()
	_SetMenuBkColor(0xFFFFFF)
	_SetMenuIconBkColor(0xFFEFE3)
	_SetMenuIconBkGrdColor(0xE4AD87)
	_SetMenuSelectBkColor(0xC2EEFF)
	_SetMenuSelectRectColor(0x800000)
	_SetMenuSelectTextColor(0x000000)
	_SetMenuTextColor(0x000000)
EndFunc


Func SetOLSilverColors()
	_SetMenuBkColor(0xF9F9F9)
	_SetMenuIconBkColor(0xFDFDFD)
	_SetMenuIconBkGrdColor(0xC0A0A0)
	_SetMenuSelectBkColor(0xC2EEFF)
	_SetMenuSelectRectColor(0x800000)
	_SetMenuSelectTextColor(0x000000)
	_SetMenuTextColor(0x000000)
 EndFunc
Func Ctrl_click_word()
 If _IsPressed("01", $dll) And _IsPressed("11", $dll) Then 					; Ctrl key and Left Mouse Button  
        Sleep(25)
        MouseClick("left")													; click mouse ovet the word to select it
        Send("^c")											  				; send the selected word to clip board
		Sleep(100)
		$MousePos = MouseGetPos()											; get the mouse position for tooltip
		$recivedWord=ClipGet()
		$englishWord=StringRegExpReplace($recivedWord, '[^a-zA-Z]|\W', '')	;remove special characters from the string
		$englishWord=_Depluralize($englishWord)
		$SinhalaWords=Get_meaning($adoRs,$adoCon,$englishWord) ; get the singular word before search in the database
		$SinhalaWords=Get_meaning($adoRs,$adoCon,$englishWord)
		$SplittedWords=StringSplit($SinhalaWords," ") 						; splits words by space charactor
		If $SplittedWords[0]>12 Then										; if the length of the meaning is too much , break to two lines
		   $wordOne= _ArrayToString($SplittedWords," ", 1, 6)
		   $wordTwo= _ArrayToString($SplittedWords," ", 7, 12)
			$wordThree= _ArrayToString($SplittedWords," ", 13, $SplittedWords[0])
			ToolTip($wordOne & @CRLF & $wordTwo & @CRLF & $wordThree, $MousePos[0], $MousePos[1],$englishWord)
		 ElseIf $SplittedWords[0]>6 Then
			$wordOne= _ArrayToString($SplittedWords," ", 1, 6)
		   $wordTwo= _ArrayToString($SplittedWords," ", 7, $SplittedWords[0])
		   ToolTip($wordOne & @CRLF & $wordTwo, $MousePos[0], $MousePos[1],$englishWord)
		 Else
			ToolTip($SinhalaWords, $MousePos[0], $MousePos[1],$englishWord)
			EndIf
	 EndIf
	 If _IsPressed("01",$dll) Then ToolTip("")
	 EndFunc
	 
Func _Display_meaning()
        Sleep(25)
        Send("^c")											  				; send the selected word to clip board
		Sleep(100)
		$MousePos = MouseGetPos()											; get the mouse position for tooltip
		$recivedWord=ClipGet()
		If 0<StringInStr($recivedWord,":\") Then Return						; to exit the funcion when double click to open a folder/file
		$englishWord=StringRegExpReplace($recivedWord, '[^a-zA-Z]|\W', '')	;remove special characters from the string
		$SinhalaWords=Get_meaning($adoRs,$adoCon,$englishWord) 				; get the meaning
		$SplittedWords=StringSplit($SinhalaWords," ") 						; splits words by space charactor
		If $SplittedWords[0]>12 Then										; if the length of the meaning is too much , break to two lines
		   $wordOne= _ArrayToString($SplittedWords," ", 1, 6)
		   $wordTwo= _ArrayToString($SplittedWords," ", 7, 12)
			$wordThree= _ArrayToString($SplittedWords," ", 13, $SplittedWords[0])
			ToolTip($wordOne & @CRLF & $wordTwo & @CRLF & $wordThree, $MousePos[0], $MousePos[1],$englishWord)
		 ElseIf $SplittedWords[0]>6 Then
			$wordOne= _ArrayToString($SplittedWords," ", 1, 6)
		   $wordTwo= _ArrayToString($SplittedWords," ", 7, $SplittedWords[0])
		   ToolTip($wordOne & @CRLF & $wordTwo, $MousePos[0], $MousePos[1],$englishWord)
		 Else
			ToolTip($SinhalaWords, $MousePos[0], $MousePos[1],$englishWord)
			EndIf
		 EndFunc
		 
Func _DblClk_Event($iEvent)
	Switch $iEvent
		Case $MOUSE_PRIMARYDBLCLK_EVENT
			$iPrimary_DblClk_Event = 1
	EndSwitch
EndFunc

Func Get_meaning($adoRs1, $adoCon1, $word1)
    Local $word
    Local $query = "select Sinhala from words where English = " & _String_Escape($word1)
    $adoRs1.Open($query, $adoCon1)
    If Not $adoRs1.EOF Then
        $word = $adoRs1.Fields(0).Value
		$adoRs1.Close
       
	Else
	   $adoRs1.Close
		$word1=_Depluralize($word1)   ; get the singular word before search in the database
		$query = "select Sinhala from words where English = " & _String_Escape($word1)
		 $adoRs1.Open($query, $adoCon1)
		 If  Not $adoRs1.EOF Then
			$word = $adoRs1.Fields(0).Value
			$adoRs1.Close
		 Else
		 $adoRs1.Close
		 EndIf
		 
		 
        
	 EndIf
	   
    Return $word
 EndFunc   ;==>Get_meaning
 Func _String_Escape($sString)
    If IsNumber($sString) Then $sString = String($sString) ; don't raise error if passing a numeric parameter
    If Not IsString($sString) Then Return SetError(1, 0, "")
    Return ("'" & StringReplace($sString, "'", "''", 0, 1) & "'")
EndFunc   ;==>_String_Escape

Func _Depluralize($word)
   Local $rule[8]=["ss","os","ies","xes","oes","ies","ves","s"]
   Local $replacement[8]=["ss","o","y","x","o","y","f",""]
   For $i=0 To 7 Step 1
		 ;If the end of the word doesn't match the rule[i],
		 ;it's not a candidate for replacement. Move on
		 ;to the next plural ending. 
        If(StringInStr($word,$rule[$i],0,-1)-1<>StringLen($word)-StringLen($rule[$i]) )Then 
            ContinueLoop;
			EndIf
		 ;If the value of the word is ss, stop looping
		 ;and return the original version of the word. 
        If(StringInStr($word,$rule[0],0,-1)-1=StringLen($word)-StringLen($rule[0])) Then
            return $word;
			EndIf
		 ;We've made it this far, so we can do the
		 ;replacement. 
        return StringReplace($word,$rule[$i],$replacement[$i],-1) 
   Next
	 return $word
	
EndFunc

DllClose($dll)