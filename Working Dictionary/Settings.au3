#include <GUIConstantsEx.au3>
 
 Global $hButton3 = 9999
 Global $hGUI2
 
 Func Settings_window()   ; include settings window ini file writing operations here................................
	  gui2()
     While 1
		
         Switch GUIGetMsg()
             Case $GUI_EVENT_CLOSE
				  GUIDelete($hGUI2)
				  Return
             Case $hButton3
                 MsgBox("", "MsgBox 2", "Test from Gui 2") 
         EndSwitch
     WEnd
 EndFunc   ;==>Settings_window
 
 Func gui2()
     $hGUI2 = GUICreate("Settings", 200, 200, 350, 350)
     $hButton3 = GUICtrlCreateButton("MsgBox 2", 10, 10, 80, 30)
     GUISetState()
 EndFunc   ;==>gui2