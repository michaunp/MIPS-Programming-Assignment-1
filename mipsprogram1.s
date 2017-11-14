
.data
	buffer: .space 9
	str1: .asciiz "Enter string: "
	str2: .asciiz "Invalid hexadecimal string."

.text

main:
	la $a0,str1  #load and print string asking for user input
	li $v0,4
	syscall
	
	li $v0,8        #take in input
	la $a0,buffer   #load argument with byte space
	li $a1,9        #allot byte space for string
	add $s0,$zero,$a0  #load user input into register
	syscall
	add $t0,$zero,$s0 #load string into temporary register

loop:	
	lb $t1,0($t0) #load first byte of string
	blt $t1,48,invalid #checks if character is less than 48, branches to invalid section if true
	blt $t1,58,valid_num #goes to get value of char since it's valid
	blt $t1,65,invalid #checks if character is less than 65, branches to invalid section if true
	blt $t1,71,valid_num #goes to get value of char since it's valid
	blt $t1,97,invalid #checks if character is less than 97, branches to invalid section if true
	blt $t1,103,valid_num #goes to get value of char since it's valid
	

valid_num:
	addi $t1,$t1,-48
	
invalid:
	la $a0,str2
	li $v0,4
	syscall
end:
	li $v0,10 #end program
	
