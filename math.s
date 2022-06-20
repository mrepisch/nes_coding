; Math addresses starts at $70
math_value_to_add   = $70

; a -> value to multiply
; x -> the factor
; result will be stored in a

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