      PROGRAM HELLO
*     The PRINT statement is like WRITE,
*     but prints to the standard output unit
		INTEGER, PARAMETER :: sailors = 5 ! declare a constant, whose value cannot be changed
		INTEGER, PARAMETER :: monkeys = 1 ! declare a constant, whose value cannot be changed
		INTEGER :: j, coconuts_tot, coconuts, coconut_loop, sailor_loop

	  coconuts_tot = 0
	  coconut_loop = 1
10	  IF (coconut_loop .EQ. 1) THEN	 
		coconuts_tot = coconuts_tot + 1
		coconuts = coconuts_tot
		
		
		
		sailor_loop = 1
		j = 0
20		IF (j .LT. sailors) THEN
			j = j + 1	

			IF (sailor_loop .EQ. 1) THEN
		    
				coconuts = coconuts - monkeys
				
				IF (modulo(coconuts, sailors) .NE. 0) THEN
				
					sailor_loop = 0

				ELSE
				
					coconuts = coconuts - coconuts/sailors
					
				ENDIF

			ENDIF
	
        GOTO 20
		ENDIF
		
		
		
		IF (modulo(coconuts, sailors) .EQ. 0) THEN
			
			coconut_loop = 0
		
		ENDIF
		
	  GOTO 10
	  ENDIF
	  
	  PRINT *, 'Solution:', coconuts_tot, 'coconuts to begin with'
	  
      STOP
      END