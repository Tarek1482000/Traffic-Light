;
; Traffic Light.asm
; Description:
;             Two 7-seg and traffic light and pedestrain traffic light for two streets
; Created: 02-Dec-22 9:10:29 PM
; Author : Tarek
;



    ;Status checker registers mode
    ldi r30,0x00   ; Check1 for modes
	ldi r31,0xFF   ; Check2 for modes

L6:                 ;To set registers and mode
    com r31         ;Complement Checker
    ldi r29,0x8C    ;Mode1 For PORTD Leds  10001100
    cpse r30,r31    ;Compare two regesters values to choose mode   
	ldi r29,0x51    ;Mode2 For PORTD Leds PORTD   01010001
    ldi r17,0xFF    ;To set port direction output
	out DDRA,r17    ;Set porta output port
	ldi r23,0X20    ;To start second 7-seg With 2
	ldi r28,0X03    ;For waiting mode (Led yellow)
	out DDRD,r17    ;Set portd output port

L3:                 ;Set Second digit on 7-seg
                   
    ldi r23,0X20   ;0x0010 0000	    
    ldi r24,0X00   ;0x0000 0000

start:              ;7-seg first digit
     
    sub r23,r24     ;Value  of second 7-seg 
    out PORTA,r23   ;Output of second 7-seg 
	out PORTD,r29   ;Output Leds mode in portd
    ldi r22,0x04    ;Initial value of first digit in 7-seg
    ldi r21,0x05    ;For counter
	sbis PINA,5     ;For skip next instruction if Second digit on 7-seg is 2
	ldi r22,0x09    ;To dicrement after 20
	sbis PINA,5     ;For skip next instruction if Second digit on 7-seg is 2
	ldi r21,10       ;For counter
	cpi r23,-16     ;Compare to reset Second digit on 7-seg if = -16
	breq L3
	
start2:            ;7-seg first digit  
 
    ldi r24,0x10   ;To decrement Second digit on 7-seg
    or r22,r23     ;To view full number in porta 
	cpi r22,0x03   ;Compare value of 7-seg with 3
	breq L5        ;If value of 7-seg = 3 go to L5
	out PORTA,r22  ;7-seg value 
	call delay_1sec;Delay 1 second
	dec r22        ;Decrement value of 7-seg
	dec r21        ;Decrement counter of 7-seg
	brne start2    ;while counter not equal zero
	breq start     ;Go to start if counter equal zero

    
	L5:                 ;Waiting Mode
	out PORTA,r28       ;View 3 on 7-seg
	ldi r29,0x8A        ;PORTD   10001010
	cpse r30,r31        ;Choose Leds Mode
	ldi r29,0x31        ;PORTD    
	out PORTD,r29       ;Output mode on porta
	call delay_1sec     ;Delay 1 second
    dec r28             ;counter of 7-seg 
	brne L5             ;While 7-seg value not equzl zero
	breq L6             ;Change mode


	; 1 second at 8mhz routine
	delay_1sec:
	ldi  r18, 41
    ldi  r19, 150
    ldi  r20, 128
L1: dec  r20
    brne L1
    dec  r19
    brne L1
    dec  r18
    brne L1
	ret