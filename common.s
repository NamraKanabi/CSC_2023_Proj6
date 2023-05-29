
.eqv PrintDouble 3
.eqv PrintString 4
.eqv Exit 93
.eqv STOP 5107.5107
.data 
pi: 		.double	3.14159265358979323
pi2:		.double	6.28318530717958647
half_pi:	.double	1.57079632679489661
min_rel:	.double 1.0e-30
stop_magic: .double STOP
sin_in_out_rel: .double
	 0.0				 0.0				1.0e-15
	 1.00000000000000000e-17	 9.99999999999999999e-18	1.0
	 1.00000000000000000e-16	 9.99999999999999999e-17	1.0e-2
	 1.00000000000000000e-15	 9.99999999999999999e-16	1.0e-3
	 1.00000000000000000e-14	 9.99999999999999999e-15	1.0e-4
	 1.00000000000000000e-13	 9.99999999999999999e-14	1.0e-5
	 1.00000000000000000e-12	 9.99999999999999999e-13	1.0e-6
	 1.00000000000000000e-11	 9.99999999999999999e-12	1.0e-7
	 1.00000000000000000e-10	 9.99999999999999999e-11	1.0e-8
	 1.00000000000000000e-9	 9.99999999999999999e-10	1.0e-9
	 1.00000000000000000e-8	 9.99999999999999983e-9	1.0e-10
	 1.00000000000000000e-7	 9.99999999999998333e-8	1.0e-11
	 1.00000000000000000e-6	 9.99999999999833333e-7	1.0e-12
	 1.00000000000000000e-5	 9.99999999983333333e-6	1.0e-13
	 1.00000000000000000e-4        9.99999998333333334e-5	1.0e-14
	 1.00000000000000000e-3	 9.99999833333341666e-4	1.0e-15
	 1.00000000000000000e-2	 9.99983333416666468e-3	1.0e-15
	 1.00000000000000000e-1	 9.98334166468281523e-2	1.0e-15
	 1.0				 8.41470984807896506e-1	1.0e-15
	-1.0				-8.41470984807896506e-1	1.0e-15
	 2.0				 9.09297426825681695e-1	1.0e-15
	-2.0				-9.09297426825681695e-1	1.0e-15
	 3.0				 1.41120008059867222e-1	1.0e-15
	-3.0				-1.41120008059867222e-1	1.0e-15
	 4.0				-7.56802495307928251e-1	1.0e-15
	-4.0				 7.56802495307928251e-1	1.0e-15
	 5.0				-9.58924274663138468e-1	1.0e-15
	-5.0				 9.58924274663138468e-1	1.0e-15
	 6.0				-2.79415498198925872e-1	1.0e-15
	-6.0				 2.79415498198925872e-1	1.0e-15
	 7.0				 6.56986598718789090e-1	1.0e-15
	-7.0				-6.56986598718789090e-1	1.0e-15
	 8.0				 9.89358246623381777e-1	1.0e-15
	-8.0				-9.89358246623381777e-1	1.0e-15
	 9.0				 4.12118485241756569e-1	1.0e-15
	-9.0				-4.12118485241756569e-1	1.0e-15
	 10.0				-5.44021110889369813e-1	1.0e-15
	-10.0				 5.44021110889369813e-1	1.0e-15
	STOP				STOP				STOP

setup_in_out_rel: .double
	 0.0				 0.0				1.0e-15
	-0.0				 0.0				1.0e-15
	 1.0				 1.0				1.0e-15
	-1.0				-1.0				1.0e-15
	 2.0				 1.14159265358979323		1.0e-15
	-2.0				-1.14159265358979323		1.0e-15
	 3.0				 1.41592653589793238e-1	1.0e-15
	-3.0				-1.41592653589793238e-1	1.0e-15
	 4.0				-8.58407346410206761e-1	1.0e-15
	-4.0				 8.58407346410206761e-1	1.0e-15
	 5.0				-1.28318530717958647		1.0e-15
	-5.0				 1.28318530717958647		1.0e-15
	 6.0				-2.83185307179586476e-1	1.0e-15
	-6.0				 2.83185307179586476e-1	1.0e-15
	 7.0				 7.16814692820413523e-1	1.0e-15
	-7.0				-7.16814692820413523e-1	1.0e-15
	 8.0				 1.42477796076937971		1.0e-15
	-8.0				-1.42477796076937971		1.0e-15
	STOP				STOP 				STOP

newline: .asciz "\n"
testing_setup: .asciz "Testing setup:\n"
testing_sin: .asciz "Testing sin:\n"
tester_in: .asciz " in="
tester_out: .asciz " out="
expected_1: .asciz " ( "
expected_2: .asciz " <= "
expected_3: .asciz " <= "
expected_4: .asciz " ) "
tester_ok: .asciz " ok\n"
tester_low: .asciz " low\n"
tester_high: .asciz " high\n"

.text
main:
call testSetup
call testSin
li a7, Exit
li a0, 0
ecall

testSetup:
mv t0, fp
mv fp, sp
addi sp, sp, -16
sw ra, 0(fp)
sw t0, -4(fp) # old fp
	
	li a7, PrintString
	la a0, testing_setup
	ecall
	la a0, setup_in_out_rel
	la a1, setup
	call tester
	
lw ra, 0(fp)
lw t0, -4(fp)
mv sp, fp
mv fp, t0
ret

testSin:
mv t0, fp
mv fp, sp
addi sp, sp, -16
sw ra, 0(fp)
sw t0, -4(fp) # old fp
	
	li a7, PrintString
	la a0, testing_sin
	ecall
	la a0, sin_in_out_rel
	la a1, sin
	call tester
	
lw ra, 0(fp)
lw t0, -4(fp)
mv sp, fp
mv fp, t0
ret

tester:
mv t0, fp
mv fp, sp
addi sp, sp, -128
sw ra, 0(fp)
sw t0, -4(fp) # old fp
sw s1, -8(fp)
sw s2, -12(fp)
fsd fs0, -24(fp)
fsd fs1, -32(fp)
fsd fs2, -40(fp)
fsd fs3, -48(fp)
fsd fs4, -56(fp)
fsd fs5, -64(fp)
fsd fs6, -72(fp)
fsd fs7, -80(fp)
fsd fs8, -88(fp)
	
	mv s2, a0 # address of testin data
	mv s1, a1 # address of function
	la t0, stop_magic
	fld fs0, 0(t0)
	la t0, min_rel
	fld fs8, 0(t0)
		
	testerLoop:
	fld fs1, 0(s2)
	fld fs2, 8(s2)
	fld fs4, 16(s2)

	feq.d t0, fs1, fs0
	bnez t0, testSetupOut
	
	fsgnj.d fs4, fs4, fs2
	fmul.d fs7, fs4, fs2
	flt.d t0, fs8, fs7
	bnez t0, applyDelta
	fmv.d	fs7, fs8
	applyDelta:
	fadd.d fs6, fs2, fs7
	fsub.d fs5, fs2, fs7
	
	feq.d	t0, fs6, fs5
	beqz	t0, rangeOk
	ebreak
	
	rangeOk:
	fmv.d fa0, fs1
	jalr ra, 0(s1) # CALL function under test
	fmv.d fs3, fa0
	
	li a7, PrintString
	la a0, tester_in
	ecall
	fmv.d fa0, fs1
	li a7, PrintDouble
	ecall
	li a7, PrintString
	la a0, tester_out
	ecall
	fmv.d fa0, fs3
	li a7, PrintDouble
	ecall
	li a7, PrintString
	la a0, expected_1
	ecall
	fmv.d fa0, fs5
	li a7, PrintDouble
	ecall
	li a7, PrintString
	la a0, expected_2
	ecall
	fmv.d fa0, fs2
	li a7, PrintDouble
	ecall
	li a7, PrintString
	la a0, expected_3
	ecall
	fmv.d fa0, fs6
	li a7, PrintDouble
	ecall
	li a7, PrintString
	la a0, expected_4
	ecall
	
	fle.d t0, fs5, fs3
	bnez t0, testSetupLT
	li a7, PrintString
	la a0, tester_low
	ecall
	b testSetupNext
	
	testSetupLT:
	fle.d t0, fs3, fs6
	bnez t0, testSetupOk
	li a7, PrintString
	la a0, tester_high
	ecall
	b testSetupNext
	
	testSetupOk:
	li a7, PrintString
	la a0, tester_ok
	ecall
	
	testSetupNext:
	addi s2, s2, 24
	b testerLoop	
	testSetupOut:

lw ra, 0(fp)
lw t0, -4(fp)
sw s1, -8(fp)
sw s2, -12(fp)
fsd fs0, -24(fp)
fsd fs1, -32(fp)
fsd fs2, -40(fp)
fsd fs3, -48(fp)
fsd fs4, -56(fp)
fsd fs5, -64(fp)
fsd fs6, -72(fp)
fsd fs7, -80(fp)
fsd fs8, -88(fp)
mv sp, fp
mv fp, t0
ret


printDoubleLine:
mv t0, fp
mv fp, sp
addi sp, sp, -16
sw ra, 0(fp)
sw t0, -4(fp) # old fp

	li a7, PrintDouble
	ecall
	li a7, PrintString
	la a0, newline
	ecall

lw ra, 0(fp)
lw t0, -4(fp)
mv sp, fp
mv fp, t0
ret
