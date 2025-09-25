mkdir "temp"
python "buildStrings.py"
cd asm
rgbasm -o "../temp/main.o" "main.asm"
cd ..
rgblink -o "main.gb" "temp/main.o"
rgbfix -v -p 0xFF "main.gb"
rgblink -n "main.sym" "temp/main.o"
rm -r "temp"
