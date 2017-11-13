.data

string_ask: .asciiz "\nPlease enter your string: "

string_return: .asciiz "\nResult: "

in_name: .space 8 ## space for input string


.text

.globl main

main:

  la $a0,string_ask ## print prompt string
  li $v0,4

syscall

  la $a0,in_name ## read the input string
  li $a1,8 ## at most 30 chars + 1 null char
  li $v0,8

syscall
xor $a0, $a0, $a0
search:  
  lbu $a2, in_name($a0)
  beq $a2, 'a', found    
  addiu $a0, $a0, 1
  bne $a0, $a1, search


not_found:
    # Code here is executed if the character is not found
    b done
found:
	addi $s7, $s7,239
    # Code here is executed if the character is found
done:




