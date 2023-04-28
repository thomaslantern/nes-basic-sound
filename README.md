# nes-basic-sound
Basic sound program for the NES (Nintendo Entertainment System) using VASM compiler

<h1>still UNDER CONSTRUCTION</h1>

This is a pretty basic program for making sound on the NES (Nintendo Entertainment System). It is a simple, static screen, which contains both background tiles and "foreground tiles" AKA sprites, and plays some music ("Happy Birthday").

<h1> How to Compile "basicsound.asm" </h1>
If you're looking to compile the code, you'll need to use the VASM compiler. You can get it here: http://www.compilers.de/vasm.html . It's a great compiler that can be used for a variety of systems, and it was made by Dr. Volker Barthelmann. Check it out! To compile simply use: <code>vasm6502_oldstyle.exe DIR/basicsound.asm -chklabels -nocase -Fbin -o "DIR2/basicsound.nes"</code> where DIR and DIR2 are the paths/directories for the source file and target file, respectively. (If you have the win32 version of vasm, you may need to use vasm_oldstyle_win32.exe instead).

<h1>How to Run "basicsound.asm"</h1>
Assuming you've successfully followed the steps to compile above, you should now have an .nes file, "basicsound.nes". This file can be run in any NES (Nintendo Entertainment System) emulator. I tend to use Nestopia, but other NES developers really seem to enjoy FCEUX, so use whichever emulator you like to run it!

<h1>How to Use (and Learn From) "basicsound.asm"</h1>
While it's maybe not the most exciting program (whoever heard of a game that's just a static screen?), there's lots to be learned from this program! In particular, aside from learning how to put graphics on the screen of an NES game, you can modify the tiles yourself and make your own graphics! The "0"s and "1"s you see at the end of the code (in the "chr_rom_start" section near the end) are all the tiles - try changing some of the zeroes and ones around and see what happens!


<h1>insert thing about compiler comparisons</h1>
