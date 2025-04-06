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
