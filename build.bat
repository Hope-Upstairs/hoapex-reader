mkdir "temp"
cd asm
rgbasm -o "../temp/main.o" "main.asm"
cd ..
rgblink -o "main.gb" "temp/main.o"
rgbfix -v -m 0x1B -p 0xFF -r 0x03 "main.gb"
rgblink -n "main.sym" "temp/main.o"
rmdir "temp" /s /q
