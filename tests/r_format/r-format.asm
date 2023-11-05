

#load equivalents to test .asm seperately
#li	t1, 147
#li	t2, 1 
#li	t3, 13
#li	t4, -13
#li 	t5, -20 

lw	t1, 0(x6)
lw	t2, 0(x7)
lw	t3, 0(x28)
lw	t4, 0(x28)
lw	t5, 0(x30)


#testing R format

sll	t3, t3, t2		# <<	13
srl	t3, t3, t2 		# >> 	13
sra	t4, t4, t2		# >>> 	-13  =  -6 

add	t4, t4, t2 		# -5 
sub	t4, t3, t4		# 13 - - 5 = 18 

or  	t4, t1, t3	# 147 no change 
xor	t4, t3, t1		# 158 
and 	t4, t2, t1	# 1 

slt	t4, t2, t3		# 1 
sltu	t4, t5, t2	# 0





