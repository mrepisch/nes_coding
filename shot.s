;shot data from $10
shot_position_x             = $10
shot_position_y             = $11
shot_velocity               = $12
shot_active                 = $13


ShotLoad:
lda player_x
sta shot_position_x
lda player_y
sta shot_position_y

ldx #$00
ShotLoadLoop:
    lda shot_sprite, x
    sta $0210, x
    inx
    cpx #$04
    bne ShotLoadLoop
lda #$01
sta shot_active
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

ShotUpdateDone:
rts

ShotDraw:
    lda shot_position_x
    sta $0213 
    lda shot_position_y
    sta $0210
    
rts