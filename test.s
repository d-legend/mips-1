

.data

array: .word 0:8

string_ask: .asciiz "\nPlease enter your string: "

string_return: .asciiz "\nResult: "

string_done: .asciiz "\nDone."

string_invalid: .asciiz "\nInvalid hexadecimal number."

buff: .space 9 # space for input string


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
beq $t4, 0, HextoDec
add $a0, $a0, 1


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
beq $t2, 0, HexCheck2
add $s6, $s6, 1  
add $a2, $t4, -48 
jal StoreArray
 

HexCheck2:
li $t6,64
li $t7,71
slt $t0,$t6,$t4    # Sets $t0=1 if $a1 < $a0, otherwise $t0=0
slt $t1,$t4,$t7    # Sets $t1=1 if $a0 < $a2, otherwise $t1=0
and  $t3, $t1, $t0    # Sets $t0=1 if $a1 < $a0 < $a2, otherwise 				#$t0=0
beq $t3, 0, HexCheck3
add $s6, $s6, 1  
add $a2, $t4, -55  
jal StoreArray


HexCheck3:
or $t2, $t2, $t3    
li $t6,96
li $t7,103
slt $t0,$t6,$t4    # Sets $t0=1 if $a1 < $a0, otherwise $t0=0
slt $t1,$t4,$t7    # Sets $t1=1 if $a0 < $a2, otherwise $t1=0
and  $t0, $t1, $t0    # Sets $t0=1 if $a1 < $a0 < $a2, otherwise $t0=0
beq $t0, 0, WhiteSpaces
add $s6, $s6, 1  
add $a2, $t4, -87
jal StoreArray  


WhiteSpaces:
or $t2, $t2, $t0    
move $a3, $a0
move $t7, $t4
li $t6,32
bne $t6,$t7,Else   # b Else if there is no space
beq $s5, 8, Invalid # b Invalid if all spaces
beq $t8, 1, LoopBuff 
li $t2, 1          # $t2 = 1
j Exit             # jump out of the if

Else: 
	bne $t2,1,Invalid # b Invalid if other chars not hex
	li $t8, 1 	#Assign 1 if you see a char
Exit:
	
beq $t2, $zero, Invalid #branch to invalid if the character is not valid

j strLen

#
#After there is a character and then a space iterate further to #see if another character shows up and mark invalid if it is so
#

LoopBuff: 
	
lbu $t7, buff($a3)   #loading value
add $a3, $a3, 1
bne $t7, 32, Else2
j LoopBuff
	Else2:
	bne $t7, 10, Else3
		li $t8, 0 
		j WhiteSpaces
Else3:
		bne $t7, 0, Invalid
		li $t8, 0 
		j WhiteSpaces

#
#Hexadecimal to Decimal Conversion
#

HextoDec:
	blez $s6, Invalid  # jump Invalid on hitting enter first
la $a0,string_done # end of prog
li $v0,4
syscall
li $v0,10
syscall

StoreArray:
la $s0, array   # load the address of the array into $a1
#lb $a2, 0($s0)           # load a byte from the array into $a2
sb $a2, 0($s0)           # store the new value into memory
addi $s0, $s0, 1         # increment $a1 by one, to point to the next element in the array
jr $ra

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