; COMP15111 lab 4 - Template file

print_char	equ	0		; Define names to aid readability
stop		equ	2
print_str	equ	3
print_no	equ	4

cLF		equ	10		; Line-feed character


		ADR	SP, _stack	; set SP pointing to the end of our stack
		B	main

		DEFS	100		; this chunk of memory is for the stack
_stack					; This label is 'just after' the stack space

temp DEFW 0
wasborn		DEFB	"This person was born on ",0
was		DEFB	"This person was ",0
on		DEFB	" on ",0
is		DEFB	"This person is ",0
today		DEFB	" today!",0
willbe		DEFB	"This person will be ",0
		ALIGN

pDay		  DEFW	23		;  pDay = 23    //or whatever is today's date
pMonth		DEFW	11		;  pMonth = 11  //or whatever is this month
pYear		  DEFW	2005	;  pYear = 2005 //or whatever is this year


; def printAgeHistory (bDay, bMonth, bYear)

; parameters
;  R0 = bDay (on entry, moved to R6 to allow SVC to output via R0)
;  R1 = bMonth
;  R2 = bYear
; local variables (callee-saved registers)
;  R4 = year
;  R5 = age
;  R6 = bDay - originally R0

printsthedate
        MOV	R0, R4
		SVC	print_no
		MOV	R0, #'/'
		SVC	print_char
		MOV	R0, R5
		SVC	print_no
		MOV	R0, #'/'
		SVC	print_char
		MOV	R0, R6
		SVC	print_no
		MOV	R0, #cLF
		SVC	print_char
        
        MOV PC, LR


printAgeHistory	;PUSH	{R6}			; callee saves three registers
		;PUSH	{R5}
		;PUSH	{R4}
        
        ;LDMFD SP!, {R2}
        ;LDMFD SP!, {R1}
        ;LDMFD SP!, {R6}
		;LDR	R6, R7	; Get parameters from stack : pDay +20 R4
		;LDR	R1, R8 ;pMon +16 R5
		;LDR	R2, R9 ;2000 +12 R6

;   year = bYear + 1
		;ADD	R4, R2, #1; 2000+1
        ADD R6, R6, #1
;   age = 1;
		;MOV	R5, #1; age
        MOV R1, #1 ;age

; print("This person was born on " + str(bDay) + "/" + str(bMonth) + "/" + str(bYear))
		ADRL	R0, wasborn
		SVC	print_str
        STR LR, temp
        BL  printsthedate

		

; this code does: while year < pYear //{
loop1	LDR	R0, pYear
		CMP	R6, R0
		BHS	end1		; Years are unsigned
; for part 4, should be changed to:
; while year < pYear or
;				(year == pYear and bMonth < pMonth) or
;				(year == pYear and bMonth == pMonth and bDay < pDay):

;  print("This person was " + str(age) + " on " + str(bDay) + "/" + str(bMonth) + "/" + str(year))
		ADRL	R0, was
		SVC	print_str
		MOV	R0, R1
		SVC	print_no
		ADRL	R0, on
		SVC	print_str

		BL printsthedate

		; year = year + 1
		ADD	R6, R6, #1
		; age = age + 1
		ADD	R1, R1, #1
		; //}
		B	loop1

end1
; this code does: if (bMonth == pMonth):
; for part 4, should be changed to:
; if (bMonth == pMonth and bDay == pDay):
		LDR	R0, pMonth
		CMP	R5, R0
		BNE	else1

; print("This person is " + str(age) + " today!")
		ADRL	R0, is
		SVC	print_str
		MOV	R0, R1
		SVC	print_no
		ADRL	R0, today
		SVC	print_str
		MOV	R0, #cLF
		SVC	print_char

; else
		B	end2
        ;MOV	PC, LR
else1
; print("This person will be " + str(age) + " on " + str(bDay) + "/" + str(bMonth) + "/" + str(year))
		ADRL	R0, willbe
		SVC	print_str
		MOV	R0, R1
		SVC	print_no
		ADRL	R0, on
		SVC	print_str
        ;STR LR, temp
		BL printsthedate

; }// end of printAgeHistory
end2		;POP	{R4}		; callee saved registers
		;POP	{R5}
		;POP	{R6}
        ;LDMFD SP!, {R4}
        ;LDMFD SP!, {R5}
        ;LDMFD SP!, {R6}
        LDR LR, temp
		MOV	PC, LR

another		DEFB	"Another person",10,0
		ALIGN

; def main():
main
	LDR	R4, =&12345678		; Test value - not part of Java compilation
	MOV	R5, R4			; See later if these registers corrupted
	MOV	R6, R4
    STMFD SP!, {R4-R6}

; printAgeHistory(pDay, pMonth, 2000)
		LDR	R4, pDay
		;PUSH	{R0}			; Stack first parameter
        ;STMFD SP!, {R0}
		LDR	R5, pMonth
		;PUSH	{R0}			; Stack second parameter
        ;STMFD SP!, {R0}
		MOV	R6, #2000
		;PUSH	{R0}			; Stack third parameter
        ;STMFD SP!, {R0}
		BL	printAgeHistory
		;POP	{R0}			; Deallocate three 32-bit variables
		;POP	{R0}
		;POP	{R0}



; print("Another person");
		ADRL	R0, another
		SVC	print_str

; printAgeHistory(13, 11, 2000)
		MOV	R4, #13
		;PUSH	{R0}			; Stack first parameter
        ;STMFD SP!, {R0}
		MOV	R5, #11
		;STR	R0, [SP, #-4]!		; An explicit coding of PUSH
		MOV	R6, #2000
		;STMFD	SP!, {R0}		; The STore Multiple mnemonic for PUSH {R0}
		BL	printAgeHistory
		;POP	{R0}			; Deallocate three 32-bit variables
		;POP	{R0}
		;POP	{R0}
        ;LDMFD SP!, {R0}
        ;LDMFD SP!, {R0}
        ;LDMFD SP!, {R0}
        LDMFD SP!, {R4-R6}

	; Now check to see if register values intact (Not part of Java)
	LDR	R0, =&12345678		; Test value
	CMP	R4, R0			; Did you preserve these registers?
	CMPEQ	R5, R0			;
	CMPEQ	R6, R0			;

	ADRLNE	R0, whoops1		; Oh dear!
	SVCNE	print_str		;

	ADRL	R0, _stack		; Have you balanced pushes & pops?
	CMP	SP, R0			;

	ADRLNE	R0, whoops2		; Oh no!!
	SVCNE	print_str		; End of test code

; }// end of main
		SVC	stop


whoops1		DEFB	"\n** BUT YOU CORRUPTED REGISTERS!  **\n", 0
whoops2		DEFB	"\n** BUT YOUR STACK DIDN'T BALANCE!  **\n", 0
