#line 1 "C:/Users/Lasinda Kalhara/Desktop/PAM/New folder (2)/WATER_DS.c"

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

void main() {
 int a;
 char txt[7];
 Lcd_Init();
 Lcd_Cmd(_LCD_CLEAR);
 Lcd_Cmd(_LCD_CURSOR_OFF);

 TRISB = 0b00010000;

 Lcd_Out(1,1," Water Distribution");
 Lcd_Out(2,1,"   System");

 Delay_ms(3000);
 Lcd_Cmd(_LCD_CLEAR);

 T1CON = 0x10;

 while(1)
 {

 TMR1H = 0;
 TMR1L = 0;

 PORTB.F0 = 1;
 Delay_us(10);
 PORTB.F0 = 0;

 while(!PORTB.F4);
 T1CON.F0 = 1;
 while(PORTB.F4);
 T1CON.F0 = 0;


 TRISA.RA0 = 0;
 TRISA.RA1 = 0;
 TRISE.RE0 = 0;
 TRISE.RE1 = 0;
 PORTC.RC1 = 0;
 PORTC.RC2 = 0;

 a = (TMR1L | (TMR1H<<8));
 a = a/58.82;
 a = a + 1;


 if(a>=300 && a<=400)
 {
 IntToStr(a,txt);
 Ltrim(txt);
 Lcd_Cmd(_LCD_CLEAR);
 Lcd_Out(1,1,"Water L. = ");
 Lcd_Out(1,12,txt);
 Lcd_Out(1,15,"cm");
 Lcd_Out(2,1,"WPM=Sp WDM=H");

 TRISE.RE0 = 1;
 TRISE.RE1 = 0;
 PORTC.RC2 = 1;

 PWM2_Init(5000);
 PWM2_Start();
 PWM2_Set_Duty(255);

 }
 if(a>=200 && a<=300)
 {
 IntToStr(a,txt);
 Ltrim(txt);
 Lcd_Cmd(_LCD_CLEAR);
 Lcd_Out(1,1,"Water L. = ");
 Lcd_Out(1,12,txt);
 Lcd_Out(1,15,"cm");
 Lcd_Out(2,1,"WPM=L WDM=M");

 TRISA.RA0 = 1;
 TRISA.RA1 = 0;
 TRISE.RE0 = 1;
 TRISE.RE1 = 0;
 PORTC.RC1 = 1;
 PORTC.RC2 = 1;

 PWM1_Init(5000);
 PWM1_Start();
 PWM1_Set_Duty(85);

 PWM2_Init(5000);
 PWM2_Start();
 PWM2_Set_Duty(170);

 }

 if(a>=100 && a<=200)
 {
 IntToStr(a,txt);
 Ltrim(txt);
 Lcd_Cmd(_LCD_CLEAR);
 Lcd_Out(1,1,"Water L. = ");
 Lcd_Out(1,12,txt);
 Lcd_Out(1,15,"cm");
 Lcd_Out(2,1,"WPM=M WDM=L");

 TRISA.RA0 = 1;
 TRISA.RA1 = 0;
 TRISE.RE0 = 1;
 TRISE.RE1 = 0;
 PORTC.RC1 = 1;
 PORTC.RC2 = 1;

 PWM1_Init(5000);
 PWM1_Start();
 PWM1_Set_Duty(170);

 PWM2_Init(5000);
 PWM2_Start();
 PWM2_Set_Duty(85);
 }

 if(a>=0 && a<=100)
 {
 IntToStr(a,txt);
 Ltrim(txt);
 Lcd_Cmd(_LCD_CLEAR);
 Lcd_Out(1,1,"Water L. = ");
 Lcd_Out(1,12,txt);
 Lcd_Out(1,15,"cm");
 Lcd_Out(2,1,"WPM=H WDM=Sp");

 TRISA.RA0 = 1;
 TRISA.RA1 = 0;
 TRISE.RE0 = 0;
 TRISE.RE1 = 0;
 PORTC.RC1 = 1;
 PORTC.RC2 = 0;

 PWM1_Init(5000);
 PWM1_Start();
 PWM1_Set_Duty(255);

 PWM2_Init(5000);
 PWM2_Start();
 PWM2_Set_Duty(0);

 }

 Delay_ms(400);
 }
}
