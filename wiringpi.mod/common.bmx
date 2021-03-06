' Copyright (c) 2014-2016 Bruce A Henderson
' 
' Permission is hereby granted, free of charge, to any person obtaining a copy
' of this software and associated documentation files (the "Software"), to deal
' in the Software without restriction, including without limitation the rights
' to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
' copies of the Software, and to permit persons to whom the Software is
' furnished to do so, subject to the following conditions:
' 
' The above copyright notice and this permission notice shall be included in
' all copies or substantial portions of the Software.
' 
' THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
' IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
' FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
' AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
' LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
' OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
' THE SOFTWARE.
' 
SuperStrict

Import BRL.StandardIO

Import "-lwiringPi"

Extern

	Rem
	bbdoc: Initialises wiringPi And assumes that the program is going To be using the wiringPi pin numbering scheme.
	about: This is a simplified numbering scheme which provides a mapping from virtual pin numbers 0 through 16 to
	the real underlying Broadcom GPIO pin numbers. See the pins page for a table which maps the wiringPi pin
	number to the Broadcom GPIO pin number to the physical location on the edge connector.
	End Rem
	Function wiringPiSetup:Int()
	
	Rem
	bbdoc: Initialises wiringPi and assumes that the program is going to use the Broadcom GPIO pin numbers directly with no re-mapping, but allows the calling programs to use the physical pin numbers on the P1 connector only..
	about: Note that some pins are different from revision 1 to revision 2 boards.
	End Rem
	Function wiringPiSetupGpio:Int()
	
	Rem
	bbdoc: Initialises wiringPi and assumes that the program is going to use the Broadcom GPIO pin numbers directly with no re-mapping.
	about: Note that some pins are different from revision 1 to revision 2 boards.
	End Rem
	Function wiringPiSetupPhys:Int()
	
	Rem
	bbdoc: Initialises wiringPi but uses the /sys/class/gpio interface rather than accessing the hardware directly.
	about: This can be called as a non-root user provided the GPIO pins have been exported before-hand using the gpio program.
	Pin numbering in this mode is the native Broadcom GPIO numbers – the same as wiringPiSetupGpio(), so be aware of the differences
	between Rev 1 and Rev 2 boards.
	<p>
	Note: In this mode you can only use the pins which have been exported via the /sys/class/gpio interface before you run your program.
	You can do this in a separate shell-script, or by using the system() function from inside your program to call the gpio program.
	</p>
	End Rem
	Function wiringPiSetupSys:Int()

	Rem
	bbdoc: Sets the mode of a pin to either PM_INPUT, PM_OUTPUT, PWM_OUTPUT or GPIO_CLOCK.
	about: Note that only wiringPi pin 1 (BCM_GPIO 18) supports PWM output and only wiringPi pin 7 (BCM_GPIO 4) supports CLOCK output modes.
	<p>
	This function has no effect when in Sys mode. If you need to change the pin mode, then you can do it with the
	gpio program in a script before you start your program.
	</p>
	End Rem
	Function pinMode(pin:Int, Mode:Int)
	
	Rem
	bbdoc: Sets the pull-up or pull-down resistor mode on the given pin, which should be set as an input.
	abotu: Unlike the Arduino, the BCM2835 has both pull-up an down internal resistors.
	The parameter pud should be; PUD_OFF, (no pull up/down), PUD_DOWN (pull to ground) or PUD_UP (pull to 3.3v)
	The internal pull up/down resistors have a value of approximately 50Kohm on the Raspberry Pi.
	<p>
	This function has no effect on the Raspberry Pi's GPIO pins when in Sys mode. If you need to activate a pull-up/pull-down,
	then you can do it with the gpio program in a script before you start your program.
	</p>
	End Rem
	Function pullUpDnControl(pin:Int, pud:Int)

	Rem
	bbdoc: Writes the value HIGH or LOW (1 or 0) to the given pin which must have been previously set as an output.
	about: WiringPi treats any non-zero number as HIGH, however 0 is the only representation of LOW.
	End Rem
	Function digitalWrite(pin:Int, value:Int)
	
	Rem
	bbdoc: Writes the value to the PWM register for the given pin.
	about: The Raspberry Pi has one on-board PWM pin, pin 1 (BMC_GPIO 18, Phys 12) and the range is 0-1024. Other PWM devices may have other PWM ranges.
	<p>
	This function is not able to control the Pi's on-board PWM when in Sys mode.
	</p>
	End Rem
	Function pwmWrite(pin:Int, value:Int)
	
	Rem
	bbdoc: Returns the value read at the given pin.
	about: It will be HIGH or LOW (1 or 0) depending on the logic level at the pin.
	End Rem
	Function digitalRead:Int(pin:Int)
	
	Rem
	bbdoc: Returns the value read on the supplied analog input pin.
	about: You will need to register additional analog modules to enable this function for devices such as the Gertboard, quick2Wire analog board, etc.
	End Rem
	Function analogRead:Int(pin:Int)
	
	Rem
	bbdoc: Writes the given value to the supplied analog pin.
	about: You will need to register additional analog modules to enable this function for devices such as the Gertboard.
	End Rem
	Function analogWrite(pin:Int, value:Int)
	
	Rem
	bbdoc: Registers a function to received interrupts on the specified pin.
	about: The edgeType parameter is either INT_EDGE_FALLING, INT_EDGE_RISING, INT_EDGE_BOTH or INT_EDGE_SETUP.
	If it is INT_EDGE_SETUP then no initialisation of the pin will happen – it's assumed that you have already setup the pin
	elsewhere (e.g. with the gpio program), but if you specify one of the other types, then the pin
	will be exported and initialised as specified. This is accomplished via a suitable call to the gpio utility program, so it need to be available.
	<p>
	The pin number is supplied in the current mode – native wiringPi, BCM_GPIO, physical or Sys modes.
	</p>
	<p>
	This function will work in any mode, and does not need root privileges to work.
	</p>
	<p>
	The function will be called when the interrupt triggers. When it is triggered, it's cleared in the dispatcher before calling your
	function, so if a subsequent interrupt fires before you finish your handler, then it won't be missed.
	(However it can only track one more interrupt, if more than one interrupt fires while one is being handled then they will be ignored)
	</p>
	<p>
	This function is run at a high priority (if the program is run using sudo, or as root) and executes concurrently with the main program.
	It has full access to all the global variables, open file handles and so on.
	</p>
	End Rem
	Function wiringPiISR:Int(pin:Int, edgeType:Int, callback())
	
	Rem
	bbdoc: Writes the 8-bit byte supplied to the first 8 GPIO pins.
	about: It's the fastest way to set all 8 bits at once to a particular value, although it still takes two write operations to the Pi's GPIO hardware.
	End Rem
	Function digitalWriteByte(value:Int)
	
	Rem
	bbdoc: Switches modes by supplying the parameter: PWM_MODE_BAL or PWM_MODE_MS.
	about: The PWM generator can run in 2 modes – "balanced" and "mark:space". The mark:space mode is traditional, however the default mode in the Pi is "balanced".
	End Rem
	Function pwmSetMode(Mode:Int)

	Rem
	bbdoc: Sets the range register in the PWM generator.
	about: The default is 1024.
	End Rem
	Function pwmSetRange(Range:Int)

	Rem
	bbdoc: Sets the divisor for the PWM clock.
	about: Note: The PWM control functions can not be used when in Sys mode. To understand more about the PWM system, you'll need
	to read the Broadcom ARM peripherals manual.
	End Rem
	Function pwmSetClock(divisor:Int)
	
	Rem
	bbdoc: Returns the board revision of the Raspberry Pi.
	about: It will be either 1 or 2. Some of the BCM_GPIO pins changed number and function when moving from board revision 1 to 2,
	so if you are using BCM_GPIO pin numbers, then you need to be aware of the differences.
	End Rem
	Function piBoardRev:Int()
	
	Rem
	bbdoc: Returns the BCM_GPIO pin number of the supplied wiringPi pin.
	about: It takes the board revision into account.
	End Rem
	Function wpiPinToGpio:Int(wPiPin:Int)
	
	Rem
	bbdoc: Returns the BCM_GPIO pin number of the supplied physical pin on the P1 connector.
	End Rem
	Function physPinToGpio:Int(physPin:Int)
	
	Rem
	bbdoc: Sets the "strength" of the pad drivers for a particular group of pins.
	about: There are 3 groups of pins and the drive strength is from 0 to 7. Do not use this unless you know what you are doing.
	End Rem
	Function setPadDrive(group:Int, value:Int)
	
End Extern


Const LOW:Int = 0
Const HIGH:Int = 1

' Pull up/down/none
Const PUD_OFF:Int = 0
Const PUD_DOWN:Int = 1
Const PUD_UP:Int = 2

' pin modes
Const PM_INPUT:Int = 0
Const PM_OUTPUT:Int = 1
Const PWM_OUTPUT:Int = 2
Const GPIO_CLOCK:Int = 3
Const SOFT_PWM_OUTPUT:Int = 4
Const SOFT_TONE_OUTPUT:Int = 5
Const PWM_TONE_OUTPUT:Int = 6

' PWM
Const PWM_MODE_MS:Int = 0
Const PWM_MODE_BAL:Int = 1

' interrupt levels
Const INT_EDGE_SETUP:Int = 0
Const INT_EDGE_FALLING:Int = 1
Const INT_EDGE_RISING:Int = 2
Const INT_EDGE_BOTH:Int = 3

