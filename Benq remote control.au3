#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
#include <CommMG.au3>
$destination = @ScriptDir & "\..\logo.jpg"

SplashImageOn("", $destination, 567, 451,-1,-1,1)
Sleep(3000)
SplashOff()
;-------------
If Not FileExists("portsettings.ini") Then ;если файл не существует, то
$iniFile = FileOpen ( @ScriptDir&"\portsettings.ini", 1 );создаём
 ;и пишем в него всю структуру
FileWrite ( $iniFile, "[comport]"&@CRLF&"port=1"&@CRLF&"baud=115200"& _
@CRLF&"databits=8"&@CRLF&"stopbits=1"&@CRLF&"parity=0"&@CRLF&"flowcontrol=0")
FileClose ($iniFile)
MsgBox (0, "Benq remote control", "Это первый запуск, настройте параметры COM порта в файле portsettings.ini"& _
@CRLF&"port - Номер порта"&@CRLF&"baud - Скopocть (бит/c)"&@CRLF&"databits - Биты дaнныx"&@CRLF& _
"stopbits - Стoпoвыe биты"&@CRLF&"parity - Чeтнocть"&@CRLF&"flowcontrol - Упpaвлeниe пoтoкoм")
Exit
 EndIf
;-------------
$port = IniRead (@ScriptDir&"\portsettings.ini", "comport", "port", "NotFound");Номер порта
$baud = IniRead (@ScriptDir&"\portsettings.ini", "comport", "baud", "NotFound");Скopocть (бит/c)
$databits = IniRead (@ScriptDir&"\portsettings.ini", "comport", "databits", "NotFound");Биты дaнныx
$stopbits = IniRead (@ScriptDir&"\portsettings.ini", "comport", "stopbits", "NotFound");Стoпoвыe биты
$parity = IniRead (@ScriptDir&"\portsettings.ini", "comport", "parity", "NotFound");Чeтнocть
$flowcontrol = IniRead (@ScriptDir&"\portsettings.ini", "comport", "flowcontrol", "NotFound");Упpaвлeниe пoтoкoм
$result_err = ""
$status_string = "Нет подключения"

$string_on = "*pow=on#"
$string_off = "*pow=off#"
$string_vga = "*sour=rgb#"
$string_vga2 = "*sour=rgb2#"
$string_hdmi = "*sour=hdmi#"
$string_s_video = "*sour=svid#"
$string_video = "*sour=vid#"
;-------------
 ;подключаемся к порту
$portstatus = _CommSetPort($port,$result_err,$baud,$databits,$parity,$stopbits,$flowcontrol)
If $portstatus = 1 Then ; если ответ функции 1 то всё ОК и пишем это на лейбле
$status_string = "Подключено к порту: COM"&$port
Else ; если ответ не 1 то всё плохо...
$status_string = "Ошибка подключения к порту: COM"&$port
EndIf
; ~~~~~~~~
Opt("GUIOnEventMode", 1) ;
GUICreate("Benq remote control", 608, 56)
GUICtrlCreatePic(@ScriptDir & '\Optimal.jpg', 0, 0, 608, 56)
GUICtrlSetState(-1, $GUI_DISABLE)
GUISetOnEvent($GUI_EVENT_CLOSE, "Close")
Local $CTRL_btn_Power_on = GUICtrlCreateButton("POWER ON", 14, 14, 70, 29)
Local $CTRL_btn_Power_off = GUICtrlCreateButton("POWER OFF", 99, 14, 70, 29)
Local $CTRL_btn_Vga = GUICtrlCreateButton("VGA", 184, 14, 70, 29)
Local $CTRL_btn_Vga_2 = GUICtrlCreateButton("VGA 2", 269, 14, 70, 29)
Local $CTRL_btn_Hdmi = GUICtrlCreateButton("HDMI", 354, 14, 70, 29)
Local $CTRL_btn_S_video = GUICtrlCreateButton("S-VIDEO", 439, 14, 70, 29)
Local $CTRL_btn_Video = GUICtrlCreateButton("VIDEO", 524, 14, 70, 29)
GUICtrlSetOnEvent($CTRL_btn_Power_on, "Power_on")
GUICtrlSetOnEvent($CTRL_btn_Power_off, "Power_off")
GUICtrlSetOnEvent($CTRL_btn_Vga, "Vga")
GUICtrlSetOnEvent($CTRL_btn_Vga_2, "Vga_2")
GUICtrlSetOnEvent($CTRL_btn_Hdmi, "Hdmi")
GUICtrlSetOnEvent($CTRL_btn_S_video, "S_video")
GUICtrlSetOnEvent($CTRL_btn_Video, "Video")
GUISetState(@SW_SHOW)

While 1
    $nMsg = GUIGetMsg()
Sleep(100)
WEnd

Func Power_on()
_CommSendString(Chr(13),0)
_CommSendString($string_on)
_CommSendString(Chr(13),0)
_CommSendString($string_on)
$raw=ClipGet()
EndFunc

Func Power_off()
_CommSendString(Chr(13),0)
_CommSendString($string_off)
_CommSendString(Chr(13),0)
_CommSendString($string_off)
$raw=ClipGet()
EndFunc

Func Vga()
_CommSendString(Chr(13),0)
_CommSendString($string_vga)
_CommSendString(Chr(13),0)
_CommSendString($string_vga)
$raw=ClipGet()
EndFunc

Func Vga_2()
_CommSendString(Chr(13),0)
_CommSendString($string_vga2)
_CommSendString(Chr(13),0)
_CommSendString($string_vga2)
$raw=ClipGet()
EndFunc

Func Hdmi()
_CommSendString(Chr(13),0)
_CommSendString($string_hdmi)
_CommSendString(Chr(13),0)
_CommSendString($string_hdmi)
$raw=ClipGet()
EndFunc

Func S_video()
_CommSendString(Chr(13),0)
_CommSendString($string_s_video)
_CommSendString(Chr(13),0)
_CommSendString($string_s_video)
$raw=ClipGet()
EndFunc

Func Video()
_CommSendString(Chr(13),0)
_CommSendString($string_video)
_CommSendString(Chr(13),0)
_CommSendString($string_video)
$raw=ClipGet()
EndFunc


Func Close()
	Exit
	_CommClosePort()
EndFunc