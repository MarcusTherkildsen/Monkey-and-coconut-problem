# A lot of help from http://cratel.wichita.edu/cratel/ECE238Spr08/software
#OBJS = hello-world.asm
#OBJS = hello-sprite-no-interrupts.asm
#OBJS = hello-sprite.asm
#OBJS = hello-sprite-good-delay.asm
#OBJS = snd-playback.asm
#OBJS = hello-random.asm
OBJS = hello-score.asm

OBJS_NAME = bank0

OBJ_NAME = monkey

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
