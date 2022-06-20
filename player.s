;player from $00 to $0F
player_x                = $00
player_y                = $01
player_velocity         = $02

PlayerInit:
  ldx #$08
  stx player_x
  ldx #$7F
  stx player_y
  ldx #$05
  stx player_velocity
  ; Load Player sprite
  ldx #$10
  ldy #$00
  jsr GraphicsLoadSprite

rts

PlayerDraw:
  lda player_x
  sta graphics_current_x_to_set
  lda player_y
  sta graphics_current_y_to_set
  lda #$00
  sta graphics_current_offset_in_ppu_memory
  jsr GraphicsUpdatePPU 
rts


PlayerUpdate:
  lda input_handler_controller_1
  and #BUTTON_DOWN 
  bne DownPressed
PlayerAfterDownPressed:
  lda input_handler_controller_1
  and #BUTTON_UP
  bne UpPressed
PlayerAfterUpPressed:
  lda input_handler_controller_1
  and #BUTTON_A
  bne AButtonPressed
AfterButtonAPressed:

UpdateEnd:
rts

AButtonPressed:  
  ldx player_x
  ldy player_y
  jsr ShotLoad
  jmp AfterButtonAPressed

UpPressed:
  lda player_y
  sec
  sbc player_velocity
  bcc SetPlayerTo00
  sta player_y
  jmp PlayerAfterUpPressed;

SetPlayerTo00:
lda #$08
sta player_y
jmp PlayerAfterUpPressed

DownPressed:
  lda player_y
  clc
  adc player_velocity
  cmp #$D0
  bcs SetPlayerToFF
  sta player_y
  jmp PlayerAfterDownPressed;

SetPlayerToFF:
  lda #$D0
  sta player_y
  jmp PlayerAfterDownPressed