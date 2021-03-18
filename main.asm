;Date: 5/25/2020
;Authors: Kevin Morales, Devon Hood, Mico Guinto, Tyler Eastman.  
;
;This program flashes a sequence of colors on a LED light strip.  
;The color sequence and delay time can be manipulated to preference

.include "m328pdef.inc"		; include definitions for atmega328p, this makes it easier to work with I/O registers

.dseg						; data segment directive		

.def mask = r16				; define a mask register
.def ledr = r17				; define a led toggle register
.def loopct = r18			; define a register to hold arg for delay subroutine
.def threshreg = r20		; define register to hold threshhold value for sensor
.def sensorval = r21		; define register to hold sensor value

.def oLoopR = r19			; outer loop register
.def iLoopRl = r24			; inner loop register low
.def iLoopRh = r25			; inner loop register high

.equ iVal 	=  39998		; inner loop value
.equ delaytime = 100		; delay time
.equ thresh = 100			; threshhold value for sensor input

.cseg						; code segment directive

.org 0x00					; start at bottom of program memory

	ldi r22, LOW(RAMEND)	; setup stack pointer so we can call subroutines
	out SPL,r22		
	ldi r22, HIGH(RAMEND)	
	out SPH, r22
	
	clr mask				; clear the mask register
	ldi threshreg,thresh

start:

	; setup ADC register appropriately, with correct pin/bits
	;

	;in  sensorval, ADCRA	; load sensor value into sensor register
	;cp threshreg, sensorval; compare treshhold value with sensor value
	;brge After				; if threshhold is greater than sensor value, branch to after
							; otherwise fall through and blink led strip

	ldi mask, (1<<PINB0)	;load port address into mask register 
	rcall Blink				;all Blink subroutine with rcall
	
	ldi mask, (1<<PINB1)	;load port address into mask register 
	rcall Blink				;all Blink subroutine with rcall

	ldi mask, (1<<PINB2)	;load port address into mask register 
	rcall Blink				;all Blink subroutine with rcall
After:

	jmp start				; jump up to start label

Blink:
	out DDRB, mask			;set pin adressed by mask register to output
	eor ledr, mask			;toggle led register
	out PORTB, ledr			;write led register to PORTB
	ldi loopct, delaytime	;load delay subroutine argument into loopct 

delay:
	ldi	iLoopRl,LOW(iVal)	; intialize inner loop count in inner
	ldi	iLoopRh,HIGH(iVal)	; loop high and low registers

iLoop:	
	sbiw	iLoopRl,1		; decrement inner loop registers
	brne	iLoop			; branch to iLoop if iLoop registers != 0

	dec		loopCt			; decrement outer loop register
	brne	delay			; branch to oLoop if outer loop register != 0

	nop						; no operation

	ret						; return from subroutine