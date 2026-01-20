; ROM Версия.
; Тест памяти для компьютеров Ленинград с 48 кб оперативной памяти
; Специально для мероприятия "Чинители прекрасного"
; Михаил Каа
; 06.04.2025

    DEVICE ZXSPECTRUM48
    ORG 0x0000

start:
    di
    jp main

    ORG 0x0100
main:

    ; Заполнение атрибутов байтом 0x38
    ld hl, 0x4000      
    ld de, 0x4001
    ld bc, 6143+767
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
