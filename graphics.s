
graphics_ppu_start = $0200
graphics_ppu_offset = $0120 ; counter to the last set byte 
graphics_temp = $0121
graphics_current_x_to_set = $0122
graphics_current_y_to_set = $0123
graphics_current_offset_in_ppu_memory = $0124

GraphicsInit:
    lda #$00
    sta graphics_ppu_offset
    rts

; a -> first byte of the sprite
; x -> Amount of bytes to store
; y -> offset in memory of the sprite_list

GraphicsLoadSprite:
    
GraphicsLoadSpriteLoop:
    lda graphics_sprite_list,  y
    sty graphics_temp

    ldy graphics_ppu_offset
    sta graphics_ppu_start, y
    iny
    sty graphics_ppu_offset
    
    ldy graphics_temp
    iny

    dex
    cpx #$00
    bne GraphicsLoadSpriteLoop

rts

; Set the new Y position for the 4x4 sprite
; Overwrites x and y register !!!!
GraphicsUpdatePPU:
    ldy #$00
    ldx graphics_current_offset_in_ppu_memory

    ; Y pos
    lda graphics_current_y_to_set
    sta graphics_ppu_start, x
    jsr GraphicsIncreaseXby4
    sta graphics_ppu_start, x
    clc
    adc #$08
    jsr GraphicsIncreaseXby4
    sta graphics_ppu_start, x
    jsr GraphicsIncreaseXby4
    sta graphics_ppu_start, x
    ; X Pos
    ldx graphics_current_offset_in_ppu_memory
    jsr GraphicsIncreaseXby3
    lda graphics_current_x_to_set

    sta graphics_ppu_start, x
    jsr GraphicsIncreaseXby4
    jsr GraphicsIncreaseXby4
    sta graphics_ppu_start, x

    jsr GraphicsIncreaseAby8

    ldx graphics_current_offset_in_ppu_memory
    jsr GraphicsIncreaseXby3
    jsr GraphicsIncreaseXby4
    sta graphics_ppu_start, x

    jsr GraphicsIncreaseXby4
    jsr GraphicsIncreaseXby4
    sta graphics_ppu_start, x
rts

GraphicsIncreaseAby8:
    clc
    adc #$08
rts

GraphicsIncreaseXby4:
    inx
    inx 
    inx 
    inx
rts

GraphicsIncreaseXby3:
    inx
    inx
    inx 
rts

