******************************
* LCD_Routinen
*
*  Autor Hansjörg Winterhater
*	12.10.2016
*******************************



void comand(cmd)
{
	int a;
	
	while( 3 && asm " IN A,(LCD_CMD)"
	{
		asm"out (LCD_CMD),cmd"
	}
}