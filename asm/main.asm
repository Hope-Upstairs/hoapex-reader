INCLUDE "../hardware.inc"

SECTION "Header", ROM0[$100]

    jp EntryPoint

    ds $150 - @, 0 ; Make room for the header

INCLUDE "macros.asm"

INCLUDE "startup.asm"

INCLUDE "functions.asm"

sprFont:
	INCBIN "../font.bin"
.end

INCLUDE "mainLoop.asm"

INCLUDE "memVariables.asm"