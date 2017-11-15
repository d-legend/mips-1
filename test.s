.data

string_ask: .asciiz "\nPlease enter your string: "

string_return: .asciiz "\nResult: "

string_done: .asciiz "\nDone."

string_invalid: .asciiz "\nInvalid hexadecimal number."

buff: .space 8 # space for input string


.text

.globl main

main:

la $a0,string_ask # print prompt string
li $v0,4
syscall

la $a0,buff# read the input string
li $a1,9 # at most 30 chars + 1 null char
li $v0,8
syscall

xor $a0, $a0, $a0

strLen:                 #getting length of string

lbu $t4, buff($a0)   #loading value
beq $t4, 10, HextoDec
beq $t4, $zero, HextoDec
add $a0, $a0, 1
add $s5, $s5, 1  

#
#Checking the character to see if it is in range
#

HexCheck:
move $t2, $zero

li $t6,47
li $t7,58
slt $t0,$t6,$t4    # Sets $t0=1 if 47 < $a2, otherwise $t0=0
slt $t1,$t4,$t7    # Sets $t1=1 if $a2 < 58, otherwise $t1=0
and  $t2, $t1, $t0    # Sets $t0=1 if $a1 < $a0 < $a2, otherwise $t0=0

li $t6,64
li $t7,71
slt $t0,$t6,$t4    # Sets $t0=1 if $a1 < $a0, otherwise $t0=0
slt $t1,$t4,$t7    # Sets $t1=1 if $a0 < $a2, otherwise $t1=0
and  $t3, $t1, $t0    # Sets $t0=1 if $a1 < $a0 < $a2, otherwise 				#$t0=0
or $t2, $t2, $t3    

li $t6,96
li $t7,103
slt $t0,$t6,$t4    # Sets $t0=1 if $a1 < $a0, otherwise $t0=0
slt $t1,$t4,$t7    # Sets $t1=1 if $a0 < $a2, otherwise $t1=0
and  $t0, $t1, $t0    # Sets $t0=1 if $a1 < $a0 < $a2, otherwise $t0=0
or $t2, $t2, $t0    


li $t6,32
bne $t6,$t4,Else   # b Else if there is no space
beq $s5, 8, Invalid # b Invalid if all spaces
#beq $t8, 1, 
li $t2, 1          # $t2 = 1
j Exit             # jump out of the if
Else: 
	bne $t2,1,Invalid # b Invalid if other chars not hex
	li $t8, 1 	#Assign 1 if you see a char
Exit:
	
beq $t2, $zero, Invalid #branch to invalid if the character is not valid

j strLen

#
#Hexadecimal to Decimal Conversion
#

HextoDec:
	blez $s5, Invalid  # jump Invalid on hitting enter first
la $a0,string_done # end of prog
li $v0,4
syscall
li $v0,10
syscall


done:
#output decimal number to console

#
#Output if the number is not hex
#

Invalid:
	
la $a0,string_invalid # print error string
li $v0,4
syscall
li $v0,10
syscall



