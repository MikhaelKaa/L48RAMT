; ROM Версия.
; Тест памяти для компьютеров Ленинград с 48 кб оперативной памяти
; Михаил Каа
; 20.01.2026

    DEVICE ZXSPECTRUM48
    ORG 0x0000

start:
    di
    ld a, 0b00000111        ; Бордюр белый
    out (0xfe), a
    jp main

    ORG 0x0100
main:
    ; Подготовка экрана
    ld hl, 0x5800      
    ld de, 0x5801
    ld bc, 767
    ld (hl), 0b00111000
    ldir

    ld hl, code             ; Код
    ld de, 0x4000           ; 
    ld bc, code_end - code  ; Длина блока
    ldir                    ; Копирование

    jp 0x4000
    jp main

    ORG 0x0200
code:
    INCBIN "../build/l48ramt.bin"
code_end:

end:
    ; Выводим размер кода.
    display "code size: ", /d, code_end - code

    ; Выводим размер бинарника.
    display "l48ramt_rom code size: ", /d, end - start
    display "l48ramt_rom code start: ", /d, start
    display "l48ramt_rom code end: ", /d, end
    
    ; Создаем бинарный файл.
    SAVEBIN "build/l48ramt.rom", start, 0x4000
