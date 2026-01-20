; Тест памяти для компьютеров Ленинград с 48 кб оперативной памяти
; Специально для мероприятия "Чинители прекрасного"
; Михаил Каа
; 06.04.2025

    DEVICE ZXSPECTRUM48
    ORG 0x4000
    
MT_START_ADR EQU  0x59FF
; MT_ATR_ADR EQU  0x5800
MT_ATR_ADR EQU  0x5800+0x00e0

start:
    di
main:
    ; Формируем адрес тестируемой ячейки
    ld bc, (adr)            ; Адрес тестируемой ячейки в BC
    inc bc
    ; Проверка BC на достижение конца памяти
    ld a, b                 ; Загружаем старший байт BC в A
    inc a                   ; Инкрементируем
    jr nz, .skip            ; Если не ноль - пропускаем
    ld a, c                 ; Загружаем младший байт BC в A
    inc a                   ; Инкрементируем
    jr nz, .skip            ; Если не ноль - пропускаем
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
    ld (adr), bc

    ; Тест
    ld a, (pattern)
    ld (bc), a              ; Записываем паттерн
    ld d, a                 ; Сохраняем паттерн в D
    ld a, (bc)              ; Читаем обратно
    xor d                   ; Сравниваем с оригиналом
    ld (result), a          ; Сохраняем маску ошибок

; Этот блок типо тест - если адрес совпал, то result 0x55
;     ld bc, (adr)
;     ld a, b         ; Загружаем байт из BC в A
;     cp 0xfa         ; Сравниваем с 0x60
;     jr nz, .skipt   ; Если не равно - пропускаем
;     ld a, c         ; Загружаем байт BC в A
;     cp 0xfa         ; Сравниваем с 0x00
;     jr nz, .skipt   ; Если не равно - пропускаем
;     ld a, 0xff
;     ld (result), a
; .skipt
;     ld a, (result)

; Этот блок - тест отображения.
; ld a, 0x55
; ld (result), a

    ; Отображение.
    ld hl, MT_ATR_ADR
    ld b, 8                 ; 8 битов для обработки
    ld a, (result)
    ld c, a                 ; Сохраняем в С результат проверки ячейки
.draw_loop:
    ; Отображение от старшего к младшему биту.
    sla c                   ; Сдвигаем старший бит влево
    jr c, .red_attr         ; Если бит = 1 - красный
.green_attr:
    ld (hl), 0b00100100     ; Зеленый (ячейка ОК)
    jr .next
.red_attr:
    ld (hl), 0b00010010     ; Красный (ячейка с сбоем)
    ld a, 0b00000010        ; Бордюр красный
    out (0xfe), a
    ld de, 2048
.delay_loop                 ; Задержка
    dec de
    ld a, d
    or e
    jr nz, .delay_loop
    ld a, 0b00000001        ; Бордюр синий
    out (0xfe), a
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

    ORG 0x4800
    INCBIN "logo.scr", 0x800, 0x1000 ; include 0x1000 bytes from offset 0x800
end:
    ; Выводим размер бинарника.
    display "l48ramt code size: ", /d, end - start
    display "l48ramt code start: ", /d, start
    display "l48ramt code end: ", /d, end
    
    ; Создаем бинарный файл.
    SAVEBIN "build/l48ramt.bin", start, end - start
    ; Создаем "ленту".
    ; SAVETAP "build/l48ramt.tap", CODE, "l48ramt", start, end - start, 16384
    SAVETAP "build/l48ramt.tap", start
