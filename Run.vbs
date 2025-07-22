Set WshShell = CreateObject("WScript.Shell")
batchName = "V9Robust.bat" 
vbsPath = WScript.ScriptFullName 
folderPath = Left(vbsPath, InStrRev(vbsPath, "\")) 
batchPath = folderPath & batchName 

' Get drive letter input from user
driveLetter = InputBox("(just the letter, no colon):", "Update System")

If driveLetter <> "" Then
    ' Remove any colon if user included it
    driveLetter = Replace(driveLetter, ":", "")
    
    ' Run batch file hidden with drive letter as argument
    WshShell.Run "cmd /c """ & batchPath & """ " & driveLetter, 0, False
Else
    MsgBox "No drive letter entered. Script will exit.", vbExclamation, "Error"
End If

Set WshShell = Nothing