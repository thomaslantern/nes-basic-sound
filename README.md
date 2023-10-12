# nes-basic-sound
Basic sound program for the NES (Nintendo Entertainment System) using VASM compiler

This is a pretty basic program for making sound on the NES (Nintendo Entertainment System). It is a simple, static screen, which contains both background tiles and "foreground tiles" AKA sprites, and plays some music ("Happy Birthday").

<h1> How to Compile "basicsound.asm" </h1>
If you're looking to compile the code, you'll need to use the VASM compiler. You can get it here: http://www.compilers.de/vasm.html . It's a great compiler that can be used for a variety of systems, and it was made by Dr. Volker Barthelmann. Check it out! 

<p>To compile simply use: 
<pre><code>vasm6502_oldstyle.exe DIR/basicsound.asm -chklabels -nocase -Fbin -o "DIR2/basicsound.nes"</code></pre> where DIR and DIR2 are the paths/directories for the source file and target file, respectively. (If you have the win32 version of vasm, you may need to use vasm_oldstyle_win32.exe instead).</p>

<h1>How to Run "basicsound.asm"</h1>
Assuming you've successfully followed the steps to compile above, you should now have an .nes file, "basicsound.nes". This file can be run in any NES (Nintendo Entertainment System) emulator. I tend to use Nestopia, but other NES developers really seem to enjoy FCEUX, so use whichever emulator you like to run it!

<h1>How to Use (and Learn From) "basicsound.asm"</h1>
<p>So this "game" (and I use the term generously) is only a mild step up from our basic graphics tutorial: instead of a static screen, we've got a static screen with sound. I guess that's an improvement, right? Ever wanted to give a friend an NES cartridge that was a birthday card? This tutorial is pretty much exactly that! Of course, to do anything useful with it, we must be able to learn from the code, maybe even make some modifications. Wouldn't that be grand? Well, let me give you the tour...</p?

<p>Before we go further, I would recommend you check out my "Hello World" (https://github.com/thomaslantern/hello-world) and "Basic Graphics" (https://github.com/thomaslantern/nes-basic-graphics) tutorials for the NES, as they cover a lot of the initial steps needed to go over what we're doing here. Once you've done that, you're ready to start learning about NES sound and how we can make some cool noise!</p>

<h2>How Sound works on the NES</h2>
For the sake of this tutorial, we will be skipping some of the more in-depth programming (I'm looking at you, DMC samples), but we'll briefly go over how the addressing for sound works on the NES.
(more coming soon! but while you wait for info, go here and top up your knowledge: https://www.nesdev.org/wiki/APU_basics)

