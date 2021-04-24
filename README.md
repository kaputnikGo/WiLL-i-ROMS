# WiLL-i-ROMS
Functioning assembly code for Heathkit ET-3400 with a 6800 mpu, 2x 6821 pia to a 1408 dac

TODO: add the souce info and labels,plus full fdb listings

Change file names to reflect source ROMs. Original Synths are from ROM 15.

Using the Heathkit ET-3400 MPU board and Williams Electronics sound rom code from systems 3-7 pinball and arcade games.

user RAM is 197 + 256 = 453 bytes

at address ranges 0000 - 00C4 and 0100 - 01FF

stack pointer (SP) start 01FF

PIA1 address set to 8000

PIA2 address set to 4000

PIA1 port A output

PIA1 port B input

PIA2 port B input
