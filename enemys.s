

update:
    ldx enemy_counter
    cpx #$04
    bne LoadNewEnemy
    jmp UpdateEnemyPositions


LoadNewEnemy:
    ldx #$00 ; loop counter
    lda #$00 ; calculatet offset value

CalculateOffsetForGraphics:
    cpx enemy_counter
    bne IncrementOffsettForGraphics
    jmp StoreOffeset
IncrementOffsettForGraphics:
    adc #$10
    inx
    jmp CalculateOffsetForGraphics

StoreOffeset:
    sta current_offset
    ldx #$00
    tay 

LoadEnemySpritesLoop:
    LDA enemy_sprite, x   ; load data from address (sprites +  x)
    STA $0230, y          ; store into RAM address ($0200 + y)
    INX                   ; X = X + 1
    iny
    CPX #$10              ; Compare X to hex $10, decimal 16
    BNE LoadEnemySpritesLoop   ; Branch to LoadSpritesLoop if compare was Not Equal to zero
                        ; if compare was equal to 32, keep going down 
StoreEnemyData:

lda #$00
ldx #$00
OffsetLoop:
    cpx enemy_counter
    bne IncrementOffset
    jmp LoadEnemyDataIntoRam
IncrementOffset:
    adc #$04
    inx
    jmp OffsetLoop

LoadEnemyDataIntoRam:
SetYPos:
    tay
    ldx random_table_index
    lda random_numbers_list, x
    sta enemy_data_list, y
    iny
    inx 
    cpx #$07;Reset index if 8
    beq ResetCounter
    stx random_table_index
    jmp setXPos;
ResetCounter:
    ldx #$00
    stx random_table_index;
setXPos:
    lda #$F5
    sta enemy_data_list, y;
    

IncrementEnemyCounter:
    ldx enemy_counter
    inx
    stx enemy_counter
    jmp UpdateEnemeyPositionsInit

UpdateEnemyPositions:
    ;  Just move every 20 Frames
    ldx frame_counter_for_movement
    cpx #$14
    beq UpdateEnemeyPositionsInit
    jmp UpdateEnemyDone

UpdateEnemeyPositionsInit:
    ; In PPU start at $0230
    ; loop index from 0 to enemycounter
    ldx #$00
    stx frame_counter_for_movement
    stx enemy_index
    ldx #$00 ; Dataoffset
    ldy #$00 ; Graphic offset
UpdateEnemyPositionLoop:
    ; Set y Positions
    lda enemy_data_list, x
    sta $0230, y
    sta $0234, y
    adc #$07
    sta $0238, y
    sta $023C, y

    INX ; Increment offset for the y position by 1
    lda enemy_data_list, x
    
    sta $0233, y
    sta $023B, y
    adc #$08
    sta $0237, y
    sta $023F, y
 
    lda enemy_data_list, x 
    sbc #$01
    sta enemy_data_list, x
    DEX ; Decrement the offset to go back to the x position for the next enemy

    lda enemy_index ; load the current enemyIndex
    cmp #$03
    bne IncrementUpdateOffsets
    jmp UpdateEnemyDone

IncrementUpdateOffsets:
    txa 
    clc
    adc #$04
    tax  ; Update data offset
    
    tya 
    clc
    adc #$10
    tay ; Update Grapic Offset

    lda enemy_index
    adc #$01
    sta enemy_index

    jmp UpdateEnemyPositionLoop

UpdateEnemyDone:
    ; Upgrade the frame counter
    ldx frame_counter_for_movement
    inx
    stx frame_counter_for_movement