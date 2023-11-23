""" 
    RiscV32IMC Pipelined Processor, staging script
    Copyright (C) 2023 Ahmed Waseem

    This program is free software; you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation; either version 2 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License along
    with this program; if not, write to the Free Software Foundation, Inc.,
    51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.

"""

import os
import shutil

#class to access ANSI color formatting
#should be cross platform, tested on powershell, no idea about cmd, definitely works on unix
class bcolors:
    HEADER      = '\033[95m' #purple
    OKBLUE      = '\033[94m'
    OKCYAN      = '\033[96m'
    OKGREEN     = '\033[92m'
    WARNING     = '\033[93m' #yellow pretty much
    FAIL        = '\033[91m' #red
    ENDC        = '\033[0m'  #return to default
    BOLD        = '\033[1m'
    UNDERLINE   = '\033[4m'

#displays test cases in directory and takes input, according to input calls stage_test_case
def display_test_case_pairs():
    test_cases_dir = 'test_cases'

    mem_files = [file for file in os.listdir(test_cases_dir) if file.endswith('.mem')]

    test_case_pairs = []
    for file in mem_files:
        if file.endswith('_ini.mem'):
            base_file = file.replace('_ini.mem', '.mem')
            if base_file in mem_files:
                test_case_pairs.append((base_file, file))

    print(f"{bcolors.HEADER} {bcolors.UNDERLINE}\nChoose your test case:\n{bcolors.ENDC}")
    for idx, pair in enumerate(test_case_pairs, start=1):
        print(f"{idx}. {pair[0]} \n   {pair[1]}\n")

    choice = input(f"{bcolors.OKCYAN}Enter the number of the test case to stage: {bcolors.ENDC}")

    #validation loop
    valid = choice.isnumeric() and (0 < int(choice) <= len(test_case_pairs))  
    while (valid == 0):
        print(bcolors.FAIL, "\nInvalid choice. Please enter a valid number.\n", bcolors.ENDC)
        choice = input(f"{bcolors.OKCYAN}Enter the number of the test case to stage: {bcolors.ENDC}")
        valid = choice.isnumeric() and (0 < int(choice) <= len(test_case_pairs))  

    chosen_test_case = test_case_pairs[int(choice) - 1]
    stage_test_case(test_cases_dir, chosen_test_case)

#stages the chosen test cases in the given staging file
#staging files are hardcoded for now
def stage_test_case(directory, test_case):
    base_file, ini_file = test_case
    src_base_path = os.path.join(directory, base_file)
    src_ini_path = os.path.join(directory, ini_file)
    dest_asm_path = 'riscv_asm.mem'
    dest_ini_path = 'riscv_ini.mem'

    shutil.copyfile(src_base_path, dest_asm_path)
    shutil.copyfile(src_ini_path, dest_ini_path)

    print(f"\n{bcolors.OKGREEN}Test case {base_file} - {ini_file} staged successfully as riscv_asm.mem and riscv_ini.mem! {bcolors.ENDC} ")

display_test_case_pairs()
