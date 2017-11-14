.data

string_ask: .asciiz "\nPlease enter your string: "

string_return: .asciiz "\nResult: "

string_invalid: .asciiz "\nInvalid hexadecimal number."

in_name: .space 8 # space for input string


.text

.globl main

main:

  la $a0,string_ask # print prompt string
  li $v0,4
  syscall

  la $a0,in_name # read the input string
  li $a1,8 # at most 30 chars + 1 null char
  li $v0,8
  syscall

xor $a0, $a0, $a0
search:  
  lbu $a2, in_name($a0)

#
#Checking the character to see if it is in range
#

li $t6,47
li $t7,58
slt $t0,$t6,$a2    # Sets $t0=1 if 47 < $a2, otherwise $t0=0
slt $t1,$a2,$t7    # Sets $t1=1 if $a2 < 58, otherwise $t1=0
and  $t2, $t1, $t0    # Sets $t0=1 if $a1 < $a0 < $a2, otherwise $t0=0

li $t6,64
li $t7,71
slt $t0,$t6,$a2    # Sets $t0=1 if $a1 < $a0, otherwise $t0=0
slt $t1,$a2,$t7    # Sets $t1=1 if $a0 < $a2, otherwise $t1=0
and  $t3, $t1, $t0    # Sets $t0=1 if $a1 < $a0 < $a2, otherwise 				#$t0=0
or $t2, $t2, $t3    

li $t6,96
li $t7,103
slt $t0,$t6,$a2    # Sets $t0=1 if $a1 < $a0, otherwise $t0=0
slt $t1,$a2,$t7    # Sets $t1=1 if $a0 < $a2, otherwise $t1=0
and  $t0, $t1, $t0    # Sets $t0=1 if $a1 < $a0 < $a2, otherwise $t0=0
or $t2, $t2, $t0    

beq $t2, $zero, invalid #branch to invalid if the character is 					   #not valid


  beq $a2, 'x', found    
  addiu $a0, $a0, 1
  bne $a0, $a1, search


not_found:
    # Code here is executed if the character is not found
    b done
found:
	addi $s7, $s7,239
    # Code here is executed if the character is found
done:
  #output decimal number to console

#
#Output if the number is not hex
#

invalid:
	
  la $a0,string_invalid ## print error string
  li $v0,4
  syscall


