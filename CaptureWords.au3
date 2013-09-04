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
Local $dbname=@ScriptDir & "\EnglishSinhala.accdb" ; database must be there in the same folder with the script
$adoCon = ObjCreate("ADODB.Connection")
;$adoCon.Open("Driver={Microsoft Access Driver (*.mdb)}; DBQ=" & $dbname) ;Use this line if using MS Access 2003 and lower
$adoCon.Open("Driver={Microsoft Access Driver (*.mdb, *.accdb)}; DBQ=" & $dbname & ";Uid=;Pwd=;") ;Use this line if using MS Access 2007 and using the .accdb file extension
$adoRs = ObjCreate("ADODB.Recordset")
$adoRs.CursorType = 1
$adoRs.LockType = 3
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
		$recivedWord=ClipGet()
		$englishWord=StringRegExpReplace($recivedWord, '[^a-zA-Z]|\W', '')			;remove special characters from the string
		ToolTip(Get_meaning($adoRs,$adoCon,$englishWord), $MousePos[0], $MousePos[1],$englishWord)
EndIf
EndFunc
Func Get_meaning($adoRs1,$adoCon1,$word1)
$query = "select Sinhala from words where English='"&$word1&"'"
$adoRs1.Open($query, $adoCon1)
;MsgBox(0, "Result", $adoRs.Fields( "Sinhala" ).Value)
$word=$adoRs1.Fields("Sinhala").Value
$adoRs1.Close 
;$adoCon1.Close ; ==> Close the database
return $word
EndFunc

DllClose($dll)


