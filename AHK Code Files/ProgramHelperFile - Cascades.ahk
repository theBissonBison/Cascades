#NoEnv
SetWorkingDir %A_ScriptDir%
#singleinstance force
EnvGet, LocalAppData, LocalAppData
IniWrite, 1, %LocalAppData%\Cascades\ini\2.ini, section1, HelperScript ;upgrade to use OnMessage()
run, explorer "Cascades.exe"
exitapp