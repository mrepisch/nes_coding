;player from $00 to $0F
player_x                = $00
player_y                = $01
player_velocity         = $02



PlayerInit:
  ldx #$14
  stx player_spawn_counter
  ldx #$08
  stx player_x
  ldx #$7F
  stx player_y
  ldx #$05
  stx player_velocity
  ldx #00
  stx player_can_create_shot_flag
rts

PlayerDraw:
  ; y pos
  LDA player_y
  STA $0200
  sta $0204 
  CLC
  ADC #$08
  STA $0208
  STA $020C

  lda player_x
  STA $0203
  STA $020B
  CLC
  ADC #$08
  STA $0207
  STA $020F
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