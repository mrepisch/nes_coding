
graphics_ppu_start = $0200 ; PPU Memory start address
graphics_ppu_offset = $0120 ; counter to the last set byte 
graphics_temp = $0121 ; Temporary value for the load loop
graphics_current_x_to_set = $0122 ; Use this from outsite as parameter
graphics_current_y_to_set = $0123 ; Use this from outsite as parameter
graphics_current_offset_in_ppu_memory = $0124 ; Use this from outsite as parameter

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

; Set the new Y position for the 4 sprites          xx
;                                                   xx
; Overwrites x and y register !!!!
; Combine more 4 blocks to bigger sprites
; Sprite list always needs the same pattern for x and y positions
;       Y   TileID            X
; .byte $08, $3A, %00000000, $08   ;sprite 0
; .byte $08, $37, %00000000, $10   ;sprite 1
; .byte $10, $4f, %00000000, $08   ;sprite 2
; .byte $10, $4f, %01000000, $10   ;sprite 3

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