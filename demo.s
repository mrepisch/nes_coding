.segment "HEADER"
  ; .byte "NES", $1A      ; iNES header identifier
  .byte $4E, $45, $53, $1A
  .byte 2               ; 2x 16KB PRG code
  .byte 1               ; 1x  8KB CHR data
  .byte $01, $00        ; mapper 0, vertical mirroring

.segment "VECTORS"
  ;; When an NMI happens (once per frame if enabled) the label nmi:
  .addr NMI
  ;; When the processor first turns on or is reset, it will jump to the label reset:
  .addr RESET
  ;; External interrupt IRQ (unused)
  .addr 0

; "nes" linker config requires a STARTUP section, even if it's empty
.segment "STARTUP"


; Main code segement for the program
.segment "CODE"
.include "math.s"
.include "graphics.s"
.include "reset.s"
.include "inputHandler.s"
.include "player.s"
.include "shot.s"
.include "enemys.s"


NMI:

LDA #$00
STA $2003       ; set the low byte (00) of the RAM address
LDA #$02
STA $4014       ; set the high byte (02) of the RAM address, start the transfer

jsr InputHandlerStart

jsr EnemyLoad;
jsr EnemyUpdate
jsr PlayerUpdate

jsr PlayerDraw
jsr EnemyRender
;UpdateShotsCall:
  jsr ShotUpdate
  jsr ShotDraw
;
RTI




background_palette:
  .byte $22,$29,$1A,$0F	;background palette 1
  .byte $22,$36,$17,$0F	;background palette 2
  .byte $22,$30,$21,$0F	;background palette 3
  .byte $22,$27,$17,$0F	;background palette 4
  
sprite_palette:
  .byte $22,$16,$27,$18	;sprite palette 1
  .byte $22,$1A,$30,$27	;sprite palette 2
  .byte $22,$16,$30,$27	;sprite palette 3
  .byte $22,$0F,$36,$17	;sprite palette 4

sprites:

shot_sprite:
  .byte $08, $75, %00000000, $08

enemy_data_block: 
  .byte $08, $08, $00, $00

graphics_sprite_list: 
  ; Mario
  .byte $08, $3A, %00000000, $08   ;sprite 0
  .byte $08, $37, %00000000, $10   ;sprite 1
  .byte $10, $4f, %00000000, $08   ;sprite 2
  .byte $10, $4f, %01000000, $10   ;sprite 3
 ; Goomba
  .byte $08, $70, %00000000, $08   ;sprite 0
  .byte $08, $71, %00000000, $10   ;sprite 1
  .byte $10, $72, %00000000, $08   ;sprite 2
  .byte $10, $73, %00000000, $10   ;sprite 3


rnd_table:
  .byte $3B, $08, $7A, $BC
  .byte $08, $7A, $3B, $BC

.segment "CHARS"
 .incbin "mario.chr"   ;includes 8KB graphics file from SMB1