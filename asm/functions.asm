SECTION "Functions", ROM0

UpdateKeys:
    ; Poll half the controller
    ld a, P1F_GET_BTN
    
    ;one nibble
        ldh [rP1], a ; switch the key matrix
        REPT 10
            nop
        ENDR
        REPT 3 ; ignore value while waiting for the key matrix to settle
            ldh a, [rP1]
        ENDR
        or a, $F0 ; A7-4 = 1; A3-0 = unpressed keys

    ld b, a ; B7-4 = 1; B3-0 = unpressed buttons
    
    ; Poll the other half
    ld a, P1F_GET_DPAD
    
    ;one nibble
        ldh [rP1], a ; switch the key matrix
        REPT 10
            nop
        ENDR
        REPT 3 ; ignore value while waiting for the key matrix to settle
            ldh a, [rP1]
        ENDR
        or a, $F0 ; A7-4 = 1; A3-0 = unpressed keys
        
    swap a ; A3-0 = unpressed directions; A7-4 = 1
    xor a, b ; A = pressed buttons + directions
    ld b, a ; B = pressed buttons + directions
    
    ; And release the controller
    ld a, P1F_GET_NONE
    ldh [rP1], a
    
    ; Combine with previous wCurKeys to make wNewKeys
    ld a, [wCurKeys]
    xor a, b ; A = keys that changed state
    and a, b ; A = keys that changed to pressed
    ld [wNewKeys], a
    ld a, b
    ld [wCurKeys], a
    ret

.end



; Sets some memory to 0.
; @param hl: Starting pos
; @param bc: Length
Memclear:
    ld a, 0  ;load val from source
    ld [hli], a ;put value into dest, increase dest
    dec bc      ;decrease length
    ld a, b     ;
    or a, c     ;check if B or C aren't 0 (length is BC, if it's 0 it sets the 0 flag)
    jp nz, Memclear  ;if not zero (data isn't finished copying), go back
    ret

; Copy bytes from one area to another.
; @param de: Source
; @param hl: Destination
; @param bc: Length
Memcopy:
    ld a, [de]  ;load val from source
    ld [hli], a ;put value into dest, increase dest
    inc de      ;increase source
    dec bc      ;decrease length
    ld a, b     ;
    or a, c     ;check if B or C aren't 0 (length is BC, if it's 0 it sets the 0 flag)
    jp nz, Memcopy  ;if not zero (data isn't finished copying), go back
    ret
.end

MemcopyForVram:
    ld a, [de]  ;load val from source
    ld [hli], a ;put value into dest, increase dest
    inc de      ;increase source
    dec bc      ;decrease length
    ld a, b     ;
    or a, c     ;check if B or C aren't 0 (length is BC, if it's 0 it sets the 0 flag)
    jp nz, MemcopyInVRam  ;if not zero (data isn't finished copying), go back
    ret
.end

MemcopyForRam:
    ld a, [de]  ;load val from source
    ld [hli], a ;put value into dest, increase dest
    inc de      ;increase source
    dec bc      ;decrease length
    ld a, b     ;
    or a, c     ;check if B or C aren't 0 (length is BC, if it's 0 it sets the 0 flag)
    jp nz, MemcopyInRam  ;if not zero (data isn't finished copying), go back
    ret
.end
    
; Write a number in hex at the specified tile coord
; @param A: number to write
; @param HL: tile index to write at
; @ also uses registers BC
DisplayHex:

    ;store original number to b (for later use (when getting the second digit))
    ld b, a

    ;get the first digit
    swap a
    and a, $0F

    ;digit tile offset (font starts at $01)
    inc a

    ;write first digit
    ld [hl+], a

    ;get the second digit
    ld a, b
    and a, $0F

    ;digit tile offset
    inc a

    ;write second digit
    ld [hl+], a

    ret

.end