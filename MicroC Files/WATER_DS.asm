
_main:

;WATER_DS.c,16 :: 		void main() {
;WATER_DS.c,19 :: 		Lcd_Init();
	CALL       _Lcd_Init+0
;WATER_DS.c,20 :: 		Lcd_Cmd(_LCD_CLEAR);          // Clear display
	MOVLW      1
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;WATER_DS.c,21 :: 		Lcd_Cmd(_LCD_CURSOR_OFF);     // Cursor off
	MOVLW      12
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;WATER_DS.c,23 :: 		TRISB = 0b00010000;           //RB4 as input PIN (ECHO)
	MOVLW      16
	MOVWF      TRISB+0
;WATER_DS.c,25 :: 		Lcd_Out(1,1," Water Distribution");
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr1_WATER_DS+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;WATER_DS.c,26 :: 		Lcd_Out(2,1,"   System");
	MOVLW      2
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr2_WATER_DS+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;WATER_DS.c,28 :: 		Delay_ms(3000);
	MOVLW      31
	MOVWF      R11+0
	MOVLW      113
	MOVWF      R12+0
	MOVLW      30
	MOVWF      R13+0
L_main0:
	DECFSZ     R13+0, 1
	GOTO       L_main0
	DECFSZ     R12+0, 1
	GOTO       L_main0
	DECFSZ     R11+0, 1
	GOTO       L_main0
	NOP
;WATER_DS.c,29 :: 		Lcd_Cmd(_LCD_CLEAR);
	MOVLW      1
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;WATER_DS.c,31 :: 		T1CON = 0x10;                 //Initialize Timer Module
	MOVLW      16
	MOVWF      T1CON+0
;WATER_DS.c,33 :: 		while(1)
L_main1:
;WATER_DS.c,36 :: 		TMR1H = 0;                  //Sets the initial value of Timer
	CLRF       TMR1H+0
;WATER_DS.c,37 :: 		TMR1L = 0;                  //Sets the initial value of Timer
	CLRF       TMR1L+0
;WATER_DS.c,39 :: 		PORTB.F0 = 1;               //TRIGGER HIGH
	BSF        PORTB+0, 0
;WATER_DS.c,40 :: 		Delay_us(10);               //10uS Delay
	MOVLW      6
	MOVWF      R13+0
L_main3:
	DECFSZ     R13+0, 1
	GOTO       L_main3
	NOP
;WATER_DS.c,41 :: 		PORTB.F0 = 0;               //TRIGGER LOW
	BCF        PORTB+0, 0
;WATER_DS.c,43 :: 		while(!PORTB.F4);           //Waiting for Echo
L_main4:
	BTFSC      PORTB+0, 4
	GOTO       L_main5
	GOTO       L_main4
L_main5:
;WATER_DS.c,44 :: 		T1CON.F0 = 1;               //Timer Starts
	BSF        T1CON+0, 0
;WATER_DS.c,45 :: 		while(PORTB.F4);            //Waiting for Echo goes LOW
L_main6:
	BTFSS      PORTB+0, 4
	GOTO       L_main7
	GOTO       L_main6
L_main7:
;WATER_DS.c,46 :: 		T1CON.F0 = 0;               //Timer Stops
	BCF        T1CON+0, 0
;WATER_DS.c,49 :: 		TRISA.RA0 = 0; //PORTA as output
	BCF        TRISA+0, 0
;WATER_DS.c,50 :: 		TRISA.RA1 = 0; //PORTA as output
	BCF        TRISA+0, 1
;WATER_DS.c,51 :: 		TRISE.RE0 = 0; //PORTE as output
	BCF        TRISE+0, 0
;WATER_DS.c,52 :: 		TRISE.RE1 = 0; //PORTC as output
	BCF        TRISE+0, 1
;WATER_DS.c,53 :: 		PORTC.RC1 = 0; //CCP1/RC2 Pin as PWM1
	BCF        PORTC+0, 1
;WATER_DS.c,54 :: 		PORTC.RC2 = 0; //CCP2/RC1 Pin as PWM2
	BCF        PORTC+0, 2
;WATER_DS.c,56 :: 		a = (TMR1L | (TMR1H<<8));   //Reads Timer Value
	MOVF       TMR1H+0, 0
	MOVWF      R0+1
	CLRF       R0+0
	MOVF       TMR1L+0, 0
	IORWF      R0+0, 1
	MOVLW      0
	IORWF      R0+1, 1
	MOVF       R0+0, 0
	MOVWF      main_a_L0+0
	MOVF       R0+1, 0
	MOVWF      main_a_L0+1
;WATER_DS.c,57 :: 		a = a/58.82;                //Converts Time to Distance (Depth)
	CALL       _int2double+0
	MOVLW      174
	MOVWF      R4+0
	MOVLW      71
	MOVWF      R4+1
	MOVLW      107
	MOVWF      R4+2
	MOVLW      132
	MOVWF      R4+3
	CALL       _Div_32x32_FP+0
	CALL       _double2int+0
	MOVF       R0+0, 0
	MOVWF      main_a_L0+0
	MOVF       R0+1, 0
	MOVWF      main_a_L0+1
;WATER_DS.c,58 :: 		a = a + 1;                  //Distance Calibration (Depth)
	MOVF       R0+0, 0
	ADDLW      1
	MOVWF      R2+0
	MOVLW      0
	BTFSC      STATUS+0, 0
	ADDLW      1
	ADDWF      R0+1, 0
	MOVWF      R2+1
	MOVF       R2+0, 0
	MOVWF      main_a_L0+0
	MOVF       R2+1, 0
	MOVWF      main_a_L0+1
;WATER_DS.c,61 :: 		if(a>=300 && a<=400)          //Check the water level(Water depth)
	MOVLW      128
	XORWF      R2+1, 0
	MOVWF      R0+0
	MOVLW      128
	XORLW      1
	SUBWF      R0+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main26
	MOVLW      44
	SUBWF      R2+0, 0
L__main26:
	BTFSS      STATUS+0, 0
	GOTO       L_main10
	MOVLW      128
	XORLW      1
	MOVWF      R0+0
	MOVLW      128
	XORWF      main_a_L0+1, 0
	SUBWF      R0+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main27
	MOVF       main_a_L0+0, 0
	SUBLW      144
L__main27:
	BTFSS      STATUS+0, 0
	GOTO       L_main10
L__main24:
;WATER_DS.c,63 :: 		IntToStr(a,txt);
	MOVF       main_a_L0+0, 0
	MOVWF      FARG_IntToStr_input+0
	MOVF       main_a_L0+1, 0
	MOVWF      FARG_IntToStr_input+1
	MOVLW      main_txt_L0+0
	MOVWF      FARG_IntToStr_output+0
	CALL       _IntToStr+0
;WATER_DS.c,64 :: 		Ltrim(txt);
	MOVLW      main_txt_L0+0
	MOVWF      FARG_Ltrim_string+0
	CALL       _Ltrim+0
;WATER_DS.c,65 :: 		Lcd_Cmd(_LCD_CLEAR);
	MOVLW      1
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;WATER_DS.c,66 :: 		Lcd_Out(1,1,"Water L. = ");
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr3_WATER_DS+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;WATER_DS.c,67 :: 		Lcd_Out(1,12,txt);
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      12
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      main_txt_L0+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;WATER_DS.c,68 :: 		Lcd_Out(1,15,"cm");
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      15
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr4_WATER_DS+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;WATER_DS.c,69 :: 		Lcd_Out(2,1,"WPM=Sp WDM=H");
	MOVLW      2
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr5_WATER_DS+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;WATER_DS.c,71 :: 		TRISE.RE0 = 1;   //Enable RE0 Pin
	BSF        TRISE+0, 0
;WATER_DS.c,72 :: 		TRISE.RE1 = 0;
	BCF        TRISE+0, 1
;WATER_DS.c,73 :: 		PORTC.RC2 = 1; //Enable CCP2 Pin(PWM2)
	BSF        PORTC+0, 2
;WATER_DS.c,75 :: 		PWM2_Init(5000);    //Initialize PWM2
	BSF        T2CON+0, 0
	BCF        T2CON+0, 1
	MOVLW      99
	MOVWF      PR2+0
	CALL       _PWM2_Init+0
;WATER_DS.c,76 :: 		PWM2_Start();  //start PWM2
	CALL       _PWM2_Start+0
;WATER_DS.c,77 :: 		PWM2_Set_Duty(255); //Set current duty for PWM2
	MOVLW      255
	MOVWF      FARG_PWM2_Set_Duty_new_duty+0
	CALL       _PWM2_Set_Duty+0
;WATER_DS.c,79 :: 		}
L_main10:
;WATER_DS.c,80 :: 		if(a>=200 && a<=300)          //Check the water level(Water depth)
	MOVLW      128
	XORWF      main_a_L0+1, 0
	MOVWF      R0+0
	MOVLW      128
	SUBWF      R0+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main28
	MOVLW      200
	SUBWF      main_a_L0+0, 0
L__main28:
	BTFSS      STATUS+0, 0
	GOTO       L_main13
	MOVLW      128
	XORLW      1
	MOVWF      R0+0
	MOVLW      128
	XORWF      main_a_L0+1, 0
	SUBWF      R0+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main29
	MOVF       main_a_L0+0, 0
	SUBLW      44
L__main29:
	BTFSS      STATUS+0, 0
	GOTO       L_main13
L__main23:
;WATER_DS.c,82 :: 		IntToStr(a,txt);
	MOVF       main_a_L0+0, 0
	MOVWF      FARG_IntToStr_input+0
	MOVF       main_a_L0+1, 0
	MOVWF      FARG_IntToStr_input+1
	MOVLW      main_txt_L0+0
	MOVWF      FARG_IntToStr_output+0
	CALL       _IntToStr+0
;WATER_DS.c,83 :: 		Ltrim(txt);
	MOVLW      main_txt_L0+0
	MOVWF      FARG_Ltrim_string+0
	CALL       _Ltrim+0
;WATER_DS.c,84 :: 		Lcd_Cmd(_LCD_CLEAR);
	MOVLW      1
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;WATER_DS.c,85 :: 		Lcd_Out(1,1,"Water L. = ");
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr6_WATER_DS+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;WATER_DS.c,86 :: 		Lcd_Out(1,12,txt);
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      12
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      main_txt_L0+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;WATER_DS.c,87 :: 		Lcd_Out(1,15,"cm");
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      15
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr7_WATER_DS+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;WATER_DS.c,88 :: 		Lcd_Out(2,1,"WPM=L WDM=M");
	MOVLW      2
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr8_WATER_DS+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;WATER_DS.c,90 :: 		TRISA.RA0 = 1;        //Enable RA0 Pin
	BSF        TRISA+0, 0
;WATER_DS.c,91 :: 		TRISA.RA1 = 0;
	BCF        TRISA+0, 1
;WATER_DS.c,92 :: 		TRISE.RE0 = 1;      //Enable RE0 Pin
	BSF        TRISE+0, 0
;WATER_DS.c,93 :: 		TRISE.RE1 = 0;
	BCF        TRISE+0, 1
;WATER_DS.c,94 :: 		PORTC.RC1 = 1;      //Enable CCP1 Pin(PWM1)
	BSF        PORTC+0, 1
;WATER_DS.c,95 :: 		PORTC.RC2 = 1;      //Enable CCP2 Pin(PWM2)
	BSF        PORTC+0, 2
;WATER_DS.c,97 :: 		PWM1_Init(5000);  //Initialize PWM1
	BSF        T2CON+0, 0
	BCF        T2CON+0, 1
	MOVLW      99
	MOVWF      PR2+0
	CALL       _PWM1_Init+0
;WATER_DS.c,98 :: 		PWM1_Start();  //start PWM1
	CALL       _PWM1_Start+0
;WATER_DS.c,99 :: 		PWM1_Set_Duty(85); //Set current duty for PWM1
	MOVLW      85
	MOVWF      FARG_PWM1_Set_Duty_new_duty+0
	CALL       _PWM1_Set_Duty+0
;WATER_DS.c,101 :: 		PWM2_Init(5000);  //Initialize PWM2
	BSF        T2CON+0, 0
	BCF        T2CON+0, 1
	MOVLW      99
	MOVWF      PR2+0
	CALL       _PWM2_Init+0
;WATER_DS.c,102 :: 		PWM2_Start();  //start PWM2
	CALL       _PWM2_Start+0
;WATER_DS.c,103 :: 		PWM2_Set_Duty(170); //Set current duty for PWM2
	MOVLW      170
	MOVWF      FARG_PWM2_Set_Duty_new_duty+0
	CALL       _PWM2_Set_Duty+0
;WATER_DS.c,105 :: 		}
L_main13:
;WATER_DS.c,107 :: 		if(a>=100 && a<=200)          //Check the water level(Water depth)
	MOVLW      128
	XORWF      main_a_L0+1, 0
	MOVWF      R0+0
	MOVLW      128
	SUBWF      R0+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main30
	MOVLW      100
	SUBWF      main_a_L0+0, 0
L__main30:
	BTFSS      STATUS+0, 0
	GOTO       L_main16
	MOVLW      128
	MOVWF      R0+0
	MOVLW      128
	XORWF      main_a_L0+1, 0
	SUBWF      R0+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main31
	MOVF       main_a_L0+0, 0
	SUBLW      200
L__main31:
	BTFSS      STATUS+0, 0
	GOTO       L_main16
L__main22:
;WATER_DS.c,109 :: 		IntToStr(a,txt);
	MOVF       main_a_L0+0, 0
	MOVWF      FARG_IntToStr_input+0
	MOVF       main_a_L0+1, 0
	MOVWF      FARG_IntToStr_input+1
	MOVLW      main_txt_L0+0
	MOVWF      FARG_IntToStr_output+0
	CALL       _IntToStr+0
;WATER_DS.c,110 :: 		Ltrim(txt);
	MOVLW      main_txt_L0+0
	MOVWF      FARG_Ltrim_string+0
	CALL       _Ltrim+0
;WATER_DS.c,111 :: 		Lcd_Cmd(_LCD_CLEAR);
	MOVLW      1
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;WATER_DS.c,112 :: 		Lcd_Out(1,1,"Water L. = ");
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr9_WATER_DS+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;WATER_DS.c,113 :: 		Lcd_Out(1,12,txt);
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      12
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      main_txt_L0+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;WATER_DS.c,114 :: 		Lcd_Out(1,15,"cm");
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      15
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr10_WATER_DS+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;WATER_DS.c,115 :: 		Lcd_Out(2,1,"WPM=M WDM=L");
	MOVLW      2
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr11_WATER_DS+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;WATER_DS.c,117 :: 		TRISA.RA0 = 1;      //Enable RA0 Pin
	BSF        TRISA+0, 0
;WATER_DS.c,118 :: 		TRISA.RA1 = 0;
	BCF        TRISA+0, 1
;WATER_DS.c,119 :: 		TRISE.RE0 = 1;      //Enable RE0 Pin
	BSF        TRISE+0, 0
;WATER_DS.c,120 :: 		TRISE.RE1 = 0;
	BCF        TRISE+0, 1
;WATER_DS.c,121 :: 		PORTC.RC1 = 1;      //Enable CCP1 Pin(PWM1)
	BSF        PORTC+0, 1
;WATER_DS.c,122 :: 		PORTC.RC2 = 1;      //Enable CCP2 Pin(PWM2)
	BSF        PORTC+0, 2
;WATER_DS.c,124 :: 		PWM1_Init(5000);  //Initialize PWM1
	BSF        T2CON+0, 0
	BCF        T2CON+0, 1
	MOVLW      99
	MOVWF      PR2+0
	CALL       _PWM1_Init+0
;WATER_DS.c,125 :: 		PWM1_Start();  //start PWM1
	CALL       _PWM1_Start+0
;WATER_DS.c,126 :: 		PWM1_Set_Duty(170); //Set current duty for PWM1
	MOVLW      170
	MOVWF      FARG_PWM1_Set_Duty_new_duty+0
	CALL       _PWM1_Set_Duty+0
;WATER_DS.c,128 :: 		PWM2_Init(5000);  //Initialize PWM2
	BSF        T2CON+0, 0
	BCF        T2CON+0, 1
	MOVLW      99
	MOVWF      PR2+0
	CALL       _PWM2_Init+0
;WATER_DS.c,129 :: 		PWM2_Start();  //start PWM2
	CALL       _PWM2_Start+0
;WATER_DS.c,130 :: 		PWM2_Set_Duty(85); //Set current duty for PWM2
	MOVLW      85
	MOVWF      FARG_PWM2_Set_Duty_new_duty+0
	CALL       _PWM2_Set_Duty+0
;WATER_DS.c,131 :: 		}
L_main16:
;WATER_DS.c,133 :: 		if(a>=0 && a<=100)          //Check the water level(Water depth)
	MOVLW      128
	XORWF      main_a_L0+1, 0
	MOVWF      R0+0
	MOVLW      128
	SUBWF      R0+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main32
	MOVLW      0
	SUBWF      main_a_L0+0, 0
L__main32:
	BTFSS      STATUS+0, 0
	GOTO       L_main19
	MOVLW      128
	MOVWF      R0+0
	MOVLW      128
	XORWF      main_a_L0+1, 0
	SUBWF      R0+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main33
	MOVF       main_a_L0+0, 0
	SUBLW      100
L__main33:
	BTFSS      STATUS+0, 0
	GOTO       L_main19
L__main21:
;WATER_DS.c,135 :: 		IntToStr(a,txt);
	MOVF       main_a_L0+0, 0
	MOVWF      FARG_IntToStr_input+0
	MOVF       main_a_L0+1, 0
	MOVWF      FARG_IntToStr_input+1
	MOVLW      main_txt_L0+0
	MOVWF      FARG_IntToStr_output+0
	CALL       _IntToStr+0
;WATER_DS.c,136 :: 		Ltrim(txt);
	MOVLW      main_txt_L0+0
	MOVWF      FARG_Ltrim_string+0
	CALL       _Ltrim+0
;WATER_DS.c,137 :: 		Lcd_Cmd(_LCD_CLEAR);
	MOVLW      1
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;WATER_DS.c,138 :: 		Lcd_Out(1,1,"Water L. = ");
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr12_WATER_DS+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;WATER_DS.c,139 :: 		Lcd_Out(1,12,txt);
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      12
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      main_txt_L0+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;WATER_DS.c,140 :: 		Lcd_Out(1,15,"cm");
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      15
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr13_WATER_DS+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;WATER_DS.c,141 :: 		Lcd_Out(2,1,"WPM=H WDM=Sp");
	MOVLW      2
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr14_WATER_DS+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;WATER_DS.c,143 :: 		TRISA.RA0 = 1;     //Enable RA0 Pin
	BSF        TRISA+0, 0
;WATER_DS.c,144 :: 		TRISA.RA1 = 0;
	BCF        TRISA+0, 1
;WATER_DS.c,145 :: 		TRISE.RE0 = 0;     //Disable RE0 Pin
	BCF        TRISE+0, 0
;WATER_DS.c,146 :: 		TRISE.RE1 = 0;
	BCF        TRISE+0, 1
;WATER_DS.c,147 :: 		PORTC.RC1 = 1;     //Enable CCP1 Pin(PWM1)
	BSF        PORTC+0, 1
;WATER_DS.c,148 :: 		PORTC.RC2 = 0;     //Disable CCP2 Pin(PWM2)
	BCF        PORTC+0, 2
;WATER_DS.c,150 :: 		PWM1_Init(5000);  //Insitialize PWM1
	BSF        T2CON+0, 0
	BCF        T2CON+0, 1
	MOVLW      99
	MOVWF      PR2+0
	CALL       _PWM1_Init+0
;WATER_DS.c,151 :: 		PWM1_Start();  //start PWM1
	CALL       _PWM1_Start+0
;WATER_DS.c,152 :: 		PWM1_Set_Duty(255); //Set current duty for PWM1
	MOVLW      255
	MOVWF      FARG_PWM1_Set_Duty_new_duty+0
	CALL       _PWM1_Set_Duty+0
;WATER_DS.c,154 :: 		PWM2_Init(5000);  //Initialize PWM2
	BSF        T2CON+0, 0
	BCF        T2CON+0, 1
	MOVLW      99
	MOVWF      PR2+0
	CALL       _PWM2_Init+0
;WATER_DS.c,155 :: 		PWM2_Start();  //start PWM2
	CALL       _PWM2_Start+0
;WATER_DS.c,156 :: 		PWM2_Set_Duty(0); //Set current duty for PWM2
	CLRF       FARG_PWM2_Set_Duty_new_duty+0
	CALL       _PWM2_Set_Duty+0
;WATER_DS.c,158 :: 		}
L_main19:
;WATER_DS.c,160 :: 		Delay_ms(400);
	MOVLW      5
	MOVWF      R11+0
	MOVLW      15
	MOVWF      R12+0
	MOVLW      241
	MOVWF      R13+0
L_main20:
	DECFSZ     R13+0, 1
	GOTO       L_main20
	DECFSZ     R12+0, 1
	GOTO       L_main20
	DECFSZ     R11+0, 1
	GOTO       L_main20
;WATER_DS.c,161 :: 		}
	GOTO       L_main1
;WATER_DS.c,162 :: 		}
L_end_main:
	GOTO       $+0
; end of _main
