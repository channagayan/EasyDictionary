#include <GUIConstantsEx.au3>
 
 Global $hButton3 = 9999
 Global $hGUI2
 
 Func About_window()   ; include settings window ini file writing operations here................................
	  gui3()
     While 1
		
         Switch GUIGetMsg()
             Case $GUI_EVENT_CLOSE
				  GUIDelete($hGUI2)
				  Return
             Case $hButton3
                 MsgBox("", "MsgBox 3", "Test from Gui 3") 
         EndSwitch
     WEnd
 EndFunc   ;==>About_window
 
 Func gui3()
     $hGUI2 = GUICreate("About", 200, 200, 350, 350)
     $hButton3 = GUICtrlCreateButton("MsgBox 3", 10, 10, 80, 30)
     GUISetState()
 EndFunc   ;==>gui3