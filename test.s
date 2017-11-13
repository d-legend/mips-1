.data

string_ask: .asciiz "\nPlease enter your string: "

string_return: .asciiz "\nResult: "

in_name: .space 31 ## space for input string


.text

.global main

main:

la $a0,string_ask ## print prompt string

li $v0,4

syscall