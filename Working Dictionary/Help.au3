#include <GUIConstantsEx.au3>
 
 Global $hButton3 = 9999
 Global $hGUI2
 
 Func Help_window()   ; include settings window ini file writing operations here................................
	  gui4()
     While 1
		
         Switch GUIGetMsg()
             Case $GUI_EVENT_CLOSE
				  GUIDelete($hGUI2)
				  Return
             Case $hButton3
                 MsgBox("", "MsgBox 4", "Test from Gui 4") 
         EndSwitch
     WEnd
 EndFunc   ;==>Help_window
 
 Func gui4()
     $hGUI2 = GUICreate("Help", 200, 200, 350, 350)
     $hButton3 = GUICtrlCreateButton("MsgBox 4", 10, 10, 80, 30)
     GUISetState()
 EndFunc   ;==>gui4