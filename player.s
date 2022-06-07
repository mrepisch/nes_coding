;player from $00 to $0F
player_x        = $00
player_y        = $01
player_velocity = $02

PlayerInit:
  ldx #$08
  stx player_x
  ldx #$7F
  stx player_y
  ldx #$05
  stx player_velocity
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


LatchController:
  LDA #$01
  STA $4016
  LDA #$00
  STA $4016       ; tell both the controllers to latch buttons


  ldx #$00
InputLoop:
  LDA $4016       ; player 1 - A
  AND #%00000001  ; only look at bit 0
  BNE ButtonPressed
AfterButtonPressed:  
  inx 
  cpx #$08
  bne InputLoop
rts  

ButtonPressed:
  txa 
  sta $04
  cpx #$00
  beq A_ButtonPressed
  cpx #$04
  beq Up_Pressed
  cpx #$05
  beq DownPressed

A_ButtonPressed:
  ;jsr ShotLoad ; Problem
  jmp AfterButtonPressed

Up_Pressed:
  lda player_y
  sec
  sbc player_velocity
  bcc SetPlayerTo00
  sta player_y
  jmp AfterButtonPressed

SetPlayerTo00:
lda #$08
sta player_y
jmp AfterButtonPressed


DownPressed:
  lda player_y
  clc
  adc player_velocity
  cmp #$D0
  bcs SetPlayerToFF
  sta player_y
  jmp AfterButtonPressed

SetPlayerToFF:
  lda #$D0
  sta player_y
  jmp AfterButtonPressed