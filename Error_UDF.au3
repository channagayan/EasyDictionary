

;----------------------------------------------------------------------------------------------------------
; Com Error Handler
;----------------------------------------------------------------------------------------------------------
 Func MyErrFunc($oMyError)
Local $HexNumber
Local $strMsg

$HexNumber = Hex($oMyError.Number, 8) 
$strMsg = "Error Number: " & $HexNumber & @CRLF 
$strMsg &= "WinDescription: " & $oMyError.WinDescription & @CRLF 
$strMsg &= "Script Line: " & $oMyError.ScriptLine & @CRLF 
MsgBox(0, "EasyDictionary Error", "Word cannot be recognized or some other error occured") ;use $strMsg to display error details. 
SetError(1)
Endfunc 