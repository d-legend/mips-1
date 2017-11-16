

.data

string_invalid: .asciiz "Invalid hexadecimal number."

buff: .space 9 # space for input string

.text

.globl main

main:

la $a0,buff# input string address
li $a1,9 # at most 30 chars + 1 null char
li $v0,8 #read string
syscall

xor $a0, $a0, $a0	#zero out register

Loop1:                 #getting length of string

lbu $t4, buff($a0)   #loading each byte of string
beq $t4, 10, Done   #b if there is a return character
beq $t4, 0, Done    #b if there is a null character
add $a0, $a0, 1   #increment address

#
#Checking the character to see if it is in range
#

HexCheck:
move $t2, $zero

li $t6,47
li $t7,58
slt $t0,$t6,$t4    # Sets $t0=1 if $t6 < $t4, otherwise $t0=0
slt $t1,$t4,$t7    # Sets $t1=1 if $t4 < $t7, otherwise $t1=0
and  $t2, $t1, $t0    # Sets $t0=1 if $t6 < $t4 < $t7, otherwise $t0=0
beq $t2, 0, HexCheck2
add $s6, $s6, 1  
add $a2, $t4, -48 
jal DecCalc
 

HexCheck2:
li $t6,64
li $t7,71
slt $t0,$t6,$t4    # Sets $t0=1 if $t6 < $t4, otherwise $t0=0
slt $t1,$t4,$t7    # Sets $t1=1 if $t4 < $t7, otherwise $t1=0
and  $t3, $t1, $t0    # Sets $t0=1 if $t6 < $t4 < $t7, otherwise 				#$t0=0
beq $t3, 0, HexCheck3
add $s6, $s6, 1  
add $a2, $t4, -55  
jal DecCalc


HexCheck3:
or $t2, $t2, $t3    
li $t6,96
li $t7,103
slt $t0,$t6,$t4    # Sets $t0=1 if $t6 < $t4, otherwise $t0=0
slt $t1,$t4,$t7    # Sets $t1=1 if $t4 < $t7, otherwise $t1=0
and  $t0, $t1, $t0    # Sets $t0=1 if $t6 < $t4 < $t7, otherwise $t0=0
beq $t0, 0, WhiteSpaces
add $s6, $s6, 1  
add $a2, $t4, -87
jal DecCalc  

#
#Ignoring white spaces
#

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
	
beq $t2, $zero, Invalid #b to invalid if the character is not valid

j Loop1

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
#End program function that checks for empty input
#

Done:
blez $s6, Invalid  # b Invalid on hitting enter first
la $a0, 0($s3) # end of prog
li $v0,1
syscall
li $v0, 10
syscall

#
#Compute Decimal Equivalent
#

DecCalc:
bge $s6, 2, cont
add $s3, $s3, $a2
li $t8, 1
beq $s6, 1, Loop1
cont:
sll $s3, $s3, 4
add $s3, $s3, $a2
jr $ra

#
#Output if the string is not hex
#

Invalid:
	
la $a0,string_invalid # print error string
li $v0,4
syscall
li $v0,10
syscall
