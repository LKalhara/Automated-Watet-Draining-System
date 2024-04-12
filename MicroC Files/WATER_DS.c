// LCD Display module connections
sbit LCD_RS at RD2_bit;
sbit LCD_EN at RD3_bit;
sbit LCD_D4 at RD4_bit;
sbit LCD_D5 at RD5_bit;
sbit LCD_D6 at RD6_bit;
sbit LCD_D7 at RD7_bit;

sbit LCD_RS_Direction at TRISD2_bit;
sbit LCD_EN_Direction at TRISD3_bit;
sbit LCD_D4_Direction at TRISD4_bit;
sbit LCD_D5_Direction at TRISD5_bit;
sbit LCD_D6_Direction at TRISD6_bit;
sbit LCD_D7_Direction at TRISD7_bit;
// End LCD Display module connections
void main() {
  int a;                      //Initialize a variable for depth
  char txt[7];
  Lcd_Init();
  Lcd_Cmd(_LCD_CLEAR);          // Clear display
  Lcd_Cmd(_LCD_CURSOR_OFF);     // Cursor off

  TRISB = 0b00010000;           //RB4 as input PIN (ECHO)

  Lcd_Out(1,1," Water Distribution");
  Lcd_Out(2,1,"   System");

  Delay_ms(3000);
  Lcd_Cmd(_LCD_CLEAR);

  T1CON = 0x10;                 //Initialize Timer Module

  while(1)
  {

    TMR1H = 0;                  //Sets the initial value of Timer
    TMR1L = 0;                  //Sets the initial value of Timer

    PORTB.F0 = 1;               //TRIGGER HIGH
    Delay_us(10);               //10uS Delay
    PORTB.F0 = 0;               //TRIGGER LOW

    while(!PORTB.F4);           //Waiting for Echo
    T1CON.F0 = 1;               //Timer Starts
    while(PORTB.F4);            //Waiting for Echo goes LOW
    T1CON.F0 = 0;               //Timer Stops


    TRISA.RA0 = 0; //PORTA as output
    TRISA.RA1 = 0; //PORTA as output
    TRISE.RE0 = 0; //PORTE as output
    TRISE.RE1 = 0; //PORTC as output
    PORTC.RC1 = 0; //CCP1/RC2 Pin as PWM1
    PORTC.RC2 = 0; //CCP2/RC1 Pin as PWM2

    a = (TMR1L | (TMR1H<<8));   //Reads Timer Value
    a = a/58.82;                //Converts Time to Distance (Depth)
    a = a + 1;                  //Distance Calibration (Depth)


    if(a>=300 && a<=400)          //Check the water level(Water depth)
    {
      IntToStr(a,txt);
      Ltrim(txt);
      Lcd_Cmd(_LCD_CLEAR);
      Lcd_Out(1,1,"Water L. = ");
      Lcd_Out(1,12,txt);
      Lcd_Out(1,15,"cm");
      Lcd_Out(2,1,"WPM=Sp WDM=H");

      TRISE.RE0 = 1;   //Enable RE0 Pin
      TRISE.RE1 = 0;
      PORTC.RC2 = 1; //Enable CCP2 Pin(PWM2)

      PWM2_Init(5000);    //Initialize PWM2
      PWM2_Start();  //start PWM2
      PWM2_Set_Duty(255); //Set current duty for PWM2

    }
    if(a>=200 && a<=300)          //Check the water level(Water depth)
    {
      IntToStr(a,txt);
      Ltrim(txt);
      Lcd_Cmd(_LCD_CLEAR);
      Lcd_Out(1,1,"Water L. = ");
      Lcd_Out(1,12,txt);
      Lcd_Out(1,15,"cm");
      Lcd_Out(2,1,"WPM=L WDM=M");

      TRISA.RA0 = 1;        //Enable RA0 Pin
      TRISA.RA1 = 0;
      TRISE.RE0 = 1;      //Enable RE0 Pin
      TRISE.RE1 = 0;
      PORTC.RC1 = 1;      //Enable CCP1 Pin(PWM1)
      PORTC.RC2 = 1;      //Enable CCP2 Pin(PWM2)

      PWM1_Init(5000);  //Initialize PWM1
      PWM1_Start();  //start PWM1
      PWM1_Set_Duty(85); //Set current duty for PWM1

      PWM2_Init(5000);  //Initialize PWM2
      PWM2_Start();  //start PWM2
      PWM2_Set_Duty(170); //Set current duty for PWM2

      }

      if(a>=100 && a<=200)          //Check the water level(Water depth)
    {
      IntToStr(a,txt);
      Ltrim(txt);
      Lcd_Cmd(_LCD_CLEAR);
      Lcd_Out(1,1,"Water L. = ");
      Lcd_Out(1,12,txt);
      Lcd_Out(1,15,"cm");
      Lcd_Out(2,1,"WPM=M WDM=L");

      TRISA.RA0 = 1;      //Enable RA0 Pin
      TRISA.RA1 = 0;
      TRISE.RE0 = 1;      //Enable RE0 Pin
      TRISE.RE1 = 0;
      PORTC.RC1 = 1;      //Enable CCP1 Pin(PWM1)
      PORTC.RC2 = 1;      //Enable CCP2 Pin(PWM2)

      PWM1_Init(5000);  //Initialize PWM1
      PWM1_Start();  //start PWM1
      PWM1_Set_Duty(170); //Set current duty for PWM1

      PWM2_Init(5000);  //Initialize PWM2
      PWM2_Start();  //start PWM2
      PWM2_Set_Duty(85); //Set current duty for PWM2
    }

    if(a>=0 && a<=100)          //Check the water level(Water depth)
    {
      IntToStr(a,txt);
      Ltrim(txt);
      Lcd_Cmd(_LCD_CLEAR);
      Lcd_Out(1,1,"Water L. = ");
      Lcd_Out(1,12,txt);
      Lcd_Out(1,15,"cm");
      Lcd_Out(2,1,"WPM=H WDM=Sp");

      TRISA.RA0 = 1;     //Enable RA0 Pin
      TRISA.RA1 = 0;
      TRISE.RE0 = 0;     //Disable RE0 Pin
      TRISE.RE1 = 0;
      PORTC.RC1 = 1;     //Enable CCP1 Pin(PWM1)
      PORTC.RC2 = 0;     //Disable CCP2 Pin(PWM2)

      PWM1_Init(5000);  //Insitialize PWM1
      PWM1_Start();  //start PWM1
      PWM1_Set_Duty(255); //Set current duty for PWM1

      PWM2_Init(5000);  //Initialize PWM2
      PWM2_Start();  //start PWM2
      PWM2_Set_Duty(0); //Set current duty for PWM2

    }

    Delay_ms(400);
  }
}
