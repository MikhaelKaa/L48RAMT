#! /usr/bin/env bash
echo "Проверка установленного ПО для сборки"

# Проверяем установлен ли sjasmplus.
SJASMPLUS=`which sjasmplus` 
if [ -n "$SJASMPLUS" ]      # Проверяем что строка не пуста.
then
   echo "sjasmplus installed"
else
   echo "sjasmplus not installed"
   echo "https://github.com/z00m128/sjasmplus/blob/master/INSTALL.md"
   git clone --recursive -j8 https://github.com/z00m128/sjasmplus.git
   cd sjasmplus
   make
   sudo make install
   cd ..
fi

# Проверяем установлен ли sjasmplus.
TAPE2WAV=`which tape2wav` 
if [ -n "$TAPE2WAV" ]      # Проверяем что строка не пуста.
then
   echo "tape2wav installed"
else
   echo "tape2wav not installed"
   sudo apt-get install fuse-emulator-utils
fi

