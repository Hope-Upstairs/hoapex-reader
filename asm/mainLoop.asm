SECTION "MainLoop", ROM0

MainLoop:

    ;write bank
    ld a, $00
    ld [rRAMB], a
    ;enable sram
    ld a, $0A
    ld [rRAMG], a
    ;write bank
    ld a, $00
    ld [rRAMB], a

            ;timer length and duty cycle
            ;ld hl, rAUD1LEN
            ;ld a, %10111000
            ;ld [hl], a

    ;ld a, [rDIV]
    ;cp a, 255
    ;jp z, :+ + (MainLoopInRam - MainLoop)
    ;ld [rDIV], a

    ;play sound

            ;timer length and duty cycle
            ;ld hl, rAUD1LEN
            ;ld a, %01000111
            ;ld [hl], a

    ;wait for vblank to start

    call UpdateKeysInRam

:
    ld a, [rLY]
    cp 144
    jp nc, :- + (MainLoopInRam - MainLoop)
:
    ld a, [rLY]
    cp 144
    jp c, :- + (MainLoopInRam - MainLoop)

    ;check A pressed
    ld a, [wNewKeys]
    and a, PADF_A
    jp z, :+ + (MainLoopInRam - MainLoop)

    ;do the code for starting the read
    call DrawHexInRam

    jp MainLoopInRam

:

    ;check B pressed
    ld a, [wNewKeys]
    and a, PADF_B
    jp z, :+ + (MainLoopInRam - MainLoop)

    ;swap
    ld a, [vHexAddress]
    swap a
    ld [vHexAddress], a

    jp MainLoopInRam

:
    ;check dir pressed
    ld a, [wNewKeys]
    and a, PADF_DOWN
    jp z, :+ + (MainLoopInRam - MainLoop)

    ;decrease val by $100
    ld a, [vHexAddress]
    dec a
    ld [vHexAddress], a

    jp MainLoopInRam

:
    ;check dir pressed
    ld a, [wNewKeys]
    and a, PADF_UP
    jp z, :+ + (MainLoopInRam - MainLoop)

    ;increase val by $100
    ld a, [vHexAddress]
    inc a
    ld [vHexAddress], a

    jp MainLoopInRam

:
    ;check dir pressed
    ld a, [wNewKeys]
    and a, PADF_LEFT | PADF_RIGHT
    jp z, :+ + (MainLoopInRam - MainLoop)

    ;increase val by $10
    ld a, [vHexAddress+1]
    xor a, $80
    ld [vHexAddress+1], a

    jp MainLoopInRam

:

    ;draw address selection to top-left
    ld a, [vHexAddress]
    ld hl, _SCRN0 + $00
    call DisplayHexInRam
    ld a, [vHexAddress+1]
    ld hl, _SCRN0 + $02
    call DisplayHexInRam

    ld a, [vHexAddress+1]
    and a, $F0
    ld [vHexAddress+1], a

    jp MainLoopInRam

.end:

WaitInVram:

;wait for button press
:

    ;status beep
        ;sound 1
            ;timer length and duty cycle
            ld hl, rAUD1LEN
            ld a, %10000000
            ld [hl], a

        ;only play sound2 if rdiv is 255 to leave space for both sounds
            ld a, [rDIV]
            cp a, 255
            jp z, :+ + (WaitInVramInVram - WaitInVram)
            ld [rDIV], a

        ;sound 2
            ;timer length and duty cycle
            ld hl, rAUD1LEN
            ld a, %11111111
            ld [hl], a

    ;wait for key press
:
    call UpdateKeysInVram
    ld a, [wNewKeys]
    or a
    jp z, :-- + (WaitInVramInVram - WaitInVram)

    ;write bank
    ;ld a, $00
    ;ld [rRAMB], a
    ;enable sram
    ;ld a, $0A
    ;ld [rRAMG], a
    ;write bank
    ;ld a, $00
    ;ld [rRAMB], a

    call CopyInVram

    jp InitScreenInRam

    ;jp MainLoopInRam

.end

CopyFromVramToWram:

    ;copy mainloop, updatekeys and memcopy
    ld de, MainLoopInVram
    ld hl, MainLoopInRam
    ld bc, (MainLoop.end - MainLoop)
    call MemcopyInVRam

    ld de, UpdateKeysInVram
    ld hl, UpdateKeysInRam
    ld bc, (UpdateKeys.end - UpdateKeys)
    call MemcopyInVRam

    ld de, MemcopyForRamInVRam
    ld hl, MemcopyInRam
    ld bc, (MemcopyForRam.end - MemcopyForRam)
    call MemcopyInVRam

    ld de, DisplayHexInVram
    ld hl, DisplayHexInRam
    ld bc, (DisplayHex.end - DisplayHex)
    call MemcopyInVRam

    ld de, InitScreenInVram
    ld hl, InitScreenInRam
    ld bc, (InitScreen.end - InitScreen)
    call MemcopyInVRam

    ld de, DrawHexInVram
    ld hl, DrawHexInRam
    ld bc, (DrawHex.end - DrawHex)
    call MemcopyInVRam

    ret

.end

InitScreen:

    ; Turn the LCD on
    ; https://gbdev.io/pandocs/LCDC.html
        ld a, LCDCF_ON | LCDCF_WIN9C00 | LCDCF_WINOFF | LCDCF_BG8000 | LCDCF_BG9800 | LCDCF_OBJ8 | LCDCF_OBJON | LCDCF_BGON
        ld [rLCDC], a

    ;bg palette
        ld a, %11100100
        ld [rBGP], a

    jp MainLoopInRam

.end

DrawHex:

    ld hl, vHexAddress
    ld a, [hl]
    ld d, a
    ld hl, vHexAddress+1
    ld a, [hl]
    ld e, a
    ld hl, _SCRN0 + $20
    dec de

    REPT 4
        REPT 2
            REPT 2
                REPT 2
                    inc hl
                    REPT 4
                        inc de
                        ld a, [de]
                        call DisplayHexInRam
                    ENDR
                ENDR
                ld a, l
                and a, $F0
                swap a
                inc a
                cp a, $10
                jp nz, :+ + (DrawHexInRam - DrawHex)

                    inc h
                    xor a
                :
                swap a
                ld l, a
            ENDR
        ENDR
        :
        ld a, [rLY]
        cp a, $90
        jp c, :- + (DrawHexInRam - DrawHex)
        :
        ld a, [rLY]
        cp a, $90
        jp nc, :- + (DrawHexInRam - DrawHex)
        :
        ld a, [rLY]
        cp a, $90
        jp c, :- + (DrawHexInRam - DrawHex)
    ENDR

    ;disable sram
    ld a, $00
    ld [rRAMG], a

    ret

.end