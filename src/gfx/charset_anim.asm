
string0_anim_frame .byte 0
string1_anim_frame .byte 0
string2_anim_frame .byte 0
string3_anim_frame .byte 0

animate_note_chars
    ; string chars
    ldx #0
    string_char_loop
        .block
        lda string0_anim_frame, x
        beq skip_string
            sec
            sbc #8
            sta string0_anim_frame, x
            tay

            clc
            txa
            rol
            rol
            rol
            tax
            .for i in range(8)
                lda string_pluck_animation + i, y
                sta char_addr(char_string0) + i, x
            .endfor
            clc
            txa
            ror
            ror
            ror
            tax
        skip_string

        inx
        cpx #4
        bne string_char_loop
        .endblock

    ; note chars
    ldx #0
    lda #0
    sec 
    sbc scroll_val8
    tay
    note_char_loop
        .block
        cpx scroll_val8
        bcs bellow_scroll
            .for i in range(4)
                lda char_addr(char_string(i)), x
                sta char_addr(char_note_top(i)), x
            .endfor

            lda char_addr(char_note) + 8 - 256, y
            .for i in range(4)
                sta char_addr(char_note_btm(i)), x
                sta char_addr(char_note_mid(i)), x 
            .endfor

            jmp skip_bellow_scroll
        bellow_scroll
            lda char_addr(char_note), y
            .for i in range(4)
                sta char_addr(char_note_top(i)), x
                sta char_addr(char_note_mid(i)), x 
            .endfor

            .for i in range(4)
                lda char_addr(char_string(i)), x
                sta char_addr(char_note_btm(i)), x
            .endfor
        skip_bellow_scroll

        iny
        inx
        cpx #8
        bne note_char_loop
        .endblock

    rts

string_pluck_animation
    ; frame 0
    .byte %00011000
    .byte %00011000
    .byte %00011000
    .byte %00011000
    .byte %00011000
    .byte %00011000
    .byte %00011000
    .byte %00011000

    ; frame 1
    .byte %00011000
    .byte %00011000
    .byte %00110000
    .byte %00110000
    .byte %00011000
    .byte %00011000
    .byte %00001100
    .byte %00001100
    
    ; frame 2
    .byte %00011000
    .byte %00011000
    .byte %00001100
    .byte %00001100
    .byte %00011000
    .byte %00011000
    .byte %00110000
    .byte %00110000

    ; frame 3
    .byte %00011000
    .byte %00011000
    .byte %00110000
    .byte %00110000
    .byte %00011000
    .byte %00011000
    .byte %00001100
    .byte %00001100
    
    ; frame 4
    .byte %00011000
    .byte %00011000
    .byte %00001100
    .byte %00001100
    .byte %00011000
    .byte %00011000
    .byte %00110000
    .byte %00110000

    ; frame 5
    .byte %00011000
    .byte %00011000
    .byte %00110000
    .byte %00110000
    .byte %00011000
    .byte %00011000
    .byte %00001100
    .byte %00001100 

    ; frame 6
    .byte %00011000
    .byte %00011000
    .byte %00001100
    .byte %00001100
    .byte %00011000
    .byte %00011000
    .byte %00110000
    .byte %00110000

    ; frame 7
    .byte %00011000
    .byte %00011000
    .byte %00110000
    .byte %00110000
    .byte %00001100
    .byte %00011000
    .byte %00001100 
