;shot data from $10
shot_position_x             = $10
shot_position_y             = $11
shot_velocity               = $12
shot_active                 = $13

ShotInit:
    ldx #$00
    stx shot_position_x
    stx shot_position_y
    stx shot_active
    ldx #$05
    stx shot_velocity
    rts


ShotLoad:
; check if shot is not allready active
lda shot_active
cmp #$01
beq ShotLoadDone

ShotLoadStart:
stx shot_position_x
sty shot_position_y

ldx #$00
ShotLoadLoop:
    lda shot_sprite, x
    sta $0210, x
    inx
    cpx #$04
    bne ShotLoadLoop
lda #$01
sta shot_active

ShotLoadDone:
rts



ShotUpdate:
    ldy shot_active
    cpy #$01
    beq ShotUpdateWhenActive
    jmp ShotUpdateDone

ShotUpdateWhenActive:
    lda shot_position_x
    clc
    adc shot_velocity
    sta shot_position_x
    bcs DeleteShot
    jmp ShotUpdateDone

DeleteShot:
    ldx #$00
DeleteShotLoop:
    lda #$00
    sta $0210, x
    inx 
    cpx #$04
    bne DeleteShotLoop
    ldx #$00
    stx shot_active

ShotUpdateDone:
rts

ShotDraw:
    ldx shot_active
    cpx #$01
    beq ShotRender
    jmp ShotRenderDone    
ShotRender:
    lda shot_position_x
    sta $0213 
    lda shot_position_y
    sta $0210
ShotRenderDone:

rts