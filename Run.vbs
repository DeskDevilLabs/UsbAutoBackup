Set WshShell = CreateObject("WScript.Shell")
batchName = "Robustv1.bat" 
vbsPath = WScript.ScriptFullName 
folderPath = Left(vbsPath, InStrRev(vbsPath, "\")) 
batchPath = folderPath & batchName 

' Run batch file hidden
WshShell.Run "cmd /c """ & batchPath & """", 0, False
Set WshShell = Nothing