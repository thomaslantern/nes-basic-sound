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
<p>For the sake of this tutorial, we will be skipping some of the more in-depth programming (I'm looking at you, DMC samples), but we'll briefly go over how the addressing for sound works on the NES.</p>
<p>This particular program uses only first sound channel of the NES, of which there are five:
<ol>
  <li>First Pulse Wave</li>
  <li>Second Pulse Wave</li>
  <li>Triangle Pulse Wave</li>
  <li>Noise</li>
  <li>DMC Sound Sample</li>
</ol>
The good news is that if you can understand how to use one channel, using any of the others shouldn't really be that difficult.</p>
<p>So let's take a look at the first channel. To use it, we have to load values into the addresses from $4000 to $4003:
<ul>
  <li>$4000: From left to right we have: Duty cycle (2 bits), envelope length (2 bits), and volume (4 bits). 
    <ul>
      <li>Duty cycle is the "shape" of the sound/sine wave, and volume is fairly straightforward. By writing %11111111 (binary number 11111111) we get our instrument at full volume, with duty cycle 75%.</li>
      <li>I don't honestly remember what the envelope length does exactly (I believe it's a timer of sorts that eventually expires and turns off the sound, so an alternate way of timing your notes rather than using the screen refresh to time them, as I did). I was told to set them to 11, so I did. As you can see, there's a lot to learn with every element of ASM6502, but keep at it! When in doubt, just try some values and see if they work - that kind of thinking has served me well so far with ASM6502, and it hasn't kept me from learning new things either!</li>
    </ul>
    </li>
</ul>
<li>$4001: Sweeping. You can read more about that on NESDEV.org (see below), but I've got this turned off for now, as it's not relevant to this simple tutorial.</li>
<li>$4002, $4003: Use these for the frequency of the note. We use all 8 bits of $4002 for the low part of the note, and the bottom three bits of $4003 for the highest 3 bits (11 bits in total for the note). The formula for figuring out the frequency of the note is: 
  <pre><code>
  P = C / (F * 16) + 1    
  </code></pre></li>
  Where F is the frequency (in Hz), and C is the number of cycles for the NES per second (~1790000 for US/JPN NES, ~1662607 for Europe/others). So for A = 440 Hz, you would do: 
  <pre><code>
    P = 1790000 / (440 * 16) + 1
      = 1790000 / 7040  + 1
      ~= 255 
  </code></pre>
</p>
(more coming soon! but while you wait for info, go here and top up your knowledge: https://www.nesdev.org/wiki/APU_basics)

