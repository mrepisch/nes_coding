LoadPalette:
  LDA $2002             ; read PPU status to reset the high/low latch
  LDA #$3F
  STA $2006             ; write the high byte of $3F00 address
  LDA #$00
  STA $2006             ; write the low byte of $3F00 address
  LDX #$00              ; start out at 0
LoadBackgroundPaletteLoop:
  LDA background_palette, x        ; load data from address (palette + the value in x)
                          ; 1st time through loop it will load palette+0
                          ; 2nd time through loop it will load palette+1
                          ; 3rd time through loop it will load palette+2
                          ; etc
  STA $2007             ; write to PPU
  INX                   ; X = X + 1
  CPX #$10              ; Compare X to hex $10, decimal 16
  BNE LoadBackgroundPaletteLoop  ; Branch to LoadBackgroundPaletteLoop if compare was Not Equal to zero
  
  LDX #$00      
        
LoadSpritePaletteLoop:
  LDA sprite_palette, x     ;load palette byte
  STA $2007					;write to PPU
  INX                   	;set index to next byte
  CPX #$10            
  BNE LoadSpritePaletteLoop  ;if x = $10, all done

  LDA #%10000000   ; enable NMI, sprites from Pattern Table 0
  STA $2000
  
  LDA #%00010000   ; enable sprites
  STA $2001

  jsr GraphicsInit
  jsr PlayerInit
  jsr ShotInit
  jsr EnemyInit


