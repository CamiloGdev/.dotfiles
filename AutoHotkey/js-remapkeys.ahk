!+7::Send "&&="                             ; Shift+Alt+7   &&=         AND Assignment
!+\::Send "||="                             ; Shift+Alt+\   ||=         OR Assignment
!+/::Send "??="                             ; Shift+Alt+/   ??=         Nullish Coalescing Assignment

!9::Send "=>"                               ; Alt+9         =>          Arrow
!+9::Send "() => "                          ; Shift+Alt+9   () =>       Arrow Function, implicit return
!^9::Send "() => {U+007B}"                  ; Ctrl+Alt+9    () => {}    Arrow Function, explicit return

!=::Send "==="                              ; Alt+=         ===         Strict Equality
!+=::SendText "!=="                         ; Shift+Alt+=   !==         Strict Inequality

!^,::Send "</>"                             ; Ctrl+Alt+,    </>         React Component Tag
!^.::Send "</>"                             ; Ctrl+Alt+.    </>         React Component Tag
!+,::Send "<="                              ; Shift+Alt+,   <=          Less than or equal to
!+.::Send ">="                              ; Shift+Alt+.   >=          Greater than or equal to

; Comentado
; !/::Send "??"                            ; Alt+/         ??          Nullish Coalescing
; !,::Send "</>"                           ; Alt+,         </>         HTML Close Tag
; !.::Send "?."                            ; Alt+.         ?.          Optional Chaining
; !+;::Send "?:"                           ; Shift+Alt+;   ?:          Ternary Operator
; !+/::Send "??"                           ; Shift+Alt+/   ??          Nullish Coalescing
; !\::Send "||"                               ; Alt+\         ||          Logical OR
; !7::Send "&&"                               ; Alt+7         &&          Logical AND
; !8::Send "**"                               ; Alt+8         **          Math Power

