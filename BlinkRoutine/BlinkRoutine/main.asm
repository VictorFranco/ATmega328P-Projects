;
; BlinkRoutine.asm
;
; Created: 2/10/2023 7:24:15 PM
; Author : vfran
;


START:
    LDI     R16, 0x01
    OUT     DDRB, R16

LOOP:
    LDI     R16, 0x01
    OUT     PORTB, R16  ; turn the LED on
    RCALL   DELAY_1S    ; wait a second
    LDI     R16, 0x00
    OUT     PORTB, R16  ; turn the LED off
    RCALL   DELAY_1S    ; wait a second
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
