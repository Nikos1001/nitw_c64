
; LAYOUT CONSTANTS
n_strings = 4

note_area_width = 12
note_area_height = 16
note_area_min_x = (screen_w - note_area_width) / 2
note_area_max_x = note_area_min_x + note_area_width - 1
note_area_min_y = 2
note_area_max_y = note_area_min_y + note_area_height - 1

string_spacing = 3
string0_x = (screen_w - (n_strings - 1) * string_spacing - 1) / 2 
string_x .sfunction idx, string0_x + idx * string_spacing
string1_x = string_x(1) 
string2_x = string_x(2) 
string3_x = string_x(3) 

lyric_line0_y = 21

top_sprite_y = sprite_min_y + 4 * 8
btm_sprite_y = sprite_min_y + 11 * 8 - 4

setup_screen_layout

    ; make screen black 
    lda #color_black 
    sta border_color
    sta background_color 

    ; fill screen with black full chars
    ldx #0
    clear_screen_loop
        lda #char_full
        sta screen_chars, x
        sta screen_chars + $100, x
        sta screen_chars + $200, x
        sta screen_chars + $300, x

        lda #color_black
        sta screen_color, x
        sta screen_color + $100, x
        sta screen_color + $200, x
        sta screen_color + $300, x
        dex
        bne clear_screen_loop
    
    ; clear string screen area
    ldx #(note_area_width - 1 + screen_w * 6)
    clear_strings_row_loop
        ldy #note_area_width
        clear_strings_col_loop
            lda #char_blank
            sta screen_chars_addr(note_area_min_x, 0), x
            sta screen_chars_addr(note_area_min_x, 6), x
            sta screen_chars_addr(note_area_min_x, 12), x

            cpx #0
            beq clear_strings_end
            dex
            dey
            bne clear_strings_col_loop
        txa
        sbc #(screen_w - note_area_width)
        tax
        jmp clear_strings_row_loop
    clear_strings_end

    ; draw fret bar
    ldx #0
    draw_fret_bar_loop
        lda #char_fret_bar
        sta screen_chars_addr(note_area_min_x, note_area_max_y + 1), x

        lda #char_top_bar
        sta screen_chars_addr(note_area_min_x, note_area_min_y - 1), x
        
        lda #color_white
        sta screen_color_addr(note_area_min_x, note_area_max_y + 1), x
        sta screen_color_addr(note_area_min_x, note_area_min_y - 1), x

        inx
        cpx #note_area_width
        bne draw_fret_bar_loop

    ; draw strings
    ldx #0
    draw_strings_loop
        lda #char_string0
        sta screen_chars_addr(15, 2), x
        sta screen_chars_addr(15, 6), x
        sta screen_chars_addr(15, 10), x
        sta screen_chars_addr(15, 14), x
        lda #char_string1
        sta screen_chars_addr(18, 2), x
        sta screen_chars_addr(18, 6), x
        sta screen_chars_addr(18, 10), x
        sta screen_chars_addr(18, 14), x
        lda #char_string2
        sta screen_chars_addr(21, 2), x
        sta screen_chars_addr(21, 6), x
        sta screen_chars_addr(21, 10), x
        sta screen_chars_addr(21, 14), x
        lda #char_string3
        sta screen_chars_addr(24, 2), x
        sta screen_chars_addr(24, 6), x
        sta screen_chars_addr(24, 10), x
        sta screen_chars_addr(24, 14), x

        lda #color_white
        sta screen_color_addr(15, 2), x
        sta screen_color_addr(15, 6), x
        sta screen_color_addr(15, 10), x
        sta screen_color_addr(15, 14), x
        sta screen_color_addr(18, 2), x
        sta screen_color_addr(18, 6), x
        sta screen_color_addr(18, 10), x
        sta screen_color_addr(18, 14), x
        sta screen_color_addr(21, 2), x
        sta screen_color_addr(21, 6), x
        sta screen_color_addr(21, 10), x
        sta screen_color_addr(21, 14), x
        sta screen_color_addr(24, 2), x
        sta screen_color_addr(24, 6), x
        sta screen_color_addr(24, 10), x
        sta screen_color_addr(24, 14), x

        txa
        clc
        adc #screen_w
        tax
        cpx #(screen_w * 4)
        bne draw_strings_loop
    
    ; setup sprites
    lda #%11111111
    sta sprite_enable
    sta sprite_x_expansions
    lda #%00111111
    sta sprite_y_expansions

    lda #%11000000
    sta sprite_priority

    lda #bea_face
    sta sprite_data_ptr(0) 

    lda #bea_pupil
    sta sprite_data_ptr(1) 

    lda #bea_details
    sta sprite_data_ptr(2) 

    lda #gregg_face
    sta sprite_data_ptr(3) 

    lda #gregg_teeth
    sta sprite_data_ptr(4) 

    lda #gregg_nose_eye
    sta sprite_data_ptr(5) 

    lda #beatline_sprite_data
    sta sprite_data_ptr(6) 
    sta sprite_data_ptr(7)

    lda #(sprite_min_x + 4 * 8 + 2) ; left x
    sta sprite_x(0)
    sta sprite_x(1)
    sta sprite_x(2) 

    lda #angus_min_x ; right x
    sta sprite_x(3) 
    sta sprite_x(4)
    sta sprite_x(5)

    lda #%00000000
    sta sprite_x_msbs

    ; beatline sprite x-vals 
    lda #(sprite_min_x + note_area_min_x * 8 - 7)
    sta sprite_x(6) 
    lda #(sprite_min_x + note_area_min_x * 8 + 24 * 2 - 7)
    sta sprite_x(7)

    ; top y-val
    lda #top_sprite_y
    sta sprite_y(0)
    sta sprite_y(1)
    sta sprite_y(2)
    sta sprite_y(3)
    sta sprite_y(4)
    sta sprite_y(5)

    ; beatline sprite y-vals
    lda #(sprite_min_y + note_area_min_y * 8)
    sta sprite_y(6)
    sta sprite_y(7)

    lda #color_light_blue
    sta sprite_color(0)

    lda #color_red
    sta sprite_color(1)

    lda #color_black
    sta sprite_color(2)

    lda #color_orange
    sta sprite_color(3)

    lda #color_white
    sta sprite_color(4)

    lda #color_black
    sta sprite_color(5)

    ; beatline sprite colors
    lda #color_dark_grey
    sta sprite_color(6)
    sta sprite_color(7)

    ; character backgrounds
    lda #color_yellow
    .for i in range(4, 12) ; this is where code size comes to die
        .for j in range(4, 10)
            sta screen_color_addr(i, j)
        .endfor
    .endfor

    lda #color_light_red
    .for i in range(4, 12)
        .for j in range(10, 16)
            sta screen_color_addr(i, j)
        .endfor
    .endfor

    lda #color_light_red
    .for i in range(28, 36)
        .for j in range(4, 10)
            sta screen_color_addr(i, j)
        .endfor
    .endfor

    lda #color_cyan
    .for i in range(28, 36)
        .for j in range(10, 16)
            sta screen_color_addr(i, j)
        .endfor
    .endfor

    rts
