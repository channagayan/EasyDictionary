#include <GUIConstantsEx.au3>
 
 Global $Button_save = 9999
 Global $Button_cancel = 9999
 Global $hGUI2
 Global $Settings_file=@ScriptDir & "\Settings.ini"
 Global $Combo_click
 Global $Time
 
 Func Settings_window()   ; include settings window ini file writing operations here................................
	  Settings()
     While 1
		
         Switch GUIGetMsg()
             Case $GUI_EVENT_CLOSE
				  GUIDelete($hGUI2)
				  Return
			 Case $Button_cancel
				  GUIDelete($hGUI2)
				  Return
			   Case $Button_save
				  $Click=GUICtrlRead($Combo_click)
				  If($Click="Double Click") Then
					 $Click=0
				  Else
					 $Click=1
					 EndIf
				  $Time_limit=GUICtrlRead($Time)
				  IniWrite($Settings_file, "Settings", "Click", $Click)
				  IniWrite($Settings_file, "Settings", "Time", $Time_limit)
				  GUIDelete($hGUI2)
				  _RestartProgram()
				  Return
         EndSwitch
     WEnd
 EndFunc   ;==>Settings_window
 
 Func Settings()
	  $width=10
	  $height=10
	  $Click_value=IniRead($Settings_file, "Settings", "Click", 0)
	  If($Click_value=0) Then 
		 $Click_value="Double Click"
	  Else
		 $Click_value="Ctrl+Click"
	  EndIf
	  $Time_value=IniRead($Settings_file, "Settings", "Time", 5)
     $hGUI2 = GUICreate("Settings", 400, 300, 250, 250)
     $Button_save = GUICtrlCreateButton("Save", 150, 270, 100)
     $Button_cancel = GUICtrlCreateButton("Cancel", 280,270,100)
	 ; Create the combo
	 GUICtrlCreateLabel("Key Combination to Get Meaning", 10, 10)
	 $sList="Ctrl+Click"&"|"&"Double Click"
     $Combo_click = GUICtrlCreateCombo($Click_value, 10, 30, 200, 20)
     GUICtrlSetData($Combo_click, $sList)
	 ; Create timer
	 GUICtrlCreateLabel("Meaning Baloon Display Time", 10, 60)
	 $Time = GUICtrlCreateInput($Time_value, 10, 80,30)
	 GUICtrlCreateLabel("Seconds", 45, 85)
     GUISetState()
 EndFunc   ;==>Settings