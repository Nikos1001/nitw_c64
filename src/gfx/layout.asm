
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
    sta sprite_y_expansions

    lda #(sprite_data / 64)
    sta sprite_data_ptr(0) 
    sta sprite_data_ptr(2) 
    sta sprite_data_ptr(4) 
    sta sprite_data_ptr(6) 
    lda #(sprite_data_2 / 64)
    sta sprite_data_ptr(1) 
    sta sprite_data_ptr(3) 
    sta sprite_data_ptr(5) 
    sta sprite_data_ptr(7)

    lda #(sprite_min_x + 4 * 8)
    sta sprite_x(0)
    sta sprite_x(1)
    sta sprite_x(2) 
    sta sprite_x(3) 

    lda #(sprite_min_x + 28 * 8 + 4 - 256)
    sta sprite_x(4) 
    sta sprite_x(5) 
    sta sprite_x(6) 
    sta sprite_x(7)

    lda #%11110000
    sta sprite_x_msbs

    lda #(sprite_min_y + 4 * 8 - 4)
    sta sprite_y(0)
    sta sprite_y(4)
    ; sta sprite_y(1)
    ; sta sprite_y(5)

    lda #(sprite_min_y + 12 * 8 - 4)
    sta sprite_y(2)
    sta sprite_y(6)
    ; sta sprite_y(3)
    ; sta sprite_y(7)

    lda #color_dark_blue
    sta sprite_color(0)
    sta sprite_color(2)
    sta sprite_color(4)
    sta sprite_color(6)

    lda #color_red
    sta sprite_color(1)
    sta sprite_color(3)
    sta sprite_color(5)
    sta sprite_color(7)

    rts
