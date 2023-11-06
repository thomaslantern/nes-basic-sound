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
  And so we would load #$FF (or 255) into $4002, and load #0 into $4003. For A = 220 Hz, you would do:
  
  <pre><code>
    P = 1790000 / (220 * 16) + 1
      = 1790000 / 3520  + 1
      ~= 509, which is hex $1FD, 
  </code></pre>
  so you would load #$FD into $4002, and load #$01 into $4003. Hopefully that makes sense!
</p>
<h2>Turn the Sound On</h2>
<p>
Of course, we can't actually have music or sound without turning the sound on. For that we need $4015. To do this we can write $01 to $4015 using <code>LDA #$01</code> followed by <code>STA $4015</code>. This turns on the one instrument we are using for this tutorial.
</p>

## Tables for Notes
It's great to have the sound on, but if there are no notes to be played, how will you know the difference? We need some notes, and for that our best friend will be an **LUT** (_look up table_). Look up tables or LUTs allow us to store our notes in a sequential way, that makes it easy as a programmer to read the order of the notes, and how they're going to be played in the song. In short, having LUTs allows us to loop in our code, which makes it much easier to read, modify, and understand. And who doesn't love easier to read code?

Here's a look up table for all the notes you might need for the NES:
<pre><code>
  ; Table of different notes and their values
notes:	
	dw $07F1, $0780, $0713 				; A1 to B1 ($00-$02)
	dw $06AD, $064D, $05F3, $059D, $054D, $0500	; C2 to F2 ($03-$08)
	dw $04B8, $0475, $0435, $03F8, $03BF, $0389 	; F#2 to B2 ($09-$0E)
	dw $0356, $0326, $02F9, $02CE, $02A6, $027F	; C3 to F3 ($0F-$15)
	dw $025C, $023A, $021A, $01FB, $01DF, $01C4 	; F#3 to B3 ($16-$1A)
	dw $01AB, $0193, $017C, $0167, $0151, $013F	; C4 to F4 ($1B-$20)
	dw $012D, $011C, $010C, $00FD, $00EF, $00E2 	; F#4 to B4 ($20-$26)
	dw $00D2, $00C9, $00BD, $00B3, $00A9, $009F	; C5 to F5 ($27-$2C)
	dw $0096, $008E, $0086, $007E, $0077, $0070 	; F#5 to B5 ($2D-$32)
	dw $006A, $0064, $005E, $0059, $0054, $004F	; C6 to F6 ($33-$38)
	dw $004B, $0046, $0042, $003F, $003B, $0038 	; F#6 to B6 ($39-$3E)
	dw $0034, $0031, $002F, $002C, $0029, $0027	; C7 to F7 ($3F-$45)
	dw $0025, $0023, $0021, $001F, $001D, $001B 	; F#7 to B7 ($46-$4A)
	dw $001A, $0018, $0017, $0015, $0014, $0013	; C8 to F8 ($4B-$50)
	dw $0012, $0011, $0010, $000F, $000E, $000D 	; F#8 to B8 ($51-$56)
	dw $000C, $000C, $000B, $000A, $000A, $0009, $0008 ; C9 to F#9 ($57-$5D)
</code></pre>
[_Related sidenote: if you don't understand the naming and numbering of the notes, please see [this music theory page.](https://www.allaboutmusictheory.com/piano-keyboard/music-note-names/)_]
To use this table, we must be a bit careful. Because each of these notes is a word (2 bytes), the way we access them requires us to double the number of the note required to actually access the right data from the table. We also want to put this value into our x register so we can index to the correct note. For example, if we want the second note, we need to store 2 in x:
<pre><code>
	ldx #2 		; Store 2 in x register
	lda notes,x 	; Load the bottom value of the first note
	sta $4002	; Store the bottom half of the note
	lda notes+1,x	; Load the upper value of the first note
	sta $4003	; Store the upper half of the note
</code></pre>

Note that we have to write _notes+1_ to access the higher end of that second note, even though $4003 is where we store the higher half of the note value. I'm not exactly sure why this is (and there's probably a good reason!), but for now just take it on faith (and hopefully at some point this remark will be replaced by a coherent explanation!) 

Of course, writing all of our code this way wouldn't be practical, and we would very quickly run out of space on our NES cartridge simply playing a few notes. If we're going to play a series of notes (a song), we're going to need a loop of some kind. So rather than loading a particular number into our x register, we need to construct another table of values to load into it:
<pre><code>
; Basic idea for song_notes table
song_notes:
	db 1, 3, 4, 5, 6, 2, 2, 1
	db 3, 5, 2, 3, 5, 7, 2, 3
	db 4, 4, 2, 4, 3, 2, 4, 1
	db 4, 4, 2, 4, 4, 4, 1, 1
</code></pre>

This solves the problem of efficiency, but not readability. To make our code even more clear, we should create some labels for our notes. Near the beginning of the program (after our header), we'll want something like the following (please see the [code](basicsound.asm) for this tutorial for the full example):
<pre><code>
; Labels for note names
A1 equ $00
As1 equ $01  ; 's' for "sharp" (i.e. A#)
B1 equ $02
; etc...
</code></pre>

Now, with our labels in place, we can write a look-up table that is a little easier to understand and read:
<pre><code>
; Basic idea for song_notes table
song_notes:
	db C3, C3, G3, G3, A3, A3, G3
	db F3, F3, E3, E3, D3, D3, C3
	; etc...
</code></pre>

Doing this also allows us to write code that is: a) easier to read, and b) more efficient (looping):
<pre><code>
; (This is a code snippet straight from basicsound.asm)
; Load up a new note		
	ldx ntnum
	lda birthday_length,x
	sta sqlen	; Length of new note (this ticks down every clock cycle)

	ldx ctnt	; This loads the current note 

	txa		; We transfer to accumulator so we can easily double it
	asl		; Double value since using words with our notes
	tax		; Put back in x-register

	lda notes,x
	sta $4002
	lda notes+1,x
	sta $4003
	
</code></pre>
In this snippet of code, we are doing a couple of things:
1) (details soon...)

(more soon!)

(more coming soon! but while you wait for info, go here and top up your knowledge: https://www.nesdev.org/wiki/APU_basics)

