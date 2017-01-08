.data

names: .space 16 	# Allocated 16 bytes of space

Ryan:  .asciiz "Ryan\n"
Tammi: .asciiz "Tammi\n"
Blake: .asciiz "Blake\n"
Josh:  .asciiz "Josh\n"


.text
main:

la $t0, names

la $t1, Ryan
sw $t1, 0($t0)

