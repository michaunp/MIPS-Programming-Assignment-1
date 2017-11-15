
.data
	buffer: .space 9
	str1: .asciiz "Enter string: "
	str2: .asciiz "Invalid hexadecimal string."

.text

main:
	li $v0,8        #take in input
	la $a0,buffer   #load argument with byte space
	li $a1,9        #allot byte space for string
	add $s0,$zero,$a0  #load user input into register
	syscall
	add $t0,$zero,$s0 #load string into temporary register for loop
	add $t3,$zero,$s0 #load string into temporary register for count_string loop
	addi $t4,$zero,10 #load newline value into a temporary register

count_string_loop:
	lb $t5,0($t3) #load first byte of string
	beq $t4,$t5,count_string_exit   #checks to see if it is the end of the string
	beq $zero,$t5,count_string_exit  #checks to see if it is the end of the string
	addi $t6,$t6,1 #increment character counter and store it in register
	addi $t3,$t3,1 #change current byte, at the end of loop length of string is stored in $t6
	j count_string_loop
count_string_exit:
	
	addi $t8,$t6,-1   #initialize index to length - 1
loop:
	lb $t1,0($t0) #load first byte of string
	beq $t4,$t1,loop_exit #checks to see if it is the end of the string
	beq $zero,$t1,loop_exit ##checks to see if it is the end of the string	
	blt $t1,48,invalid #checks if character is less than 48, branches to invalid section if true
	blt $t1,58,check_num #goes to get value of char since it's valid
	blt $t1,65,invalid #checks if character is less than 65, branches to invalid section if true
	blt $t1,71,check_uppercase #goes to get value of char since it's valid
	blt $t1,97,invalid #checks if character is less than 97, branches to invalid section if true
	blt $t1,103,check_lowercase #goes to get value of char since it's valid
	
 
check_num:
	addi $t2,$t1,-48  #convert 0-9 ascii to 0-9 hex
    j compute_sum  #jump to compute exponent

check_uppercase:
	addi $t2,$t1,-55   #convert A-F ascii to 10-15 hex
	j compute_sum   #jump to compute exponent

check_lowercase:
	addi $t2,$t1,-87     #convert a-f ascii to 10-15 hex
	j compute_sum   #jump to compute exponent
	


compute_sum:
	sll $t7,$t7,4
	add $t7,$t7,$t2
	
	addi $t0,$t0,1                #increments $t0 by one to point to next element in the string
	addi $t8,$t8,-1               #decrement index by 1
	addi $t3,$t3,-4               #decrement shift amount by four
	j loop                        #jumps back to beginning of loop
loop_exit:

	addi $s4,$zero,7                  #initializes a register with the value seven
	bgt $t6,$s4,special_output        #jumps to special output register if length of string is less than zero
	li $v0,1                          #load code for printing an integer
	add $a0,$zero,$t7                     #load argument with decimal number
	syscall

end:
	li $v0,10                     #end program     
	syscall

invalid:
	la $a0,str2                  #load argument with invalid string
	li $v0,4                     #load with code to print a string
	syscall
	j end
	
special_output:
	addi $s5,$zero,10000         #initializes register with 10,000 for special output
	divu $t7,$s5                  #divide sum by 10,000
	mflo $s6                     #move quotient from low
	mfhi $s7                     #move remainder from high
	li $v0,1                     #load code to print integer
	add $a0,$zero,$s6                   #load argument with quotient
	syscall
	li $v0,1                     #load code to print integer
	add $a0,$zero,$s7            #load argument with remainder
	syscall
	j end     	                 #jump to end
