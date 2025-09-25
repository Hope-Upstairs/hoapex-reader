# "Hoapex Reader"?

A simple hex viewer for the Gameboy.

I made it in like a day because I wanted to back up my save file from a bootleg Link's Awakening DX cart I have.

I don't have a link cable or a dedicated dumper device so this is the best option I could think of.

![screenshot of the hex viewer](https://github.com/Hope-Upstairs/hoapex-reader/blob/main/GBI00019.PNG)

# Usage

Starting up:

- Load the rom.
- Wait for a loud BEEEEEEEP sound.
- Unplug the flashcart, plug in another cartridge.
- If the EEEEEEEEEE stopped, the gameboy crashed. Try again.
- If the EEEEEEEE is still audible, press any button to start the hex viewer.

Viewer:
- The target address (XYZ0) appears in the top-left corner.
- Press up/down to increase/decrease XY.
- Press left/right to switch Z between 0 and 8. (for example, from $4B00 you get $4B80)
- Press B to swap XY to YX. (for example, from $4B80 you get $B480)
- Press A to read $80 bytes from the target address onwards.

# It achieves its only goal

That's all it does, it reads data with another cartridge plugged in.

It doesn't let you switch banks manually.

I made it specifically to dump my Link's Awakening DX save file so it enables reading SRAM Bank 0 on MBC5.

Also tested it with Gargoyle's Quest (MBC1) and Rayman (MBC5), neither of which have save batteries. ROM read fine apparently.

Behaviour untested with other mappers.

# Requirements:

Requires [RGBDS](https://github.com/gbdev/rgbds/).

# Building:

Run `build.bat`
