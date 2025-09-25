SECTION "Variables", WRAM0

;input
    wCurKeys: DB
    wNewKeys: DB
    vHexAddress: DW
    vHexStatus: DB

;yeah
    MainLoopInRam: DS (MainLoop.end - MainLoop)
    UpdateKeysInRam: DS (UpdateKeys.end - UpdateKeys)
    MemcopyInRam: DS (MemcopyForRam.end - MemcopyForRam)
    DisplayHexInRam: DS (DisplayHex.end - DisplayHex)
    InitScreenInRam: DS (InitScreen.end - InitScreen)
    DrawHexInRam: DS (DrawHex.end - DrawHex)

SECTION "Code In Vram", VRAM[$8110]
;yeah
    MainLoopInVram: DS (MainLoop.end - MainLoop)
    UpdateKeysInVram: DS (UpdateKeys.end - UpdateKeys)
    MemcopyInVRam: DS (MemcopyForVram.end - MemcopyForVram)
    MemcopyForRamInVRam: DS (MemcopyForRam.end - MemcopyForRam)
    WaitInVramInVram: DS (WaitInVram.end - WaitInVram)
    CopyInVram: DS (CopyFromVramToWram.end - CopyFromVramToWram)
    DisplayHexInVram: DS (DisplayHex.end - DisplayHex)
    InitScreenInVram: DS (InitScreen.end - InitScreen)
    DrawHexInVram: DS (DrawHex.end - DrawHex)