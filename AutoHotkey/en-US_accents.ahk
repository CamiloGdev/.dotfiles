#NoTrayIcon

; Modificadores
; ^ Ctrl
; ! Alt
; + Shift
; # Win

; Vocales minúsculas y ñ
!a:: Send "á"    ; Alt+a = á
!e:: Send "é"    ; Alt+e = é
!i:: Send "í"    ; Alt+i = í
!o:: Send "ó"    ; Alt+o = ó
!u:: Send "ú"    ; Alt+u = ú

; Mapeo de letra ñ con Alt+n
!n:: Send "ñ"    ; Alt+n = ñ
!+n::Send "Ñ"    ; Shift+Alt+n -> Ñ


; Símbolos
!/:: Send "{¿}{?}{Left 1}"    ; Alt+/ = ¿?
!1:: Send "{¡}{!}{Left 1}"    ; Alt+1 = ¡!

;-----------------------------------
;Mapeo opcional de la ñ con la tecla de [;:]
; Este mapeo permite escribir la ñ con la tecla de [;:] y reubica los símbolos ; y : a las teclas de , y .

; Remapeo de ; y :
; +,:: Send ";"    ; Shift+, = ;
; +.:: Send ":"    ; Shift+. = :
; !,:: Send "{Text}<"    ; Alt+, = <
; !.:: Send "{Text}>"    ; Alt+. = >

; Mapeo de letra ñ con en la tecla de [;:]
; SC027:: Send "ñ"    ; Mapeo de tecla ; a ñ
; +SC027:: Send "Ñ"   ; Shift + ; = Ñ
