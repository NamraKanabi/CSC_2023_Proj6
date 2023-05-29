.include "common.s"

.data
	var1: .double  2.72047909631134875287705126898888084e-15 #variables used for approximation 
	var2: .double -7.64291780693694318128770390349958602e-13
	var3: .double  1.60589364903732230834314189302038183e-10
	var4: .double -2.50521067982746148969440582709985054e-8
	var5: .double  2.75573192101527564362114785169078252e-6
	var6: .double -0.00019841269841201840459252750531485886
	var7: .double  0.00833333333333316503140948668861163462
	var8: .double -0.166666666666666650522767323353840604
	var9: .double  0.99999999999999999974277490079943975
	
	pim2: .double 6.28318530717958648 #constant 2 * pi
	pid2: .double 1.57079632679489662 #constant pi / 2 
	pie:  .double 3.14159265358979324 #constant pi
	piq:  .double 4.71238898038468986 #constant 3pi / 2
	
	n_pim2: .double -6.28318530717958647 #constant -2 * pi
	n_pid2: .double -1.57079632679489661 #constant -pi / 2 
	n_pie:  .double -3.14159265358979323 #constant -pi
	n_piq:  .double -4.71238898038468985 #constant -3pi / 2
	
	fzero: .double 0.00000000000000000 #constant double 0
	fneg_one: .double -1.00000000000000000 #constant double -1


.text
#------------------------------------------------------------------------------------------------------
# Function: setup         
# Function setup accepts a double-precision floating-point number as an input
# and converts the input into a double-precision floating-point number which
# is between -pi/2 and pi/2 such that sin(input)=sin(output).
# It returns this converted number at the end.
#
# Argument:
#	fa0: a double-precision floating-point number
#
# Return:
#	fa0: a double-precision floating-point number, which is between -pi/2 and pi/2
# 
# Register Usage:
#        fs0: contain float 0.0 which is used for comparisions
#        fs1: contain the argument(input) 
#	 ft1-4: are used to contain values of pi, 2pi, pi/2 etc
#	 t0: consistently used to contain output from float comparision
#	 t1: contain 1 which is used for comparisions
#	 t registers are also used some miscellaneous actions
#------------------------------------------------------------------------------------------------------
# 
	setup:
		addi 	sp, sp, -20 #save ra, fs0 and fs1 to stack
		sw 	ra, 16(sp)
		fsd 	fs0, 8(sp)
		fsd 	fs1, 0(sp)
	
		la 	t0, fzero #load addr for float 0
		fld 	fs0, 0(t0) #load float 0
		
		li 	t1, 1 #set t1 to 1 for comparison 
		fmv.d 	fs1, fa0 # fs1 <- input value
		
		feq.d 	t0, fs1, fs0 #if input is 0
		beq 	t0, t1, retzero #branch if input is zero
		
		fgt.d 	t0, fs1, fs0 #if input is positive
		beq 	t0, t1, inpos #branch if input is positive
		j 	n_inpos #jump to n_inpos if input is negative
		
		#following section is if input is positive----------------
		inpos: #check further if input is positive
			la 	t0, pim2 #load addr for 2 * pi
			fld 	ft1, 0(t0) #load 2 * pi
		
			fgt.d 	t0, fs1, ft1 #if input is greater than 2 * pi
			beq 	t0, t1, reducePos #branch if input > 2 * pi
			j 	checkPos #jump to checkPos if already in range of 2 * pi
		
		reducePos: #reduce input to range of 2 * pi
			fsub.d 	fs1, fs1, ft1 #input - 2 * pi
			fgt.d 	t0, fs1, ft1 #continue loop if input > 2 * pi
			beq 	t0, t1, reducePos
			j 	checkPos #move to next step if within range
		
		checkPos: #check position relative to pi
			la 	t0, pid2 #load addr for pi / 2
			fld 	ft2, 0(t0) #load pi / 2
			la 	t0, pie #load addr for pi
			fld 	ft3, 0(t0) #load pi
			la 	t0, piq #load addr for 3pi/ 2
			fld 	ft4, 0(t0) #load 3pi/ 2
		
			fle.d 	t0, fs1, ft2 #branch if input <= pi / 2
			beq 	t0, t1, retdirect 
		
			fle.d 	t0, fs1, ft4 #branch if input <= 3pi /2
			beq 	t0, t1, lessquatpi
		
			#input is greater than 3pi/2, will setup and return 
			fsub.d 	fs1, fs1, ft3 #input - pi
			fsub.d 	fa0, fs1, ft3 #input - 2*pi
			j 	setupEnd
		
			lessquatpi: #sets up input and returns (<3pi/2)
			fsub.d 	fa0, ft3, fs1 #pi - input
			j 	setupEnd
		
		#following section is if input is negative----------------
		n_inpos: #check further if input is positive
			la 	t0, n_pim2 #load addr for -2 * pi
			fld 	ft1, 0(t0) #load -2 * pi
		
			flt.d 	t0, fs1, ft1 #if input is lesser than -2 * pi
			beq 	t0, t1, n_reducePos #branch if input < -2 * pi
			j 	n_checkPos #jump to checkPos if already in range of -2 * pi
		
		n_reducePos: #reduce input to range of -2 * pi
			fsub.d 	fs1, fs1, ft1 #input - (-2 * pi)
			flt.d 	t0, fs1, ft1 #continue loop if input < -2 * pi
			beq 	t0, t1, n_reducePos
			j 	n_checkPos #move to next step if within range
		
		n_checkPos: #check position relative to -pi
			la 	t0, n_pid2 #load addr for -pi / 2
			fld 	ft2, 0(t0) #load -pi / 2
			la 	t0, n_pie #load addr for -pi
			fld 	ft3, 0(t0) #load -pi
			la 	t0, n_piq #load addr for -3pi/ 2
			fld 	ft4, 0(t0) #load -3pi/ 2
		
			fge.d 	t0, fs1, ft2 #branch if input >= -pi / 2
			beq 	t0, t1, retdirect 
		
			fge.d 	t0, fs1, ft4 #branch if input >= -3pi /2
			beq 	t0, t1, n_lessquatpi
		
			#input is less than -3pi/2, will setup and return 
			fsub.d 	fs1, fs1, ft3 #input - (-pi)
			fsub.d 	fa0, fs1, ft3 #input - (-2*pi)
			j 	setupEnd
		
			n_lessquatpi: #sets up input and returns (> -3pi/2)
			fsub.d 	fa0, ft3, fs1 #-pi - (-input)
			j 	setupEnd
		
		#following section is end of setup---------------
		retdirect: #returns if input is within approximation range already
			fmv.d 	fa0, fs1 
			j 	setupEnd
		
		retzero: #return zero if input is zero
			fmv.d 	fa0, fs1 
			j 	setupEnd
		
		setupEnd: #end of setup
			lw 	ra, 16(sp) #load ra, fs0 and fs1 back from stack and return
			fld 	fs0, 8(sp)
			fld 	fs1, 0(sp)
			addi 	sp, sp, 20
		
			jalr	zero, ra, 0
		 
#------------------------------------------------------------------------------------------------------
# Function: sin       
# Function sin accepts a double-precision floating-point number as an input
# and converts the input into a double-precision floating-point number which
# is the approximate value of sin(input).
# Function sin calls function setup to convert input into a acceptable range
# so that it can be used for approximation.
# It returns this converted number at the end.
#
# Argument:
#	fa0: a double-precision floating-point number
#
# Return:
#	fa0: a double-precision floating-point number, which is the approximate value of sin(input)
# 
# Register Usage:
#	 fa0: used as an argument for setup function which this function calls
#	 ft0-3: are used to contain values of variables which are used for approximation
#	 t0: mostly used to load addresses of varibales used for approximation 
#------------------------------------------------------------------------------------------------------
# 	
	sin:
		addi 	sp, sp, -4 #save ra to stack
		sw 	ra, 0(sp)
		
		jal 	setup #argument is already in fa0 and call setup to get input in range
		
		fmv.d	ft0, fa0 #ft0 <- output from setup
		fmul.d 	ft1, ft0, ft0 #y^2
	
		la 	t0, var1
		fld 	ft3, 0(t0) #var1 (0.0000000000000027)
		fmul.d 	ft2, ft1, ft3 #0.0000000000000027 * y^2
	
		la 	t0, var2
		fld 	ft3, 0(t0) #var2 (-0.0000000000007643)
		fadd.d 	ft2, ft2, ft3 #-0.0000000000007643 + 0.0001848814028861 * y^2
	
		fmul.d 	ft2, ft2, ft1 #f^2 * (-0.0000000000007643 + 0.0001848814028861 * y^2)
	
		la 	t0, var3
		fld 	ft3, 0(t0) #var3 (0.0000000001605894)
		fadd.d 	ft2, ft2, ft3 #0.0000000001605894 + f^2 * (-0.0000000000007643 + 0.0001848814028861 * y^2)
	
		fmul.d 	ft2, ft2, ft1 #y^2 * ft2
	
		la 	t0, var4
		fld 	ft3, 0(t0) #var4 (-0.0000000250521068)
		fadd.d 	ft2, ft2, ft3 #-0.0000000250521068 + ft2
	
		fmul.d 	ft2, ft2, ft1 #y^2 *ft2
	
		la 	t0, var5
		fld 	ft3, 0(t0) #var5 (0.0000027557319210)
		fadd.d 	ft2, ft2, ft3 #0.0000027557319210 + ft2
	
		fmul.d 	ft2, ft2, ft1 #y^2 *ft2
	
		la 	t0, var6
		fld 	ft3, 0(t0) #var6 (-0.0001984126984120)
		fadd.d 	ft2, ft2, ft3 #-0.0001984126984120 + ft2
	
		fmul.d 	ft2, ft2, ft1 #y^2 *ft2
	
		la 	t0, var7
		fld 	ft3, 0(t0) #var7 (0.0083333333333332)
		fadd.d 	ft2, ft2, ft3 #0.0083333333333332 + ft2
	
		fmul.d 	ft2, ft2, ft1 #y^2 *ft2
	
		la 	t0, var8
		fld 	ft3, 0(t0) #var8 (-0.1666666666666667)
		fadd.d 	ft2, ft2, ft3 #-0.1666666666666667 + ft2
	
		fmul.d 	ft2, ft2, ft1 #y^2 *ft2
		
		la 	t0, var9
		fld 	ft3, 0(t0) #var9 (1.0000000000000000)
		fadd.d 	ft2, ft2, ft3 #1.0000000000000000 + ft2
	
		fmul.d 	ft2, ft2, ft0 #y *ft2
		fmv.d 	fa0, ft2
		
		lw 	ra, 0(sp) #load ra from stack
		addi 	sp, sp, 4 
		jalr 	zero, ra, 0
