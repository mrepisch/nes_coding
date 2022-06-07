; Math addresses starts at $70
math_offset         = $70
math_value_to_add   = $71  
math_temp           = $72
math_result         = $80

Mathmultiply:
    sta math_value_to_add
    lda #$00
multiLopp:
    clc
    adc math_value_to_add
    dex 
    cpx #$00
    bne multiLopp
    

rts



MathSquare:
    ldy #$00
    sty math_offset
    
    tax 
    sta math_value_to_add
    lda #$00

MathSquareLoop:
    ldy math_offset
    clc 
    adc math_value_to_add
    ; check if result is bigger then 255
    bcs MathWriteOverflow
    ; if no carry was set
    sta math_result, y
    
AfterOverflow:
    dex
    cpx #$00
    bne MathSquareLoop
rts

MathWriteOverflow:
    sta math_temp

    lda #$FF
    sta math_result, y
    iny 
    sty math_offset
    lda math_temp
    jmp AfterOverflow

    
