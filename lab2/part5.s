; Age History

	B  main

born	DEFB "you were born in \0"
were	DEFB "you were \0"
in	DEFB " in \0"
are	DEFB "you are \0"
this	DEFB " this year\n\0"


	ALIGN

	; present = 2020 // Change this code DONE
R4 DEFW 2020
	; birth = 2002   // Change this code DONE
R5 DEFW 2002
	; year = 0       // Change this code DONE
     R6 DEFW 0

	; age = 1        // Change this code DONE
      R7 DEFW 1


main
	; this code does print "you were born in " + str(birth) // DO NOT change the instructions below (except for part 5)
	ADR R0, born
	SVC 3
	LDR R0, R5 ; make sure this will work!
	SVC 4
	MOV R0, #10
	SVC 0

	; year = birth + 1 // Change this code DONE
    LDR R1, R5
    ADD R1, R1, #1
    STR R1, R6

	; while year != present //{ Change this code
    LDR R1, R6
    LDR R2, R4
    LDR R3, R7
start  CMP R1, R2
    BNE jump
    B skip

	; this code does print "you were " + str(age) + " in " + str(year) // DO NOT change the instructions below (except for part 5)
jump	ADR R0, were
	SVC 3
	LDR R0, R7 ; make sure this will work!
	SVC 4
	ADR R0, in
	SVC 3
	LDR R0, R6 ; make sure this will work!
	SVC 4
	MOV R0, #10
	SVC 0


    ADD R1, R1, #1
    STR R1, R6

    ADD R3, R3, #1
    STR R3, R7
    B start
	;   year = year + 1 //Change this code
	;   age = age + 1   //Change this code
	; } //              //Change this code

     

	; this code does print "you are " + str(age) + "this year" // DO NOT change the instructions below (except for part 5)
skip	ADR R0, are
	SVC 3
	LDR R0, R7 ; make sure this will work!
	SVC 4
	ADR R0, this
	SVC 3

	SVC 2 ; stop
