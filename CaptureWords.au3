#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.8.1
 Author:Channa Gayan

 Script Function:
	Capture words and copy to clipboard
	display popup with captured word
	Ctrl+Click 

#ce ----------------------------------------------------------------------------

; Script Start - Add your code below here
#include <Misc.au3>
$dll = DllOpen("user32.dll")
While 1
    Sleep(25)
		Capture_word()
        #MsgBox(0, "ClipBoard", ClipGet())
    
WEnd
Func Capture_word()
 If _IsPressed("01", $dll) And _IsPressed("11", $dll) Then 	; Ctrl key and Left Mouse Button  
        Sleep(25)
        MouseClick("left")										; click mouse ovet the word to select it
        Send("^c")											  	; send the selected word to clip board
		$MousePos = MouseGetPos()								; get the mouse position for tooltip
		ToolTip(ClipGet(), $MousePos[0], $MousePos[1],"Selected word")
EndIf
EndFunc
DllClose($dll)


