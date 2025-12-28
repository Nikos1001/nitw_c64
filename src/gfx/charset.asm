
* = $2000 ; CUSTOM CHARACTER SET
charset
; first half of charset will be copied from the default chars

* = $2400 
char_blank = 128 
    .byte %00000000
    .byte %00000000
    .byte %00000000
    .byte %00000000
    .byte %00000000
    .byte %00000000
    .byte %00000000
    .byte %00000000
char_full = 129
    .byte %11111111 
    .byte %11111111 
    .byte %11111111 
    .byte %11111111 
    .byte %11111111 
    .byte %11111111 
    .byte %11111111 
    .byte %11111111 
char_fret_bar = 130
    .byte %11111111 
    .byte %11111111 
    .byte %11111111 
    .byte %00000000
    .byte %00000000
    .byte %00000000
    .byte %00000000
    .byte %00000000
char_top_bar = 131
    .byte %00000000
    .byte %00000000
    .byte %00000000
    .byte %00000000
    .byte %00000000
    .byte %11111111 
    .byte %11111111 
    .byte %11111111 
char_string0 = 132
    .byte %00011000
    .byte %00011000
    .byte %00011000
    .byte %00011000
    .byte %00011000
    .byte %00011000
    .byte %00011000
    .byte %00011000
char_string1 = 133
    .byte %00011000
    .byte %00011000
    .byte %00011000
    .byte %00011000
    .byte %00011000
    .byte %00011000
    .byte %00011000
    .byte %00011000
char_string2 = 134
    .byte %00011000
    .byte %00011000
    .byte %00011000
    .byte %00011000
    .byte %00011000
    .byte %00011000
    .byte %00011000
    .byte %00011000
char_string3 = 135
    .byte %00011000
    .byte %00011000
    .byte %00011000
    .byte %00011000
    .byte %00011000
    .byte %00011000
    .byte %00011000
    .byte %00011000
char_note = 136
    .byte %01111110
    .byte %11111111
    .byte %11111111
    .byte %11111111
    .byte %11111111
    .byte %11111111
    .byte %11111111
    .byte %01111110
char_string0_note_top = 137
char_string1_note_top = 138
char_string2_note_top = 139
char_string3_note_top = 140
char_string0_note_mid = 141
char_string1_note_mid = 142
char_string2_note_mid = 143
char_string3_note_mid = 144
char_string0_note_btm = 145
char_string1_note_btm = 146
char_string2_note_btm = 147
char_string3_note_btm = 148
    ; placeholder null bytes
    ; these characters are animated from char_note and the corresponding string char
    .rept 8 * 4 * 3 
        .byte 0
    .endrept

char_addr .sfunction idx, charset + 8 * idx 
char_string .sfunction idx, char_string0 + idx
char_note_top .sfunction idx, char_string0_note_top + idx
char_note_mid .sfunction idx, char_string0_note_mid + idx
char_note_btm .sfunction idx, char_string0_note_btm + idx