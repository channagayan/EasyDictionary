#include <GUIConstantsEx.au3>
 
 Global $hButton3 = 9999
 Global $hGUI2
 
 Func About_window()   ; include settings window ini file writing operations here................................
	  _Splash()
 EndFunc   ;==>About_window
 
 Func _Splash()
	$destination = @scriptdir & "\Images\splash.jpg"
	  SplashImageOn("Easy Dictionary", $destination,440,286) ; set the image size for for window size
	  Sleep(3000)
	  SplashOff()
 EndFunc   ;==>gui3