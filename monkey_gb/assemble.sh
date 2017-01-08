#! /bin/bash
# SIMPLE BASH SCRIPT TO ASSEMBLE GAMEBOY FILES
# REQUIRES MAKELNK.BAT
# JOHN HARRISON
# UPDATED 2008-02-08

function error {
echo "Failed. You can't write code. Give up."
exit
}

if [ -f $1.gb ]
  then
   rm $1.gb
fi
# IF THERE ARE SETTINGS WHICH NEED TO BE DONE ONLY ONCE, PUT THEM BELOW
# if not $ASSEMBLE$1 == 1 goto begin
# path=%path%;c:\gameboy\assembler\
# set dir=c:\gameboy\curren~1\
./makelnk.sh $1 > $1.lnk

export assemble=1
echo "assembling..."
./rgbasm -o$1.obj $1.asm || error
echo linking...
./xlink -mmap $1.lnk || error
echo fixing...
./rgbfix -v $1.gb
