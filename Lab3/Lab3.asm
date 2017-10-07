.ORIG X3000 ; starts at location 3000


;--------------------------------------------------------

INTRO 

AND R0, R0, 0 ; initializes all registers R0-R7 
AND R1, R1, 0 ; sum of userin + -ASCII
AND R2, R2, 0
AND R3, R3, 0
AND R4, R4, 0
AND R5, R5, 0
AND R6, R6, 0
AND R7, R7, 0
;--------------------------------------------------------

LEA R0, WELCOME ; stores WELCOME to R0
PUTS		; prints to console
LEA R0, DECIMAL ; stores DECIMAL to R0
PUTS		; prints to console

;--------------------------------------------------------
USERIN GETC 	; read char from console -> R0  
OUT		; write char from R0 -> console
LD R3, FORTY5	; loads FORTY5 
ADD R1, R0, R3	; R1 = R0 - R3 ------ R3 = -45 
BRz NEG_FLAG	; if value == 0, then go to NEG_FLAG 
BRnp CHECKX 	; if value =! 0, then go to CHECKX

;-------------------------------------------------------
NEG_FLAG 
ADD R2, R1, 1 ; R2 = R1 + 1 where R1=0
ST R2, FLAGHOLDER
BRnzp USERIN

;------------------------------------------------------
CHECKX
LD R3, EIGHTY8 
ADD R1, R0, R3	; R1 = R0 - R3 ------ R3 = -88
BRz EXIT	; if value == 0, then go to EXIT
BRnp LINEFEED 	; if value =! 0, then go to CHECKX
;------------------------------------------------------
EXIT LEA R0, GOODBYE	; stores GOODBYE to R0 
PUTS			; prints to console 
HALT		 	; stops before it reaches the end of program
;------------------------------------------------------
LINEFEED 
ADD R1, R0, -10 ; R1 = R0 - R3 ----- R3 = -10
BRz CHECKFLAG 
BRnp PROCESSDIGIT 
;------------------------------------------------------
PROCESSDIGIT
LD R3, FORTY8 ; load FORTY8


AND R5, R5, 0 ; updated product 

AND R6, R6, 0 ; initialize R6 
ADD R6, R6, 9 ; counter

ADD R1, R0, R3 ; R1 = R0 - R3 turns it into binary 
ADD R4, R2, 0
ADD R5, R2, 0

;------------------------------------------------------

MULTIPLY_TEN
ADD R5, R5, R4 
ADD R6, R6, -1
BRp MULTIPLY_TEN

ADD R2, R5, R1
BRnzp USERIN 
;-----------------------------------------------------
CHECKFLAG
LD R1, FLAGHOLDER
ADD R1, R1, -1 
BRz TWOCOMP
BRnp MAINMASK

;------------------------------------------------------
TWOCOMP

NOT R2, R2
ADD R2, R2, 1

BRnzp MAINMASK
;-----------------------------------------------------
MAINMASK 

ADD R5, R2, 0
AND R2, R2, 0	; counter 
ADD R2, R2, 15
AND R3, R3, 0	; pointer 

LEA R0, THANKS
PUTS 

MASK_LOOP

LEA R1, MASK_ARRAY
ADD R1, R1, R3
LDR R1, R1, 0
AND R4, R1, R5
 
BRz PRINT_ZERO
BRnzp PRINT_ONE

PRINT_ZERO
LEA R0, ZERO
PUTS
ADD R3, R3, 1
ADD R2, R2, -1
BRn INTRO
BRnp MASK_LOOP 

PRINT_ONE
LEA R0, ONE
PUTS
ADD R3, R3, 1
ADD R2, R2, -1 
BRn INTRO
BRnp MASK_LOOP 

HALT 


FORTY5 .FILL -45
EIGHTY8 .FILL -88
FORTY8 .FILL -48

MASK_ARRAY: 

.FILL b1000000000000000 
.FILL b0100000000000000 
.FILL b0010000000000000
.FILL b0001000000000000
.FILL b0000100000000000
.FILL b0000010000000000
.FILL b0000001000000000
.FILL b0000000100000000
.FILL b0000000010000000
.FILL b0000000001000000
.FILL b0000000000100000
.FILL b0000000000010000
.FILL b0000000000001000
.FILL b0000000000000100
.FILL b0000000000000010 
.FILL b0000000000000001

FLAGHOLDER .BLKW 1
ZERO .STRINGZ "0"
ONE .STRINGZ "1"
WELCOME .STRINGZ "\nWelcome to the conversion program!\n"
DECIMAL .STRINGZ "Enter a decimal number or X to quit:\n"
THANKS .STRINGZ "\nThanks, here it is in binary\n"
GOODBYE .STRINGZ "\nBye. Have a great day.\n"

.END ; end of program 

