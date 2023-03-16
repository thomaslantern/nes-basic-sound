	; Basic Graphics Program
	; by Thomas Wesley Scott, 2023

	; Code starts at $C000.
	; org jump to $BFFO for header info


	org $BFF0
	db "NES",$1a
	db $1
	db $1
	db %00000000
	db %00000000
	db 0
	db 0,0,0,0,0,0,0

; Stores "jump values" for notes as their note name
; for readability, and to make easier tables of notes
; for songs. ('s' for sharp, 'b' for flat)
A1 equ $00
As1 equ $01
Bb1 equ $01
B1 equ $02

C2 equ $03
Cs2 equ $04
Db2 equ $04
D2 equ $05
Ds2 equ $06
Eb2 equ $06
E2 equ $07
F2 equ $08
Fs2 equ $09
Gb2 equ $09
G2 equ $0A
Gs2 equ $0B
Ab2 equ $0B
A2 equ $0C
As2 equ $0D
Bb2 equ $0D
B2 equ $0E

C3 equ $0F
Cs3 equ $10
Db3 equ $10
D3 equ $11
Ds3 equ $12
Eb3 equ $12
E3 equ $13
F3 equ $14
Fs3 equ $15
Gb3 equ $15
G3 equ $16
Gs3 equ $17
Ab3 equ $17
A3 equ $18
As3 equ $19
Bb3 equ $19
B3 equ $1A

C4 equ $1B
Cs4 equ $1C
Db4 equ $1C
D4 equ $1D
Ds4 equ $1E
Eb4 equ $1E
E4 equ $1F
F4 equ $20
Fs4 equ $21
Gb4 equ $21
G4 equ $22
Gs4 equ $23
Ab4 equ $23
A4 equ $24
As4 equ $25
Bb4 equ $25
B4 equ $26

C5 equ $27
Cs5 equ $28
Db5 equ $28
D5 equ $29
Ds5 equ $2A
Eb5 equ $2A
E5 equ $2B
F5 equ $2C
Fs5 equ $2D
Gb5 equ $2D
G5 equ $2E
Gs5 equ $2F
Ab5 equ $2F
A5 equ $30
As5 equ $31
Bb5 equ $31
B5 equ $32

C6 equ $33
Cs6 equ $34
Db6 equ $34
D6 equ $35
Ds6 equ $36
Eb6 equ $36
E6 equ $37
F6 equ $38
Fs6 equ $39
Gb6 equ $39
G6 equ $3A
Gs6 equ $3B
Ab6 equ $3B
A6 equ $3C
As6 equ $3D
Bb6 equ $3D
B6 equ $3E

C7 equ $3F
Cs7 equ $40
Db7 equ $40
D7 equ $41
Ds7 equ $42
Eb7 equ $42
E7 equ $43
F7 equ $44
Fs7 equ $45
Gb7 equ $45
G7 equ $46
Gs7 equ $47
Ab7 equ $47
A7 equ $48
As7 equ $49
Bb7 equ $49
B7 equ $4A

C8 equ $4B
Cs8 equ $4C
Db8 equ $4C
D8 equ $4D
Ds8 equ $4E
Eb8 equ $4E
E8 equ $4F
F8 equ $50
Fs8 equ $51
Gb8 equ $51
G8 equ $52
Gs8 equ $53
Ab8 equ $53
A8 equ $54
As8 equ $55
Bb8 equ $55
B8 equ $56

C9 equ $57
Cs9 equ $58
Db9 equ $58
D9 equ $59
Ds9 equ $5A
Eb9 equ $5A
E9 equ $5B
F9 equ $5C
Fs9 equ $5D

sqlen equ $7A	; counter for square note duration
ctnt equ $7C  	; current note
ntnum equ $7D	; number of current note

nmihandler:
	pha
	php

	lda #$02
	sta $4014
	
	ldx ctnt
	cpx #0
	beq skipnote
	
playnote:
	jsr soundframe

skipnote:
	plp
	pla
	rti
	

irqhandler:
	rti

startgame:
	sei				; Disable interrupts
	cld				; Clear decimal mode

	ldx #$ff	
	txs				; Set-up stack
	inx				; x is now 0
	stx $2000		; Disable/reset graphic options 
	stx $2001		; Make sure screen is off
	stx $4015		; Disable sound

	stx $4010		; Disable DMC (sound samples)
	lda #$40
	sta $4017		; Disable sound IRQ
	lda #0	
waitvblank:
	bit $2002		; check PPU Status to see if
	bpl waitvblank	; vblank has occurred.
	lda #0
clearmemory:		; Clear all memory info
	sta $0000,x
	sta $0100,x
	sta $0300,x
	sta $0400,x
	sta $0500,x
	sta $0600,x
	sta $0700,x
	lda #$FF
	sta $0200,x		; Load $FF into $0200 to 
	lda #$00		; hide sprites 
	inx				; x goes to 1, 2... 255
	cpx #$00		; loop ends after 256 times,
	bne clearmemory ; clearing all memory

waitvblank2:
	bit $2002		; Check PPU Status one more time
	bpl waitvblank2	; before we start loading in graphics	
	lda $2002
	ldx #$3F
	stx $2006
	ldx #$00
	stx $2006
copypalloop:
	lda initial_palette,x
	sta $2007
	inx
	cpx #$20
	bcc copypalloop

	
	ldx #$02 	
	stx $4014

	ldx #0
spriteload:
	lda sprites,x	; Load tiles, x and y attributes
	sta $0200,x
	inx
	cpx #$20
	bne spriteload


; Setup background


	ldy #$FF
	lda $2002
	lda #$20
	sta $2006
	sta $09			; Zero page - storing high byte here
	lda #$09
	sta $2006
	sta $08			; Zero page - storing low byte here

bkgdouter:


	
	
	ldx #0
bkgd:
	; 14 tiles, place them 20 times

	lda backgrounddata_walls,x
	sta $2007
	inx
	cpx #$0E
	bne bkgd

	lda $2002
	iny
	clc
	lda $08
	adc #32
	sta $08	
	lda $09
	adc #0		; If carry is set, should add to $09
	sta $09	

	sta $2006
	lda $08
	sta $2006

	cpy #$14
	bne bkgdouter

; Load the floor of the house.

	ldx #0
	lda $2002
	lda #$22	; High byte is $2289
	sta $2006
	lda #$89	; Low byte of $2289
	sta $2006
bkgd_floor:
	lda #$01	; Tile $01 is a brick
	sta $2007
	inx
	cpx #$0D	; We want 13 bricks total
	bne bkgd_floor


bkgd_words:		; "Happy Birthday Tommy!" tiles
	lda #$20
	sta $09
	lda #$2C
	sta $08

	lda $2002
	lda $09
	sta $2006
	lda $08
	sta $2006

	ldx #0
happy:				
	lda backgrounddata_words,x
	sta $2007
	inx
	cpx #$05
	bne happy

	clc
	lda $08
	adc #32
	sta $08
	lda $2002
	lda $09
	sta $2006
	lda $08
	sta $2006

birthday:
	; Continue working through list
	; of birthday tiles

	
	lda backgrounddata_words,x
	sta $2007
	inx
	cpx #$0D
	bne birthday

	clc
	lda $08
	adc #32
	sta $08
	lda $2002
	lda $09
	sta $2006
	lda $08
	sta $2006

tommy:
	; Continue working through list
	; of birthday tiles
	
	lda backgrounddata_words,x
	sta $2007
	inx
	cpx #$15
	bne tommy


	; Reset scroll position to prevent
	; background from scrolling
	lda $2002
	lda #$00
	sta $2005
	sta $2005


musicsetup:
	; Initialization
	lda #$01
	sta $4015	; Turn on instruments
	lda #%11111111
	sta $4000	; Configure square 1
	lda #$00
	sta $4001	; Turn off sweeping on square 1

	
	; Load initial values
	; Then turn the screen on so music can play
	lda birthday_notes
	sta ctnt
	asl	; Double it since we're dealing with words	
	tax	; Put the value in x-register

	lda notes,x 	; Lower half of note
	sta $4002
	lda notes+1,x 	; Higher half of note
	sta $4003

	; Length of first note
	lda birthday_length	
	sta sqlen
	
	lda #0
	sta ntnum		; Number of note starts at zero

	; Turn the screen on
	lda #%00011110
	sta $2001
	lda #$88
	sta $2000


forever:
	jmp forever


soundframe:

	; This subroutine is only loaded via vblank
	; and only if there are still notes to play

	; Check first if a new note is needed
	; If not, we simply decrease counter
	; and move on

	lda sqlen
	bne decreasecount
	
	; sqlen is zero, so we
	; need a new note
	; Increase note counter
	ldx ntnum	
	inx
	stx ntnum
	

	lda birthday_notes,x
	sta ctnt
	
	; Make sure newest note is a note
	cmp #0
	bne newnote
	
silence:

	; Note is "zero", so stop music
	lda #0
	sta $4015
	rts

newnote:
	

	; Load up a new note		
	ldx ntnum
	lda birthday_length,x
	sta sqlen	; Length of new note

	ldx ctnt

	txa
	asl	; Double value since using words
	tax	; Put back in x-register

	lda notes,x
	sta $4002
	lda notes+1,x
	sta $4003

decreasecount:
	ldx sqlen
	dex
	stx sqlen

	rts 	; exit subroutine



initial_palette:
	; Background palettes
	db $2A,$27,$0F,$1A  
	db $2A,$23,$33,$1A
	db $2A,$22,$33,$1A
	db $2A,$27,$31,$1A

	; Sprite palettes
	db $0F,$0F,$27,$16  ; bomb palette
	db $0F,$27,$16,$11  ; cake palette
	db $0F,$07,$27,$25  ; girl palette
	db $0F,$2d,$16,$2d  ; extra palette


sprites:

	db $98, $01, $02, $78 ; Girl #1
	db $98, $02, $42, $85 ; Girl #2
	

	db $98, $04, $01, $80 ; Cake


	db $30, $0B, $00, $55 ; Explosions!
	db $28, $0B, $00, $5d
	db $28, $0B, $00, $9d
	db $30, $0B, $00, $a5

	db $48, $11, $00, $7d ; Bomb - uh oh!

; Background data
	
backgrounddata_walls:
	
	db $01,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$01

backgrounddata_words:
	db $09,$02,$11,$11,$1A			; HAPPY
	db $03,$0A,$13,$15,$09,$05,$02,$1A	; BIRTHDAY
	db $15,$10,$0E,$0E,$1A,$1C,$1C,$1C	; TOMMY!!!

; Table of different notes and their values
notes:	
	dw $07F1, $0780, $0713 						; A1 to B1 ($00-$02)
	dw $06AD, $064D, $05F3, $059D, $054D, $0500	; C2 to F2 ($03-$08)
	dw $04B8, $0475, $0435, $03F8, $03BF, $0389 ; F#2 to B2 ($09-$0E)
	dw $0356, $0326, $02F9, $02CE, $02A6, $027F	; C3 to F3 ($0F-$15)
	dw $025C, $023A, $021A, $01FB, $01DF, $01C4 ; F#3 to B3 ($16-$1A)
	dw $01AB, $0193, $017C, $0167, $0151, $013F	; C4 to F4 ($1B-$20)
	dw $012D, $011C, $010C, $00FD, $00EF, $00E2 ; F#4 to B4 ($20-$26)
	dw $00D2, $00C9, $00BD, $00B3, $00A9, $009F	; C5 to F5 ($27-$2C)
	dw $0096, $008E, $0086, $007E, $0077, $0070 ; F#5 to B5 ($2D-$32)
	dw $006A, $0064, $005E, $0059, $0054, $004F	; C6 to F6 ($33-$38)
	dw $004B, $0046, $0042, $003F, $003B, $0038 ; F#6 to B6 ($39-$3E)
	dw $0034, $0031, $002F, $002C, $0029, $0027	; C7 to F7 ($3F-$45)
	dw $0025, $0023, $0021, $001F, $001D, $001B ; F#7 to B7 ($46-$4A)
	dw $001A, $0018, $0017, $0015, $0014, $0013	; C8 to F8 ($4B-$50)
	dw $0012, $0011, $0010, $000F, $000E, $000D ; F#8 to B8 ($51-$56)
	dw $000C, $000C, $000B, $000A, $000A, $0009, $0008 ; C9 to F#9 ($57-$5D)

; Notes to the song ("Happy Birthday")
birthday_notes:
	db G3, G3, A3, G3, C4, B3
	db G3, G3, A3, G3, D4, C4
	db G3, G3, G4, E4, C4, B3, A3
	db F4, F4, E4, C4, D4, C4
	db 0 ; Zero indicates song is over

birthday_length:
	
	; 240 BPM -> 4 times a second -> 15 counts per quarter note
	db 30, 15, 45, 45, 45, 90
	db 30, 15, 45, 45, 45, 90
	db 30, 15, 45, 45, 45, 45, 90
	db 30, 15, 45, 45, 45, 105

	org $FFFA
	dw nmihandler
	dw startgame
	dw irqhandler

chr_rom_start:

background_tile_start:

	db %00000000	; Blank tile
	db %00000000
	db %00000000
	db %00000000
	db %00000000
	db %00000000
	db %00000000
	db %00000000
	db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF	; bitplane 2

	db %11101110	; Brick tile
	db %11101110
	db %10111011
	db %10111011
	db %11101110
	db %11101110
	db %10111011
	db %10111011

	db %00010001	; bitplane 2
	db %00010001
	db %01000100
	db %01000100
	db %00010001
	db %00010001
	db %01000100
	db %01000100

	db %00000000	
	db %00011000	; "A"
	db %00100100
	db %01000010
	db %01000010
	db %01111110
	db %01000010
	db %01000010
	db $00, $00, $00, $00, $00, $00, $00, $00	; bitplane 2

	db %00000000
	db %11111000	; "B"
	db %10000100
	db %10000100
	db %11111000
	db %10001000
	db %10000100
	db %11111100
	db $00, $00, $00, $00, $00, $00, $00, $00

	db %00000000
	db %00111100	; "C"
	db %01000010
	db %10000000
	db %10000000
	db %10000000
	db %10000010
	db %01111100

	db $00, $00, $00, $00, $00, $00, $00, $00

	db %00000000
	db %11100000	; "D"
	db %10010000
	db %10001100
	db %10000110
	db %10000110
	db %10011000
	db %11100000

	db $00, $00, $00, $00, $00, $00, $00, $00

	db %00000000	; "E"
	db %11111110
	db %10000000
	db %10000000
	db %11111100
	db %10000000
	db %10000000
	db %11111110
	db $00, $00, $00, $00, $00, $00, $00, $00

	db %00000000	; "F"
	db %11111110
	db %10000000
	db %10000000
	db %11111100
	db %10000000
	db %10000000
	db %10000000
	db $00, $00, $00, $00, $00, $00, $00, $00

	db %00000000
	db %00111000	; "G"
	db %01000100
	db %10000000
	db %10000000
	db %10011100
	db %10000110
	db %01111100

	db $00, $00, $00, $00, $00, $00, $00, $00

	db %00000000	; "H"
	db %10000010
	db %10000010
	db %10000010
	db %11111110
	db %10000010
	db %10000010
	db %10000010
	db $00, $00, $00, $00, $00, $00, $00, $00

	db %00000000
	db %11111110	; "I"
	db %00010000
	db %00010000
	db %00010000
	db %00010000
	db %00010000
	db %11111110
	db $00, $00, $00, $00, $00, $00, $00, $00


	db %00000000
	db %11111110	; "J"
	db %00010000
	db %00010000
	db %00010000
	db %00010000
	db %10010000
	db %01110000
	db $00, $00, $00, $00, $00, $00, $00, $00

	db %00000000
	db %10000010	; "K"
	db %10000100
	db %10011000
	db %11100000
	db %10100000
	db %10011000
	db %10000100

	db $00, $00, $00, $00, $00, $00, $00, $00

	db %00000000	; "L"
	db %10000000
	db %10000000
	db %10000000
	db %10000000
	db %10000000
	db %10000000
	db %11111110
	db $00, $00, $00, $00, $00, $00, $00, $00

	db %00000000
	db %10000010	; "M"
	db %11000110
	db %10101010
	db %10010010
	db %10000010
	db %10000010
	db %10000010
	db $00, $00, $00, $00, $00, $00, $00, $00

	db %00000000
	db %10000010	; "N"
	db %11000010
	db %10100010
	db %10010010
	db %10001010
	db %10000110
	db %10000010

	db $00, $00, $00, $00, $00, $00, $00, $00

	db %00000000
	db %01111100	; "O"
	db %10000010
	db %10000010
	db %10000010
	db %10000010
	db %10000010
	db %01111100
	db $00, $00, $00, $00, $00, $00, $00, $00

	db %00000000
	db %01111100	; "P"
	db %10000010
	db %10000010
	db %11111100
	db %10000000
	db %10000000
	db %10000000
	db $00, $00, $00, $00, $00, $00, $00, $00

	db %00000000
	db %01111000	; "Q"
	db %10000100
	db %10000010
	db %10000010
	db %10001010
	db %10000100
	db %01111010
	db $00, $00, $00, $00, $00, $00, $00, $00

	db %00000000
	db %00111000	; "R"
	db %11000100
	db %10000100
	db %11111100
	db %10001000
	db %10000100
	db %10000110
	db $00, $00, $00, $00, $00, $00, $00, $00

	db %00000000
	db %01111100	; "S"
	db %11000010
	db %10000000
	db %01110000
	db %00001100
	db %10000110
	db %11111100
	db $00, $00, $00, $00, $00, $00, $00, $00

	db %00000000
	db %11111110	; "T"
	db %00010000
	db %00010000
	db %00010000
	db %00010000
	db %00010000
	db %00010000
	db $00, $00, $00, $00, $00, $00, $00, $00

	db %00000000
	db %10000010	; "U"
	db %10000010
	db %10000010
	db %10000010
	db %10000010
	db %10000010
	db %11111110
	db $00, $00, $00, $00, $00, $00, $00, $00

	db %00000000
	db %10000010	; "V"
	db %10000010
	db %10000010
	db %10000010
	db %01000100
	db %00101000
	db %00010000
	db $00, $00, $00, $00, $00, $00, $00, $00

	db %00000000
	db %10000010	; "W"
	db %10000010
	db %10000010
	db %10000010
	db %10010010
	db %10101010
	db %01000100
	db $00, $00, $00, $00, $00, $00, $00, $00

	db %00000000	; "X"
	db %10000010	
	db %01000100
	db %00101000
	db %00010000
	db %00101000
	db %01000100
	db %10000010
	db $00, $00, $00, $00, $00, $00, $00, $00

	db %00000000	; "Y"
	db %10000010	
	db %01000100
	db %00101000
	db %00010000
	db %00010000
	db %00010000
	db %00010000
	db $00, $00, $00, $00, $00, $00, $00, $00

	db %00000000
	db %11111110	; "Z"
	db %00001100	
	db %00011000
	db %00110000
	db %01100000
	db %11000000
	db %11111110
	db $00, $00, $00, $00, $00, $00, $00, $00

	db %00000000
	db %00010000	; "!"
	db %00010000
	db %00010000
	db %00010000
	db %00000000
	db %00010000
	db %00010000
	db $00, $00, $00, $00, $00, $00, $00, $00

	db %00000000
	db %00010000	; "1"
	db %00010000
	db %00010000
	db %00010000
	db %00010000
	db %00010000
	db %00010000
	db $00, $00, $00, $00, $00, $00, $00, $00

	db %00000000
	db %01111100	; "2"
	db %10000010
	db %00000100
	db %00001000
	db %00110000
	db %01000000
	db %11111110
	db $00, $00, $00, $00, $00, $00, $00, $00

	db %00000000
	db %01111100	; "3"
	db %10000010
	db %00000100
	db %00011000
	db %00000100
	db %10000010
	db %01111100
	db $00, $00, $00, $00, $00, $00, $00, $00

	db %00000000
	db %00001110	; "4"
	db %00010010
	db %00100010
	db %01111110
	db %00000010
	db %00000010
	db %00000010
	db $00, $00, $00, $00, $00, $00, $00, $00

	db %00000000
	db %11111110	; "5"
	db %10000000
	db %10000000
	db %11111000
	db %00000100
	db %10000010
	db %01111100
	db $00, $00, $00, $00, $00, $00, $00, $00

	db %00000000
	db %00010000	; "6"
	db %00100000
	db %01000000
	db %01111000
	db %10000100
	db %10000100
	db %01111100
	db $00, $00, $00, $00, $00, $00, $00, $00

	db %00000000
	db %11111110	; "7"
	db %00000100
	db %00001000
	db %00010000
	db %00100000
	db %01000000
	db %10000000
	db $00, $00, $00, $00, $00, $00, $00, $00

	db %00000000
	db %00011000	; "8"
	db %00100100
	db %01000010
	db %00111000
	db %01000100
	db %10000010
	db %01111110
	db $00, $00, $00, $00, $00, $00, $00, $00

	db %00000000
	db %00011000	; "9"
	db %00100100
	db %01000010
	db %00111110
	db %00000010
	db %00000010
	db %00000010
	db $00, $00, $00, $00, $00, $00, $00, $00

background_tile_end:
	ds 4096-(background_tile_end-background_tile_start)


sprite_tile_start:
	
	; (Numbers in brackets indicate tile #)

	db %00000000	; "Cake" (0)
	db %00011100
	db %00111110
	db %00111110
	db %00000000
	db %00000000
	db %00000000
	db %00000000

	db %00000000	; "bitplane2"
	db %00000000
	db %00111110
	db %00111110
	db %01111110
	db %01111110
	db %01111110
	db %01111110

	db %00000000	; "Person walk" (1)
	db %00011100
	db %00010000
	db %00010000
	db %00011100
	db %00001100
	db %00001100
	db %00010010

	db %00000000	; "Person walk bp2" 
	db %00000000
	db %00001100
	db %00001100
	db %00001100
	db %00001100
	db %00001100
	db %00000000

	db %00000000	; "Person standing" (2)
	db %00011100
	db %00010000
	db %00010000
	db %00011100
	db %00001100
	db %00001100
	db %00001100

	db %00000000	; "Person standing bp2"
	db %00000000
	db %00001100
	db %00001100
	db %00001100
	db %00001100
	db %00001100
	db %00000000

	db %00000000	; "bomb" (3)
	db %00001000
	db %00111110
	db %01111111
	db %01111111
	db %01111111
	db %00111110
	db %00011100

	db %00011000	; "bomb bp2"
	db %00000000
	db %00000000
	db %00000000
	db %00000000
	db %00000000
	db %00000000
	db %00000000

			
	db %00000000	; "Cake 2" (4)
	db %00000000
	db %00000000
	db %00000000	
	db %00010000
	db %00000000
	db %01111100
	db %01111100

	db %00000000	; "Cake 2 bitplane2"
	db %00000000
	db %00000000
	db %00000000
	db %00000000
	db %00111000
	db %01111100
	db %01111100

	db %00000000	; "Person 2 walk" (5)
	db %00111000
	db %00101000
	db %00000000
	db %00111000
	db %00111000
	db %00111000
	db %00000000

	db %00000000	; "Person 2 walk bp2"
	db %00010000
	db %00010000
	db %00111000
	db %00000100
	db %00000000
	db %00000000
	db %00101000

	db %00000000	; "bomb 2" (6)
	db %00001000
	db %00111100
	db %01111110	
	db %01111110	
	db %01111110	
	db %00111100	
	db %00000000


	db %00001000	; "bomb 2 bp2"
	db %00000000
	db %00000000
	db %00000000
	db %00000000
	db %00000000
	db %00000000
	db %00000000	

		
	db %00000000	; "Cake 3" (7)
	db %00000000
	db %00000000
	db %00000000	
	db %00011000
	db %00000000
	db %00111100
	db %01111110

	db %00000000	; "Cake 3 bitplane2"
	db %00000000
	db %00000000
	db %00011000
	db %00000000
	db %00111100
	db %00000000
	db %00000000

	db %00111000	; "Person 3 walk" (8)
	db %00101000
	db %00000000
	db %00110000
	db %00110000
	db %00110000
	db %01001000
	db %00000000

	db %00000000	; "Person 3 walk bp2"
	db %00011000
	db %00111000
	db %00000000
	db %00001000
	db %00000000
	db %00000000
	db %00000000

	db %00111000	; "Person 3 stand" (9)
	db %00101000
	db %00000000
	db %00110000
	db %00110000
	db %00110000
	db %00110000
	db %00000000

	db %00000000	; "Person 3 stand bp2"
	db %00011000
	db %00111000
	db %00000000
	db %00001000
	db %00000000
	db %00000000
	db %00000000

	db %00000000	; "bomb 3" (A)
	db %00010000
	db %00111000
	db %01111100	
	db %01111100	
	db %01111100	
	db %00111000	
	db %00000000

	db %00110000	; "bomb 3 bp2"
	db %00010000
	db %00000000
	db %00000000
	db %00000000
	db %00000000
	db %00000000
	db %00000000	

	db %00000000	; "bomb explosion!" (B)
	db %00000000
	db %00000000
	db %00000000	
	db %00000000	
	db %00000000	
	db %00000000	
	db %00000000


	db %00000100	; "explosion bp2"
	db %01101010
	db %10111101
	db %01111111
	db %11111110
	db %10111111
	db %01111100
	db %00100110	

	db %00000000	; "Person 4" (C)
	db %00000000
	db %00000000
	db %00011000	
	db %00011000	
	db %00011000	
	db %00111100	
	db %00000000


	db %00000000	; "Person 4 bp2"
	db %00011000
	db %00011000
	db %01111110
	db %00011000
	db %00000000
	db %00000000
	db %00000000	


	db %00000000	; "Person 5" (D)
	db %00000000
	db %00000000
	db %00000000	
	db %00000000	
	db %01010101	
	db %00111111	
	db %01111111


	db %00000000	; "bp2"
	db %00000000
	db %00000000
	db %00000000
	db %00000000
	db %00000010
	db %00000000
	db %00000000	


	db %00000000	; "Cake 4" (E)
	db %00000000
	db %00000000
	db %00111000	
	db %00000000	
	db %00111000	
	db %00000000	
	db %01111100


	db %00000000	; "cake 4 bp2"
	db %00000000
	db %00000000
	db %00111000
	db %00111000
	db %00111000
	db %00111000
	db %00000000	

	db %00000000	; "Cake 5" (E)
	db %00000000
	db %00000000
	db %00111100	
	db %00111100	
	db %00111100	
	db %00111100	
	db %01111110


	db %00000000	; "Cake 5 bp2"
	db %00000000
	db %00000000
	db %00000000
	db %00111100
	db %00000000
	db %00111100
	db %00000000	

	db %00000000	; "Cake 6" (F)
	db %00000000
	db %00000000
	db %00011000	
	db %00011000	
	db %00111100	
	db %00111100	
	db %01111110


	db %00000000	; "Cake 6 bp2"
	db %00000000
	db %00000000
	db %00000000
	db %00011000
	db %00000000
	db %00111100
	db %00000000	

	db %00001100
	db %00001000	; "Bomb 4" (10)
	db %00011000
	db %00111100
	db %01111110
	db %01111110
	db %00111100
	db %00011000


	db %00001100	; "bp2"
	db %00001000
	db %00000000
	db %00000000
	db %00000000
	db %00000000
	db %00000000
	db %00000000		
	
	db %00011000
	db %00100100	; "Girl" (11)
	db %00100100
	db %00111100
	db %00111100
	db %00111100
	db %01111110
	db %00000000


	db %00000000	; "bp2"
	db %00011000
	db %00011000
	db %00111100
	db %00011000
	db %00111100
	db %01111110
	db %00100100

	db %00110000
	db %01100000	; "Sideview girl" (12)
	db %01100000
	db %01110000
	db %01110000
	db %01111000
	db %11111100
	db %00000000


	db %00000000	; "bp2"
	db %00010000
	db %00010000
	db %00111000
	db %00110000
	db %01111000
	db %11111100
	db %01001000

	db %00011000
	db %00010000	; "Boy" (13)
	db %00010000
	db %00011100
	db %00011000
	db %00011000
	db %01111000
	db %01001100


	db %00000000	; "bp2"
	db %00001000
	db %00001000
	db %00011110
	db %00111000
	db %00011000
	db %01111000
	db %01001100

	db %00011000
	db %00000000	; "Boy standing" (14)
	db %00000000
	db %00111100
	db %00011000
	db %00011000
	db %00011000
	db %00111100


	db %00000000	; "bp2"
	db %00011000
	db %00011000
	db %00111100
	db %00111100
	db %00111100
	db %00011000
	db %00111100


	db %01110000
	db %01010000	; "Boy 2 walking" (15)
	db %01000000
	db %00000000
	db %00110000
	db %00110000
	db %00110000
	db %01001000


	db %00000000	; "bp2"
	db %00110000
	db %00111000
	db %00110000
	db %00110000
	db %00111000
	db %00110000
	db %00000000

	db %01110000
	db %01010000	; "Boy 2 standing" (16)
	db %01000000
	db %00000000
	db %00110000
	db %00110000
	db %00110000
	db %00110000


	db %00000000	; "bp2"
	db %00110000
	db %00111000
	db %00110000
	db %00110000
	db %00111000
	db %00110000
	db %00000000

	db %00000000
	db %00000000	; "tiny man" (17)
	db %00000000
	db %00010000
	db %00011000
	db %00010000
	db %00010000
	db %00010000


	db %00000000	; "bp2"
	db %00000000
	db %00010000
	db %00010000
	db %00011100
	db %00010000
	db %00000000
	db %00000000

	db %00000000
	db %00000000	; "tiny man walking" (18)
	db %00000000
	db %00010000
	db %00011000
	db %00010000
	db %00010000
	db %00101000


	db %00000000	; "bp2"
	db %00000000
	db %00010000
	db %00010000
	db %00011100
	db %00010000
	db %00000000
	db %00000000


sprite_tile_end

	
chr_rom_end:

; Pad chr-rom to 8k(to make valid file)
	ds 8192-(chr_rom_end-chr_rom_start)