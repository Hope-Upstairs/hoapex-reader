SECTION "setup", ROM0

EntryPoint:
    ld a, 0
    ld bc, 0
    ld de, 0
    ld hl, 0

    ;clear ram
        ld hl, _RAM
        ld de, $E000
:
        ld a, 0
        ld [hli], a
        ld a, h
        cp a, d
        jp nz, :-
        ld a, l
        cp a, e
        jp nz, :-

.WaitVBlank ; Do not turn the LCD off outside of VBlank
    ld a, [rLY]
    cp 144
    jp c, .WaitVBlank
    
    ; Turn the LCD off
    ld a, 0
    ld [rLCDC], a

.SetupGFX
    ; clear the nintendo logo
        ld hl, _VRAM
        ld bc, $800
        call Memclear

    ; copy the font tiles
        ld de, sprFont
        ld hl, _VRAM
        ld bc, sprFont.end - sprFont
        call Memcopy

    ; clear the object ram
        ld hl, _OAMRAM
        ld bc, $A0
        call Memclear

    ; clear the tilemap
        ld hl, _SCRN0
        ld bc, _SCRN1 - _SCRN0
        call Memclear
        ld hl, _SCRN1
        ld bc, _SCRN1 - _SCRN0
        call Memclear

.prepareObject
        ;ld hl, _OAMRAM
        ;ld a, $30
        ;ld [hli], a
        ;ld a, $30
        ;ld [hli], a
        ;ld a, $10
        ;ld [hli], a
        ;ld a, $00
        ;ld [hli], a

.SetUpVariables

    ; Initialize global variables
        ld a, 0
        ld [wCurKeys], a
        ld [wNewKeys], a
        ld [vHexStatus], a
        ld [vHexAddress], a
        ld [vHexAddress+1], a

    ;set master volume
    ld hl, rAUDVOL
    ;VIN left, left, VIN right, right
    ld a, %01110111
    ld [hl], a

    ;set panning
    ld hl, rAUDTERM
    ;4321 left, 4321 right
    ld a, %11111111
    ld [hl], a

    ;enable sound
    ld hl, rAUDENA
    ld a, %10000000
    ld [hl], a

        ;channel 1 settigns
            ;sweep
            ld hl, rAUD1SWEEP
            ld a, %00000000
            ld [hl], a

            ;timer length and duty cycle
            ld hl, rAUD1LEN
            ld a, %10011000
            ld [hl], a

            ;volume and envelope
            ld hl, rAUD1ENV
            ld a, %01000000
            ld [hl], a

            ;period low
            ld hl, rAUD1LOW
            ld a, %00000000
            ld [hl], a

            ;trigger + period high
            ld hl, rAUD1HIGH
            ld a, %11000111
            ld [hl], a

.finish

.copyStuff

    ld de, MainLoop
    ld hl, MainLoopInVram
    ld bc, (MainLoop.end - MainLoop)
    call Memcopy

    ld de, UpdateKeys
    ld hl, UpdateKeysInVram
    ld bc, (UpdateKeys.end - UpdateKeys)
    call Memcopy

    ld de, WaitInVram
    ld hl, WaitInVramInVram
    ld bc, (WaitInVram.end - WaitInVram)
    call Memcopy

    ld de, CopyFromVramToWram
    ld hl, CopyInVram
    ld bc, (CopyFromVramToWram.end - CopyFromVramToWram)
    call Memcopy

    ld de, DisplayHex
    ld hl, DisplayHexInVram
    ld bc, (DisplayHex.end - DisplayHex)
    call Memcopy

    ld de, MemcopyForVram
    ld hl, MemcopyInVRam
    ld bc, (MemcopyForVram.end - MemcopyForVram)
    call Memcopy

    ld de, MemcopyForRam
    ld hl, MemcopyForRamInVRam
    ld bc, (MemcopyForRam.end - MemcopyForRam)
    call Memcopy

    ld de, InitScreen
    ld hl, InitScreenInVram
    ld bc, (InitScreen.end - InitScreen)
    call Memcopy

    ld de, DrawHex
    ld hl, DrawHexInVram
    ld bc, (DrawHex.end - DrawHex)
    call Memcopy

    jp WaitInVramInVram