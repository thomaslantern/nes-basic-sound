# nes-basic-sound
Basic sound program for the NES (Nintendo Entertainment System) using VASM compiler

This is a pretty basic program for making sound on the NES (Nintendo Entertainment System). It is a simple, static screen, which contains both background tiles and "foreground tiles" AKA sprites, and plays some music ("Happy Birthday").

<h1> How to Compile "basicsound.asm" </h1>
If you're looking to compile the code, you'll need to use the VASM compiler. You can get it here: http://www.compilers.de/vasm.html . It's a great compiler that can be used for a variety of systems, and it was made by Dr. Volker Barthelmann. Check it out! To compile simply use: <code>vasm6502_oldstyle.exe DIR/basicsound.asm -chklabels -nocase -Fbin -o "DIR2/basicsound.nes"</code> where DIR and DIR2 are the paths/directories for the source file and target file, respectively. (If you have the win32 version of vasm, you may need to use vasm_oldstyle_win32.exe instead).

<h1>How to Run "basicsound.asm"</h1>
Assuming you've successfully followed the steps to compile above, you should now have an .nes file, "basicsound.nes". This file can be run in any NES (Nintendo Entertainment System) emulator. I tend to use Nestopia, but other NES developers really seem to enjoy FCEUX, so use whichever emulator you like to run it!

<h1>How to Use (and Learn From) "basicsound.asm"</h1>
So this "game" (and I use the term generously) is only a mild step up from our basic graphics tutorial. Now instead of a static screen, we've got a static screen with sound. While I guess that's an improvement, right? Ever wanted to give a friend an NES cartridge that was a birthday card? This tutorial is pretty much exactly that!

<h2>How Sound works on the NES</h2>
(coming soon!)

