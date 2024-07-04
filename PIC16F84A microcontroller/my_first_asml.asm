RESET CODE 0x000
    goto    main          ; go to start of main code


ISR CODE 0x004
    goto    interrupt      ; go to start of interrupt code

MAIN CODE
interrupt
    
main
	  MOVLW 08h 	; Move k = 8 to W. W = 8
	  ADDLW 08h	; Add W = 8 with k = 8. W = 16
	  MOVWF 18h	; Move W = 15 to F address 18h. F = 16
	  SUBLW 1Ch	; Sub k = 28 with W = 16. W = 12	  
	  ADDWF 18h,1 	; Add W = 12 with F = 16. F = 28
	  ADDWF 18h,0 	; Add W = 12 with F = 28. W = 40
	  ANDWF 18h,0	; And W = 0001 1100 with F = 0010 0110. W = 0000 0100 = 8
	  MOVF 18h,0 	; Move F to W. W = 28
	  MOVWF 19h	; Move W = 28 to F address 19h. F = 28
	  BCF 18h,2 	; Clear bit 2 of F. F = 0001 1000 = 24
	  BSF 1Ch,4 	; Set bit 4 of F. F = 0001 0000 = 16
	  CALL 11h	; Call subroutine. 
	  INCF 20h,1 	; F = 1
	  XORWF 20h,0 	; 0000 0001 xor 0001 1100. W = 0000 0001 = 0
	  MOVLW 08h 	; Move k = 8 to W. W = 8
	  MOVWF 1Dh 	; Move W = 8 to F addr 1Dh
	  RETURN 	; Return to subroutine 
	  
end
