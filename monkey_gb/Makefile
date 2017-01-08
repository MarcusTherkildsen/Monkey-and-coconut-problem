#OBJS = hello-world-example1.asm
#OBJS = addition.asm
#OBJS = print-number.asm
OBJS = hello-random.asm

OBJS_NAME = bank0

OBJ_NAME = monkey
#OBJ_NAME = arpat

ASM = rgbasm

LINK = rgblink

FIX = rgbfix

all : $(OBJS)
	$(ASM) -o $(OBJS_NAME).obj $(OBJS)
	$(LINK) -m $(OBJ_NAME).map -n $(OBJ_NAME).sym -o $(OBJ_NAME).gb $(OBJS_NAME).obj
	$(FIX) -v $(OBJ_NAME).gb
	rm $(OBJS_NAME).obj $(OBJ_NAME).map $(OBJ_NAME).sym

allrun:
	make
	gambatte --force-dmg --scale 6 $(OBJ_NAME).gb
