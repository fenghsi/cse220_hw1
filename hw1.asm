# type your first and last name here Fenghsi Yu
# type your Net ID here (e.g., jmsmith) feyu
# type your SBU ID # here (e.g., 111234567) 111599996

.data
# Command-line arguments
num_args:  .word 0
addr_arg0: .word 0
addr_arg1: .word 0
addr_arg2: .word 0
addr_arg3: .word 0
no_args: .asciiz "You must provide at least one command-line argument.\n"

# Error messages
invalid_operation_error: .asciiz "INVALID_OPERATION\n"
invalid_args_error: .asciiz "INVALID_ARGS\n"

# Output strings
zero_str: .asciiz "Zero\n"
neg_infinity_str: .asciiz "-Inf\n"
pos_infinity_str: .asciiz "+Inf\n"
NaN_str: .asciiz "NaN\n"
floating_point_str: .asciiz "_2*2^"
dot_str:.asciiz "."



# Miscellaneous strings
nl: .asciiz "\n"

# Put your additional .data declarations here, if any.


# Main program starts here
.text
.globl main
main:
    # Do not modify any of the code before the label named "start_coding_here"
    # Begin: save command-line arguments to main memory
   
    sw $a0, num_args
    beq $a0, 0, zero_args
    beq $a0, 1, one_arg
    beq $a0, 2, two_args
    beq $a0, 3, three_args
    
four_args:
    lw $t0, 12($a1)
    sw $t0, addr_arg3
three_args:
    lw $t0, 8($a1)
    sw $t0, addr_arg2
two_args:
    lw $t0, 4($a1)
    sw $t0, addr_arg1
one_arg:
    lw $t0, 0($a1)
    sw $t0, addr_arg0
    j start_coding_here
zero_args:
    la $a0, no_args
    li $v0, 4
    syscall
    j exit
    # End: save command-line arguments to main memory
    
start_coding_here:
    
    
    # Start the assignment by writing your code here
    lw $t0, addr_arg0
    lb $t1, 1($t0)
    
    bne $t1, 0, error1
    
    lw $t0, addr_arg0
    lb  $t0,  0($t0) 
    beq $t0,'F',Equal_F
    
    lw $t0, addr_arg0
    lb  $t0,  0($t0) 
    beq $t0,'C',Equal_C
    
    lw $t0, addr_arg0
    lb  $t0,  0($t0) 
    beq $t0,'2',Equal_2
    
error1:    
    li $v0, 4
    la $a0, invalid_operation_error
    syscall
    
    j exit
    
Equal_F:
    li $t0, 2
    lw $t1, num_args
    bne $t1, $t0, error
    
    
    j next_F

Equal_2:
    li $t0, 2
    lw $t1, num_args
    bne $t1, $t0, error
    
    
    j next_2



Equal_C:
    li $t0, 4
    lw $t1, num_args
    bne $t1, $t0, error
    
    
    j next_C
    

###############################################################    start part 2
next_2:
    

    lw $s0, addr_arg1  ## load arg 1 into s0
    li $t0, 0   ## counter
    
#count string length
string_length_loop:
    lb $t1, ($s0)  ## load one character into t1
    
    beq $t1, $zero, done_count
    
    addi $s0, $s0, 1  ## point to the next char
    addi $t0, $t0 , 1  ## count ++
j string_length_loop

done_count:
 #if more than 32 bits
    li $t5,32
    bgt  $t0,$t5,error
    
    
    addi $t0, $t0,-1#counter become exponenet
    
    lw $s0, addr_arg1  ## load arg 1 into s0
   
    li $t1, -1#  exponent sum 
    	
    move $t2,$t0# temporary exponent conuter
    
    li $t3,0 # total sum
    
    lb $t4, ($s0)#t4==0 or 1
    addi $t4,$t4,-48
    
    
    

j exponent_loop
    
    
addition_loop:
    li $t6, 2
    bge $t4, $t6,error1
    
    mul $t1, $t1, $t4# if t4==1 then has value if 0 no value to be added
    add $t3,$t3, $t1# add t1 to the total sum
    li $t1,1# reset to 1 in oreder to do multiplcation
    beq $t0, $zero,next1
    
    addi $s0,$s0,1# go to next bit
    lb $t4,($s0) #update new 0 or 1 for next bit
    addi $t4,$t4,-48
    
   
    addi $t0,$t0,-1#update total exp
    move $t2, $t0# update temp exp
    j exponent_loop
    
    
j addition_loop
    
    
    

    
exponent_loop:
    beq $t2,$zero,addition_loop#if t2==0 finish counting the 2 exponenet
    li $t5,2
    mul $t1, $t1,$t5 # increase temoprary exponenet times 2
    addi $t2,$t2,-1#temporary exponenet count -1
    
j exponent_loop


next1:
    move $a0, $t3 
    li $v0, 1
    syscall
    la $a0, nl
    li $v0,4
    syscall
###############################################################    Finish part 2
j exit
###############################################################    start part 3
next_F:
    
    
#count the length for F
     li $t0,0 #counter for length
     lw $s0,addr_arg1
     li $t3,48
     li $t4,57
length_F_loop:
    
    lb $t1, ($s0)  ## load one character into t1
    
    beq $t1, $zero, next3
    blt $t1,$t3,error
    bgt $t1,$t4,checkhex
back:
    
    addi $s0, $s0, 1  ## point to the next char
    addi $t0, $t0 , 1  ## count ++

j length_F_loop    
 
     
next3:
# end if != 8 length   
    li $t1,8
    bne $t0,$t1,error
    
    
    
   #convert hex to decimal
hex_to_deci:
    # start counter
    lw   $t0, addr_arg1   #load word   
    li   $a0, 0         #sum           
    j    hex_to_deci_Loop

hex_to_deci_Loop:
    lb   $t1, 0($t0)# load byte
    ble  $t1, '9', from_0_9  #determine 123 or Abc    
    addi $t1, $t1, -55     #convert       
    j    next_NN
next_NN:
    blt  $t1, $zero, con_fin  #end condi
    li   $t2, 16                   
    mul  $a0, $a0, $t2    #  mul by 16 to decimal        
    add  $a0, $a0, $t1    #add        
    addi $t0, $t0, 1                
    j    hex_to_deci_Loop

from_0_9:
    addi $t1, $t1, -48              
    j    next_NN
    
    
  
    
 
    
con_fin:
	move $t1, $a0
	
	
	beq $t1,$zero, zero_err
	li $t0,0x80000000
	beq $t1,$t0,zero_err
	li $t0, 0xFF800000
	beq $t1,$t0,inf_neg
	li $t0, 0x7F800000
	beq $t1,$t0,inf_pos
	li $t0, 0x7F800001
	bge $t1,$t0,check_NAN7	
continue_check_error:
	li $t0, 0xFF800001
	bge $t1,$t0,check_NANF	
continue_check_error1:	        	
	j conti
check_NAN7:
        li $t0, 0x7FFFFFFF
	ble $t1,$t0,check_NAN71
	j continue_check_error
check_NAN71:
        li $v0, 4
        la $a0, NaN_str 
        syscall	
	j exit	
check_NANF:
        li $t0, 0xFFFFFFFF
	ble $t1,$t0,check_NANF1
	j continue_check_error1
check_NANF1:
        li $v0, 4
        la $a0, NaN_str 
        syscall	
	j exit        
              		
zero_err:
        li $v0, 4
        la $a0, zero_str 
        syscall
       	 
       	j exit
inf_neg:
        li $v0, 4
        la $a0, neg_infinity_str 
        syscall
       	 
       	j exit 
inf_pos:
        li $v0, 4
        la $a0, pos_infinity_str 
        syscall
       	 
       	j exit         	     		 
conti:	
	srl $t2, $t1,31#get sign bit
	
	sll $t3, $t1,1# t3 == eponent
	srl $t3, $t3,24# get the eponent
	addi $t3,$t3,-127
	
	

	
	li $t8,1
	bne $t2,$t8, positive
negative:
        li $t7,-1
        move $a0,$t7
        li $v0, 1
        syscall
	
	j floating_23
positive:
        li $t7,1
        move $a0,$t7
        li $v0, 1
        syscall
        
        
floating_23:
    li $v0, 4
    la $a0, dot_str
    syscall
	
    move $t4, $t1# 32 bit
    
    li $t8,32
    li $t7,9# counter from 9
print_f_loop:

    beq $t7,$t8,left_exponent
    
    sllv  $t4,$t4,$t7
    srl $t4,$t4,31
    
    move $a0, $t4#print each decimal
    li $v0, 1
    syscall
    
    addi $t7,$t7, 1#increase decimal to be printed
 
    move $t4,$t1
j print_f_loop    
    
      
    
left_exponent :
    li $v0, 4
    la $a0, floating_point_str
    syscall
       
    move $a0,$t3
    li $v0, 1
    syscall
    
    
    la $a0,nl 
    li $v0 ,4
    syscall
    
    
    
    j exit

###############################################################    Finish part 3
############################################################## start part 4
next_C:
    lw $s0, addr_arg1
    lw $s1, addr_arg2
    lw $s2, addr_arg3
    
    lb $t5, ($s1)# base from
    addi $t5, $t5, -48 #convert into real base
    # if $t5== 10 then no need to convert
    li $t6, 1
    beq $t5, $t6, move_deci_to_tzero
we_finsih:      
    li $t0, 0# sum
    
    #convert random to decimal 
    
random_to_deci_loop:
	
	lb $t1, ($s0)
	addi $t1, $t1, -48
	 

	
	bge  $t1,$t5,error
	
	blt  $t1, $zero, end_random_to_deci_loop  #end condi
	li $t7, 0
	blt $t1,$t7,error 
    
	mul $t0, $t0,$t5# multi by base
	add $t0, $t0, $t1#then add
        addi $s0, $s0, 1#increase by one 


j random_to_deci_loop
    
    
move_deci_to_tzero:
      li $t5, 10
j we_finsih

move_decimal:
      li $t1,10	        
j we_finish_1  
  
end_random_to_deci_loop:    
	# after finsih convert to decimal in $t0 is the deicmal 
	
	#now convert it into $s2 base
	lb $t1, ($s2)# base from
    	addi $t1, $t1, -48 #convert into real base
   	 # if $t5== 10 then no need to convert
    	li $t2, 1
    	beq $t1, $t2, move_decimal
we_finish_1 :    
    # now we got $t0 as decimal and $t1 as base to convert to
    li $t2,0# for store remainder
    
    li $t3,0 #result sum
    li $s0,0# result sum1
    li $s1,0#2 
    li $s2,0#3
    
    li $t4,1# for exxponent t3
    li $s6,1#s0
    li $s7,1#s1
    li $t8,1#s2

    li $t5, 0# compare 0
    li $t6,10 #mult 10
    li $t7,0#counter
    li $s3,8
    li $s4,16
    li $s5,24    
answer_loop:    
    																																
	div $t0, $t1    
	
	mfhi $t2#update r
	mflo $t0#update q
	
	
	bge $t7,$s5,phase_11
	bge $t7,$s4,phase_12
	bge $t7,$s3,phase_13	
	
	mul $t2, $t2, $t4# time by corresponding power		
	add $t3, $t3, $t2 #then add to total 
	mul $t4, $t4, $t6# remember to update pointer by 10
	j phase_fi
phase_11:
	mul $t2, $t2, $s6# time by corresponding power
        add $s0, $s0, $t2 #then add to total 
	mul $s6, $s6, $t6# remember to update pointer by 10
	j phase_fi
phase_12:
	mul $t2, $t2, $s7# time by corresponding power
        add $s1, $s1, $t2 #then add to total 
	mul $s7, $s7, $t6# remember to update pointer by 10
	j phase_fi
phase_13:	
	mul $t2, $t2, $t8# time by corresponding power
        add $s2, $s2, $t2 #then add to total 
	mul $t8, $t8, $t6# remember to update pointer by 10
	j phase_fi	
	
phase_fi:
	beq $t0,$t5, after_answer_loop
	addi $t7, $t7,1
	
	

j answer_loop    
    
    
    
after_answer_loop:
#$t7==number of digits to be printed
#s0 s1 s2 t3 is the number 
    li $t6,1
    li $t0,10
    div $s6,$t0 
    mflo $s6
    div $s7,$t0
    mflo $s7
    div $t8,$t0
    mflo $t8   
    div $t4,$t0
    mflo $t4    
   # after converting to appropriate exxponent
   
   
    beq $s6,$zero,lol_1#if epxonet==0
   
for_first_8:
	beq $zero, $s6,lol_1 
	div $s0,$s6# will get us the value of quotient and remainder for the number and reset s0
	mfhi $s0#reset the $s0 to remainder 
   	mflo $t1#sub for the print quotient
      	move $a0,$t1
      	li $v0, 1
      	syscall#print
        div $s6,$t0   #reset pointer
        mflo $s6    
                 
j for_first_8    
    
lol_1:    
    
    beq $s7,$zero,lol_2#if epxonet==0
   
for_second_8:
	beq $zero, $s7,lol_2 
	div $s1,$s7# will get us the value of quotient and remainder for the number and reset s0
	mfhi $s1#reset the $s0 to remainder 
   	mflo $t1#sub for the print quotient
      	move $a0,$t1
      	li $v0, 1
      	syscall#print
        div $s7,$t0   #reset pointer
        mflo $s7    
                 
j for_second_8     
    
    
    
lol_2:  
    beq $t8,$zero,lol_3#if epxonet==0
   
for_third_8:
	beq $zero, $t8,lol_3 
	div $s2,$t8# will get us the value of quotient and remainder for the number and reset s0
	mfhi $s2#reset the $s0 to remainder 
   	mflo $t1#sub for the print quotient
      	move $a0,$t1
      	li $v0, 1
      	syscall#print
        div $t8,$t0   #reset pointer
        mflo $t8    
                 
j for_third_8       

lol_3:
    beq $t4,$zero,lol_4#if epxonet==0
   
for_fourth_8:
	beq $zero, $t4,lol_4 
	div $t3,$t4# will get us the value of quotient and remainder for the number and reset s0
	mfhi $t3#reset the $s0 to remainder 
   	mflo $t1#sub for the print quotient
      	move $a0,$t1
      	li $v0, 1
      	syscall#print
        div $t4,$t0   #reset pointer
        mflo $t4    
                 
j for_fourth_8  

lol_4:
    
    la $a0,nl 
    li $v0 ,4
    syscall
    



     j exit
############################################################## finish part 4     
checkhex:
    li $t3,65
    li,$t4,70
    
    blt $t1,$t3,error
    bgt $t1,$t4,error
   
    li $t3,48
    li,$t4,57
j back
error:
    li $v0, 4
    la $a0, invalid_args_error
    syscall

exit:
    li $v0, 10   # terminate program
    syscall
