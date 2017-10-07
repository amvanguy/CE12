;Amanda Nguyen (amvanguy@ucsc.edu)
;CMPE 12/L
;Lab 4: Caesar Cipher 
;Section: A
;Section TA: Ethan
;Due: 05/21/2017 

	.ORIG x3000

	AND 	R0, R0, 0	;initialize all registers 
	AND 	R1, R1, 0
	AND 	R2, R2, 0
	AND 	R3, R3, 0
	AND 	R4, R4, 0
	AND 	R5, R5, 0
	AND 	R6, R6, 0
	AND 	R7, R7, 0

;-----------------------------------------------------------------------

	ASK_USER .STRINGZ "\nDo you want to (E)ncrypt or (D)ecrypt or e(X)it?\n>"
	WELCOME	.STRINGZ "Hello, welcome to my Caesar Cipher program!"
	
	LEA 	R0, WELCOME	;writes out welcome message 
	PUTS

	START_PROG

	LEA 	R0, ASK_USER	;asks user for encrypt or decrypt
	PUTS

	GETC
	OUT

;-----------------------------------------------------------------------


	;if X

	LD 	R4, EIGHTY8	
	ADD	R5, R0, R4
	BRz	BYE


	;if E

	LD	R4, SIXTY9
	ADD	R5, R0, R4
	BRz	ENCRYPT_IT

	;if D

	LD	R4, SIXTY8
	ADD	R5, R0, R4
	BRz 	DECRYPT_IT

;-------------------------------------------------------------------------

	ENCRYPT_IT

	AND	R3, R3, 0
	ST	R3, FLAG
	BRnzp 	ASK_CIPHER

	DECRYPT_IT 

	AND	R3, R3, 0
	ADD	R3, R3, 1
	ST	R3, FLAG
	BRnzp	ASK_CIPHER

	PRINT_MESSAGE 	.STRINGZ "Here is your string and the decrypted result"

;--------------------------------------------------------------------------
	CIPHER 		.STRINGZ "\nWhat is the cipher (1-25)?\n>"	
	ASK_CIPHER

	LEA 	R0, CIPHER
	PUTS


	AND	R1, R1, 0
	AND 	R5, R5, 0	
	AND 	R6, R6, 0	;updated digit
	AND	R3, R3, 0	;previous digit


	USERIN

	GETC
	OUT

	ADD 	R6, R0, -10	;when user presses ENTER -> ASK_STRING
	BRz 	ASK_STRING

	AND	R5, R5, 0
	LD 	R5, FORTY8 	;-48

	ADD	R6, R0, R5	;R6 = R0 - 48 -> turns into digit
	AND	R5, R5, 0	;recycle R5
	ADD	R5, R5, 10	;multiplication counter

	START	BRz 	END
		ADD 	R3, R3, R1
		ADD 	R5, R5, -1	
		BRnzp 	START
	END
		ADD 	R1, R3, R6
		ST 	R1, CIPHER_NUM

	BRnzp 	USERIN


;--------------------------------------------------------------------------
	STRING 		.STRINGZ "What is the string (up to 200 characters)?\n>"
	ASK_STRING

	AND	R1, R1, 0	;initialize row
	AND 	R2, R2, 0 	;initialize column
	
	
	LEA 	R0, STRING
	PUTS

	;LEA	R2, CIPHER_ARRAY
	;ST	R2, CIPHER_ARRAY_ADD

	COLUMN_LOOP

	GETC	
	OUT
	
	ADD 	R4, R0, -10	;when user presses ENTER, stop store/encrypt
	BRz	PRINT_RESULT	;(PRINT_RESULT)

	AND 	R1, R1, 0	;store user_input in row 0
	
	JSR	STORE

	LD	R3, FLAG	;encrypt or decrypt 
	ADD	R3, R3, 0
	BRz	ENCRYPT_RESULT
	BRnp	DECRYPT_RESULT

;--------------------------------------------------------------------------

	ENCRYPT_RESULT

	JSR 	ENCRYPT

	AND	R1, R1, 0	;store encryption
	ADD	R1, R1, 1

	JSR	STORE

	ADD	R2, R2, 1	;move to next column
	ST	R2, PRINT_COUNTER
	BRnzp 	COLUMN_LOOP


;-----------------------------------------------------------------------

	DECRYPT_RESULT

	JSR	DECRYPT

	AND	R1, R1, 0	;store encryption
	ADD	R1, R1, 1

	JSR	STORE

	ADD	R2, R2, 1	;move to next column
	ST	R2, PRINT_COUNTER
	BRnzp 	COLUMN_LOOP


;-----------------------------------------------------------------------
	ENCRYPT_LAB	.STRINGZ "\n<Encrypted>:"
	DECRYPT_LAB	.STRINGZ "\n<Decrypted>:"

	PRINT_RESULT

	AND	R1, R1, 0
	AND	R2, R2, 0

	LEA	R0, PRINT_MESSAGE
	PUTS
	
	JSR	PRINT_ARRAY

	BRnzp	START_PROG
	
;-----------------------------------------------------------------------

	GOODBYE		.STRINGZ "\nGoodbye!"

	BYE

	LEA R0, GOODBYE
	PUTS
	HALT

;------------------------------------------------------------------------

	;VARIABLES 

	EIGHTY8		.FILL xFFA8	;-88
	SIXTY9		.FILL xFFBB	;-69
	SIXTY8		.FILL xFFBC	;-68
	FORTY8		.FILL -48
	SIXTY5		.FILL -65
	NINETY		.FILL -90
	NINETY7		.FILL -97
	HUNDRED22	.FILL -122
	
	FLAG		.FILL 0
	CIPHER_NUM	.FILL 0
	CHARACTER	.FILL 0
	ROW		.FILL 0
	COLUMN		.FILL 0
	HELPER_VAR	.FILL 0
	PLAINTEXT_CHAR	.FILL 0
	COUNTER		.FILL 0
	ENCRYPTED_CHAR 	.FILL 0
	DECRYPTED_CHAR	.FILL 0
	HELPER_VAR_2	.FILL 0
	PRINT_COUNTER	.FILL 0 
	PRINT_1 	.FILL 0
	PRINT_2 	.FILL 0
	PRINT_3		.FILL 0
	CIPHER_ARRAY_ADD .FILL 0
	NEXT		.FILL 0 
	NEG_CIPHER_NUM	.FILL 0

;-----------------------------------------------------------------------
;			STORE SUBROUTINE
; Inputs: 
;	R0 = ASCII char to store 
;	R1 = row of cipher_array
;	R2 = column of cipher_array 
;
; Outputs: none 
; 
;-----------------------------------------------------------------------

	STORE


	ST 	R0, CHARACTER
	ST 	R1, ROW
	ST 	R2, COLUMN

	ADD 	R1, R1, 0	;checks if row is 0 or 1
	BRz 	ROW_0
	BRnp 	ROW_1

	ROW_0
	
	LEA	R1, CIPHER_ARRAY
	ST	R1, CIPHER_ARRAY_ADD
	ADD	R2, R2, R1
	STR 	R0, R2, 0 
	BRnzp 	SKIP_STORE

	ROW_1

	LEA	R1, CIPHER_ARRAY
	ADD 	R2, R2, 15
	ADD 	R2, R2, 15
	ADD 	R2, R2, 15
	ADD 	R2, R2, 5
	ADD	R2, R2, R1
	STR 	R0, R2, 0

	SKIP_STORE 

	LD 	R0, CHARACTER
	LD 	R1, ROW
	LD 	R2, COLUMN

	RET

;----------------------END OF STORE SUBROUTINE--------------------------
;
;			   LOAD SUBROUTINE
; Inputs:  
;	R1 = row of cipher_array
;	R2 = column of cipher_array 	 
;
; Outputs: 
;	R0 = contents of cipher_array[R1,R2] 
;-----------------------------------------------------------------------

	LOAD

	ST 	R0, CHARACTER
	ST 	R1, ROW
	ST 	R2, COLUMN


	ADD 	R1, R1, 0	;checks if row is 0 or 1
	BRz 	ROW_0_LD
	BRnp 	ROW_1_LD

	ROW_0_LD
	
	LD	R1, CIPHER_ARRAY_ADD
	ADD	R2, R2, R1
	LDR 	R0, R2, 0
	BRnzp 	SKIP_LD

	ROW_1_LD

	LD	R1, CIPHER_ARRAY_ADD
	ADD 	R2, R2, 15
	ADD 	R2, R2, 15
	ADD 	R2, R2, 15
	ADD 	R2, R2, 5
	ADD	R2, R2, R1
	LDR 	R0, R2, 0

	SKIP_LD

	;LD 	R0, CHARACTER
	LD 	R1, ROW
	LD 	R2, COLUMN

	RET

;----------------------END OF LOAD SUBROUTINE--------------------------
;
;			PRINT_ARRAY SUBROUTINE
; Inputs: none 
;
; Outputs: none 
;
;------------------------------------------------------------------------

	PRINT_ARRAY

	ST	R3, PRINT_1	;store registers, call-safe 
	ST	R2, PRINT_2
	ST 	R0, PRINT_3
	ST	R7, NEXT

	LD	R3, FLAG	;encrypt or decrypt 
	ADD	R3, R3, 0
	BRz	ENCRYPTING
	BRnp	DECRYPTING

;------------------------------------------------------------------------

	ENCRYPTING

	LEA	R0, DECRYPT_LAB		;print decrypt
	PUTS

	AND 	R1, R1, 0 
	AND	R2, R2, 0	
	LD	R3, PRINT_COUNTER

	ROW0_LOOP			;print row0

	JSR	LOAD
	OUT				
	ADD	R2, R2, 1
	ADD	R3, R3, -1
	BRp	ROW0_LOOP
	
	LEA	R0, ENCRYPT_LAB		;print encrypt
	PUTS

	AND	R1, R1, 0
	ADD	R1, R1, 1
	AND 	R2, R2, 0
	LD	R3, PRINT_COUNTER
 
	ROW1_LOOP 			;print row1

	JSR 	LOAD
	OUT
	ADD	R2, R2, 1
	ADD	R3, R3, -1
	BRp	ROW1_LOOP
	BRnz	END_PRINT

	
;----------------------------------------------------------------------
	
	DECRYPTING

	LEA	R0, ENCRYPT_LAB		;print encrypt
	PUTS
	
	AND 	R1, R1, 0 
	AND	R2, R2, 0	
	LD	R3, PRINT_COUNTER

	ROW0_LOOP_DE			;print row0

	JSR	LOAD
	OUT				
	ADD	R2, R2, 1
	ADD	R3, R3, -1
	BRp	ROW0_LOOP_DE
	
	LEA	R0, DECRYPT_LAB		;print decrypt
	PUTS

	AND	R1, R1, 0
	ADD	R1, R1, 1
	AND 	R2, R2, 0
	LD	R3, PRINT_COUNTER
 
	ROW1_LOOP_DE 			;print row1

	JSR 	LOAD
	OUT
	ADD	R2, R2, 1
	ADD	R3, R3, -1
	BRp	ROW1_LOOP_DE
	BRnz	END_PRINT

;------------------------------------------------------------------------

	END_PRINT

	LD	R3, PRINT_1	;load registers, call-safe 
	LD	R2, PRINT_2
	LD 	R0, PRINT_3
	LD	R7, NEXT 

	RET

;---------------------END OF PRINT_ARRAY SUBROUTINE-----------------------
;			
;			ENCRYPT SUBROUTINE
; Inputs:  
;	R0 = character to encrypt 
;	R1 = number from 1-25 to shift R0 (right) 
;
; Outputs: 
;	R0 = encrypted (input) character 
;-----------------------------------------------------------------------

	ENCRYPT

	ST 	R0, PLAINTEXT_CHAR
	ST	R4, HELPER_VAR
	ST	R5, HELPER_VAR_2


;---------------------------------------------------------------------------

	;UPPERCASE LETTER

	LD	R4, SIXTY5		;if ascii char is 65 or above 
	ADD	R5, R0, R4
	BRn 	END_ENCRYPT		;else, return same value 

	LD	R0, PLAINTEXT_CHAR	;reload plaintext_char to R0
	
	LD	R4, NINETY		;if ascii char is between 65 and 90
	ADD	R5, R0, R4
	BRp	CHECK_LOWERCASE		;else, return same value 

	LD	R0, PLAINTEXT_CHAR	;loads plaintext_char
	LD 	R1, CIPHER_NUM		;loads key 

	ADD 	R0, R0, R1		;encrypt_char = plaintext_char + key
	ST 	R0, ENCRYPTED_CHAR	;store encrypted_char

	LD	R4, SIXTY5		;if ascii char is above 65 
	LD	R0, ENCRYPTED_CHAR
	ADD	R5, R0, R4
	BRn	LOOP_OFFSET

	LD	R0, ENCRYPTED_CHAR	;reload encrypted_char to R0

	LD	R4, NINETY		;if ascii char is between 65 and 90
	ADD	R5, R0, R4
	BRp	LOOP_OFFSET		;else, return same value
	BRnz	RELOAD_ENCRYPT  

	CHECK_LOWERCASE

	LD	R0, PLAINTEXT_CHAR
	
	LD	R4, NINETY7
	ADD	R5, R0, R4
	BRn	END_ENCRYPT

	LD	R0, PLAINTEXT_CHAR
	
	LD	R4, HUNDRED22
	ADD	R5, R0, R4
	BRp	END_ENCRYPT

	LD	R0, PLAINTEXT_CHAR	;loads plaintext_char
	LD 	R1, CIPHER_NUM		;loads key 

	ADD 	R0, R0, R1		;encrypt_char = plaintext_char + key
	ST 	R0, ENCRYPTED_CHAR	;store encrypted_char

	LD	R4, NINETY7
	LD	R0, ENCRYPTED_CHAR
	ADD	R5, R0, R4
	BRn	LOOP_OFFSET

	LD	R0, ENCRYPTED_CHAR
	
	LD	R4, HUNDRED22
	ADD	R5, R0, R4
	BRp	LOOP_OFFSET
	BRnz	RELOAD_ENCRYPT

;---------------------------------------------------------------------------
	
	LOOP_OFFSET

	LD 	R0, PLAINTEXT_CHAR
	ADD 	R0, R0, -15		;-26 offset 
	ADD 	R0, R0, -11
	ADD 	R0, R0, R1		;adds key to value
	BRnzp	END_ENCRYPT

;--------------------------------------------------------------------------

	RELOAD_ENCRYPT

	LD	R0, ENCRYPTED_CHAR

;----------------------------------------------------------------------------
	
	END_ENCRYPT
	
	LD	R4, HELPER_VAR
	LD	R5, HELPER_VAR_2

	RET

;---------------------END OF ENCRYPT SUBROUTINE---------------------------
;			
;			DECRYPT SUBROUTINE
; Inputs:  
;	R0 = character to encrypt 
;	R1 = number from 1-25 to shift R0 (left 
;
; Outputs: 
;	R0 = encrypted (input) character 
;-----------------------------------------------------------------------

	DECRYPT

	ST 	R0, PLAINTEXT_CHAR
	ST	R4, HELPER_VAR
	ST	R5, HELPER_VAR_2

;---------------------------------------------------------------------------

	;NEG_KEY

	LD	R1, CIPHER_NUM		;sets key to negative 
	NOT	R1, R1
	ADD	R1, R1, 1
	ST	R1, NEG_CIPHER_NUM
	
	;UPPERCASE LETTER

	LD	R4, SIXTY5		;if ascii char is 65 or above 
	ADD	R5, R0, R4
	BRn 	END_DECRYPT		;else, return same value 

	LD	R0, PLAINTEXT_CHAR	;reload plaintext_char to R0
	
	LD	R4, NINETY		;if ascii char is between 65 and 90
	ADD	R5, R0, R4
	BRp	CHECK_LOWERCASE_DE	;else, return same value 

	LD	R0, PLAINTEXT_CHAR	;loads plaintext_char
	LD 	R1, NEG_CIPHER_NUM	;loads key 

	ADD 	R0, R0, R1		;encrypt_char = plaintext_char + key
	ST 	R0, DECRYPTED_CHAR	;store encrypted_char

	LD	R4, SIXTY5		;if ascii char is above 65 
	LD	R0, DECRYPTED_CHAR
	ADD	R5, R0, R4
	BRn	LOOP_OFFSET_DE

	LD	R0, DECRYPTED_CHAR	;reload encrypted_char to R0

	LD	R4, NINETY		;if ascii char is between 65 and 90
	ADD	R5, R0, R4
	BRp	LOOP_OFFSET_DE		;else, return same value
	BRnz	RELOAD_DECRYPT  

	CHECK_LOWERCASE_DE

	LD	R0, PLAINTEXT_CHAR
	
	LD	R4, NINETY7
	ADD	R5, R0, R4
	BRn	END_DECRYPT

	LD	R0, PLAINTEXT_CHAR
	
	LD	R4, HUNDRED22
	ADD	R5, R0, R4
	BRp	END_DECRYPT

	LD	R0, PLAINTEXT_CHAR	;loads plaintext_char
	LD 	R1, NEG_CIPHER_NUM	;loads key 

	ADD 	R0, R0, R1		;encrypt_char = plaintext_char + key
	ST 	R0, DECRYPTED_CHAR	;store encrypted_char

	LD	R4, NINETY7
	LD	R0, DECRYPTED_CHAR
	ADD	R5, R0, R4
	BRn	LOOP_OFFSET_DE

	LD	R0, DECRYPTED_CHAR
	
	LD	R4, HUNDRED22
	ADD	R5, R0, R4
	BRp	LOOP_OFFSET_DE
	BRnz	RELOAD_DECRYPT

;---------------------------------------------------------------------------
	
	LOOP_OFFSET_DE

	LD 	R0, PLAINTEXT_CHAR
	ADD 	R0, R0, 15		;+26 offset 
	ADD 	R0, R0, 11
	ADD 	R0, R0, R1		;adds key to value
	BRnzp	END_DECRYPT

;--------------------------------------------------------------------------

	RELOAD_DECRYPT

	LD	R0, DECRYPTED_CHAR

;----------------------------------------------------------------------------
	
	END_DECRYPT
	
	LD	R4, HELPER_VAR
	LD	R5, HELPER_VAR_2

	RET


;---------------------END OF DECRYPT SUBROUTINE------------------------------
	
	
	CIPHER_ARRAY	.BLKW 100
	
		
;--------------------------------------------------------------------------


	.END


	