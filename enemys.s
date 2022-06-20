enemy_counter = $20
enemy_data_index = $21
enemy_render_index = $22
enemy_rnd_table_index = $24
enemy_data    = $30
enemy_rnd_table = $60



EnemyInit:
    ldx #$01
    stx enemy_render_index
    ldx #$00
    stx enemy_counter
    stx enemy_rnd_table_index
LoadRndTableLoop:
    lda rnd_table,x
    sta enemy_rnd_table, x 
    inx
    cpx #$08
    bne LoadRndTableLoop

rts

EnemyLoad:
    ldx enemy_counter    
    cpx #$04
    beq EnemyLoadEnd

    ldx #$10
    ldy #$10
    jsr GraphicsLoadSprite



    ; get the data offset 
    ldx enemy_counter
    lda #$04
    jsr Mathmultiply
    sta enemy_data_index

    ; Generate y
    ldx enemy_rnd_table_index
    lda enemy_rnd_table, x 
    inx 
    cpx #$08
    bne EnemyLoadPositions
    ldx #$00
    stx enemy_rnd_table_index

EnemyLoadPositions:
    stx enemy_rnd_table_index
    ; Y Position
    ldx enemy_data_index
    sta enemy_data, x

    inx ; Increment x for since the x positions has an offset of 1
    ; X Positions
    lda #$ED
    sta enemy_data, x
    
    ; Increment the enemycounter 
    ldx enemy_counter
    inx
    stx enemy_counter
EnemyLoadEnd:

rts

EnemyUpdate:
    ldx #$00
    ldy #$01
EnemyUpdateLoop:
    lda enemy_data, y
    sec
    sbc #$01

    sta enemy_data, y
    iny
    iny
    iny
    iny

    inx 
    cpx enemy_counter
    bne EnemyUpdateLoop
rts


EnemyRender:
ldx #$00
stx enemy_render_index
ldy #00
EnemyRenderLoop:


    lda enemy_data, y
    sta graphics_current_y_to_set
    iny 
    lda enemy_data, y
    sta graphics_current_x_to_set
    

    iny ; Offset for data memory
    iny
    iny

    stx enemy_render_index
    jsr EnemyCalculateGraphicOffset
    sta graphics_current_offset_in_ppu_memory
    sty enemy_data_index
    jsr GraphicsUpdatePPU
    ;Store the x and y into a variable since the render 
    ;PPU Update subrutine overwrites the values !!!!!
    ldy enemy_data_index
    ldx enemy_render_index
    inx
    cpx enemy_counter
    bne EnemyRenderLoop ;

rts


EnemyCalculateGraphicOffset:
    lda #00
    adc #$10
EnemyOffsetCalculationLoop:
    clc
    adc #$10
    dex
    cpx #$00
    bne EnemyOffsetCalculationLoop
rts