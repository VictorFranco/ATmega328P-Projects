;
; DisplayRutine.asm
;
; Created: 2/11/2023 1:05:00 PM
; Author : vfran
;

.org        0x00

DISPLAY:    .DB 0x3F, 0x06, 0x5B, 0x4F, 0x66, 0x6D, 0x7D, 0x07, 0x7F, 0x6F
;                0     1     2     3     4     5     6     7     8     9

START:
    LDI     R16, 0x7F
    OUT     DDRB, R16   ; configure port B
    CLR     ZL          ; load pointer address
    CLR     ZH

LOOP:
    LPM     R16, Z      ; load vector element
    OUT     PORTB, R16  ; show number
    RCALL   DELAY_1S    ; wait a second
    INC     ZL          ; point to the next vector element
    CPI     ZL, 0x0A
    BRNE    CONTINUE
    CLR     ZL          ; reset pointer address
CONTINUE:
    RJMP    LOOP

; F = 1MHz
; T = 1 / 1MHz = 1us
; 3 cycles * T * x = 1s => x = 1 / ( 3 * T ) = 333333
; 333333 / ( 256 * 256 ) = 5 = 0x05
DELAY_1S:
    PUSH    R16
    PUSH    R17     ; save values on stack
    PUSH    R18

    LDI     R16, 0x05
LOOP1_1S:
    CLR     R17
LOOP2_1S:
    CLR     R18
LOOP3_1S:
    DEC     R18     ; 2 cycles
    BRNE    LOOP3_1S; 1 cycle

    DEC     R17
    BRNE    LOOP2_1S

    DEC     R16
    BRNE    LOOP1_1S

    POP     R18
    POP     R17     ; restore values
    POP     R16
    RET
