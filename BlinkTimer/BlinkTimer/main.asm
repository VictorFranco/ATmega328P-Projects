;
; BlinkTimer.asm
;
; Created: 2/11/2023 8:00:41 AM
; Author : vfran
;

.org        0x00
    RJMP    START

.org        0x20
    RJMP    RSI_T0

START:
    SEI                     ; Set Interrupt Enable

    LDI     R16, 0x03
    OUT     TCCR0B, R16     ; prescaler divide by 64
    LDI     R16, 0x01
    STS     TIMSK0, R16     ; enable timer interrupt
    LDI     R16, 0x00
    OUT     TCNT0, R16      ; initial timer value

    LDI     R16, 0xFF
    OUT     DDRB, R16       ; config port B

    LDI     R16, 0x01       ; initial state
    CLR     R17

LOOP:
    OUT     PORTB, R16
    RJMP    LOOP

; F = 1MHz / 64 = 15625Hz
; T = 1 / 15625Hz = 64us
; Overflow = 255 * 64us = 0.01632s
; x * O = 1s => x = 1 / O = 61.27 = 0x3D
; 61 * 0.01632s = 0.9952s
RSI_T0:
    INC     R17         ; increment counter
    CPI     R17, 0x3D
    BREQ    TIMER_1S
    RETI

TIMER_1S:
    CLR     R17         ; reset counter
    CPI     R16, 0x00
    BREQ    TURN_ON
    CPI     R16, 0x01
    BREQ    TURN_OFF
    RETI

TURN_ON:
    LDI     R16, 0x01
    RETI

TURN_OFF:
    LDI     R16, 0x00
    RETI
