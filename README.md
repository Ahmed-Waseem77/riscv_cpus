
Ahmed Waseem Raslan 
900211250 

Ahmed Elbarbary 
900213694 

# RV32IMC pipelined processor
This is Computer Architecture project for Fall 23-24. 
Implementing RV32IMC pipelined processor in verilog. 

# Repo Navigation 

	Different branches contain different implementation with default branch being the most extensive

# Verification 

	Predefined RiscV32IMC assembly files are defined in ./test/test_cases

## Yosys
	You will need to include the files ``./test/riscv_asm.mem`` and ``./test/riscv_ini.mem`` and Yosys should automatically pick them up, Then run the ``./test/Choose_test.py`` script to stage your desired test_case.

## Vivado 
	add staging files ``./test/riscv_asm.mem`` and ``./test/riscv_ini.mem`` into your vivado project 
	(do not copy them into project files so script can modify them).

	run the ``./test/Choose_test.py`` script and run vivado's simulation(s)