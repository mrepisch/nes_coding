
BUTTON_A      = 1 << 7
BUTTON_B      = 1 << 6
BUTTON_SELECT = 1 << 5
BUTTON_START  = 1 << 4
BUTTON_UP     = 1 << 3
BUTTON_DOWN   = 1 << 2
BUTTON_LEFT   = 1 << 1
BUTTON_RIGHT  = 1 << 0


input_handler_controller_1 = $0100

InputHandlerStart: ; Start with reading the Controller
    lda #$01
    ; While the strobe bit is set, buttons will be continuously reloaded.
    ; This means that reading from JOYPAD1 will only return the state of the
    ; first button: button A.
    sta $4016
    sta input_handler_controller_1
    lsr a        ; now A is 0
    ; By storing 0 into JOYPAD1, the strobe bit is cleared and the reloading stops.
    ; This allows all 8 buttons (newly reloaded) to be read from JOYPAD1.
    sta $4016

ReadControllerLoop:
    lda $4016
    lsr a	       ; bit 0 -> Carry
    rol input_handler_controller_1  ; Carry -> bit 0; bit 7 -> Carry
    bcc ReadControllerLoop
    rts
rts