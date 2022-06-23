;shot data from $10
shot_position_x             = $10
shot_position_y             = $11
shot_velocity               = $12
shot_active                 = $13
shot_ppu_offset             = $14

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
    ; Load the grapic
    ldy #$20 ; Offset in spritelist
    lda graphics_sprite_list, y ; load the first byte
    ldx #$04 ; How many bytes in the total graphic
    jsr GraphicsLoadSprite
    lda graphics_ppu_offset
    sec
    sbc #$04
    sta shot_ppu_offset
    ; load logic and position
    ldx player_x
    stx shot_position_x
    ldx player_y
    stx shot_position_y
    ldx #$01
    stx shot_active
    

ShotLoadDone:
    
rts



ShotUpdate:
    ldy shot_active
    cpy #$01
    bne ShotUpdateDone

ShotUpdateWhenActive:
    lda shot_position_x
    clc
    adc shot_velocity
    sta shot_position_x
    bcc ShotUpdateDone
    ldy shot_ppu_offset
    ldx #$04 ; 4 bytes to clear for the shot graphic
    jsr GraphicsDeleteSprite
    ldx #$00
    stx shot_active
    
ShotUpdateDone:
rts

ShotDraw:
    ldx shot_active
    cpx #$01
    bne ShotRenderDone    
ShotRender:
    ldx shot_position_x
    stx graphics_current_x_to_set
    ldx shot_position_y
    stx graphics_current_y_to_set
    ldx shot_ppu_offset
    stx graphics_current_offset_in_ppu_memory
    jsr GraphicsUpdatePPUSingleSprite
ShotRenderDone:

rts