; Тест памяти для компьютеров Ленинград с 48 кб оперативной памяти
; Специально для мероприятия "Чиним прекрасное"
; Михаил Каа
; 06.04.2025

    DEVICE ZXSPECTRUM48
    ORG 0x4000
    
MT_START_ADR EQU  0x59FF

start:
    di
main:
    ; Формируем адрес тестируемой ячейки
    ld bc, (adr)            ; Адрес тестируемой ячейки в BC
    inc bc
    ; Проверка BC на достижение конца памяти
    ld a, b                 ; Загружаем старший байт BC в A
    cp 0xff                 ; Сравниваем B с 0xFF
    jr nz, .skip            ; Если не равно - пропускаем
    ld a, c                 ; Загружаем младший байт BC в A
    cp 0xff                 ; Сравниваем C с 0xFF
    jr nz, .skip            ; Если не равно - пропускаем
    ; Достигли конца памяти - начнем с MT_START_ADR
    ld bc, MT_START_ADR+1   ; Устанавливаем началльный адрес памяти в BC 
    ld (adr),  bc

    ; Циклически меняет значение pattern 0x00 -> 0x55 -> 0xaa -> 0xff
    ld hl, pattern
    ld a, (hl)              ; Загружаем значение паттерна в A
    cp 0xff                 ; Сравниваем с 0xff
    jr z, .pattern_set_0    ; Если равно 0xff -> меняем на 0x00
    add a, 0x55             ; Если не равно 0xff прибавляем 0x55
    ld (hl), a
    jr .skip
.pattern_set_0
    inc a                   ; Если равно 0xff -> прибавляем 1 и получем 0x00
    ld (hl), a              ; Сохраняем переменную хранящую значение паттерна.
.skip:

    ; Тест
    ld (adr), bc
    ld a, (pattern)
    ld (bc), a              ; Записываем паттерн
    ld d, a                 ; Сохраняем паттерн в D
    ld a, (bc)              ; Читаем обратно
    xor d                   ; Сравниваем с оригиналом
    ld (result), a          ; Сохраняем маску ошибок

;     ld bc, (adr)
;     ld a, c         ; Загружаем байт из BC в A
;     cp 0xff         ; Сравниваем с 0xff
;     jr nz, .skipt   ; Если не равно - пропускаем
;     ld a, 0xff
;     ld (result), a
; .skipt

    cp 0
    jr z, .skip_border      ; Если равно 0 (ячейка в порядке)
    ld a, 0b00000010        ; Бордюр красный
    out (0xfe), a
    ld bc, 16384
.delay_loop                 ; Задержка
    dec bc
    ld a, b
    or c
    jr nz, .delay_loop
    ld a, 0b00000001        ; Бордюр синий
    out (0xfe), a
.skip_border

    ; ld a, 0x55
    ; ld (result), a

    ; Отображение.
    ld hl, 0x5800+32*7
    ld b, 8                 ; 8 битов для обработки
    ld a, (result)
    ld c, a                 ; Сохраняем в С результат проверки ячейки
.draw_loop:
    sla c                   ; Сдвигаем старший бит в C
    jr c, .red_attr         ; Если бит = 1 - красный
.green_attr:
    ld (hl), %00100100      ; Зеленый (ячейка ОК)
    jr .next
.red_attr:
    ld (hl), %00010010      ; Красный (ячейка с сбоем)
.next:
    inc hl                  ; Следующий атрибут через один
    inc hl
    djnz .draw_loop         ; Повторить для всех 8 битов

    jp main

pattern:
    DB 0x00
result:
    DB 0x00
adr:
    DW MT_START_ADR

end:
    ; Выводим размер банарника.
    display "l48ramt code size: ", /d, end - start
    display "l48ramt code start: ", /d, start
    display "l48ramt code end: ", /d, end
    
    ; Создаем бинарный файл.
    SAVEBIN "build/l48ramt.bin", start, end - start
    ; Создаем "ленту".
    ; SAVETAP "build/l48ramt.tap", CODE, "l48ramt", start, end - start, 16384
    SAVETAP "build/l48ramt.tap", start