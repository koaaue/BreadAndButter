.data
# constants
five: .float 5.0
nine: .float 9.0
tt2:  .float 32.0
# strings
prompt: .asciiz "\nWhat is degree in F: "
res:   .asciiz "\nDegree in C is: "
# program
.text
main: 
     li $v0, 4 # print a string
     la $a0, prompt
     syscall
     #
     li $v0, 6 # read a single fp number, result will 
     		# be in $f0
     syscall
     #
     jal f2c  # call the conversion routine, $f0 contains F
              # result returnee in $f0
     #
     li $v0, 4 # print a string
     la $a0, res
     syscall
     #
     li $v0, 2 # print a float
     mov.s $f12, $f0 # move result (C) to $f12
     syscall
     j main # loop 
     #  function to do f2c conversion
f2c: lwc1  $f16, five
     lwc1  $f18, nine
     div.s $f16, $f16, $f18 # 5/9 in $f16
     lwc1  $f18, tt2
     sub.s $f18, $f0, $f18 # F - 32.0
     mul.s $f0,  $f16, $f18
     jr    $ra
     
