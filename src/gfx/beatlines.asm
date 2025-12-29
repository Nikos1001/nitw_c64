
target_raster_line .byte 0
animation_timer .byte 0

bea_min_x = sprite_min_x + 4 * 8
bea_min_y = sprite_min_y + 4 * 8
bea_animation_xs
    .byte bea_min_x + 1
    .byte bea_min_x
    .byte bea_min_x
    .byte bea_min_x
    .byte bea_min_x + 1
    .byte bea_min_x + 2
    .byte bea_min_x + 4
    .byte bea_min_x + 6
    .byte bea_min_x + 7
    .byte bea_min_x + 8
    .byte bea_min_x + 8
    .byte bea_min_x + 8
    .byte bea_min_x + 7
    .byte bea_min_x + 6
    .byte bea_min_x + 4
    .byte bea_min_x + 2
bea_animation_ys
    .byte bea_min_y + 4
    .byte bea_min_y + 4
    .byte bea_min_y + 4
    .byte bea_min_y + 4
    .byte bea_min_y + 4
    .byte bea_min_y + 3
    .byte bea_min_y + 2
    .byte bea_min_y + 1
    .byte bea_min_y + 0
    .byte bea_min_y + 0
    .byte bea_min_y + 0
    .byte bea_min_y + 0
    .byte bea_min_y + 0
    .byte bea_min_y + 1
    .byte bea_min_y + 2
    .byte bea_min_y + 3

angus_min_x = sprite_min_x + 28 * 8 + 1
angus_min_y = sprite_min_y + 4 * 8
angus_animation_ys
    .byte angus_min_y + 0
    .byte angus_min_y + 0
    .byte angus_min_y + 0
    .byte angus_min_y + 1
    .byte angus_min_y + 2
    .byte angus_min_y + 4
    .byte angus_min_y + 5
    .byte angus_min_y + 6
    .byte angus_min_y + 7
    .byte angus_min_y + 7
    .byte angus_min_y + 7
    .byte angus_min_y + 6
    .byte angus_min_y + 5
    .byte angus_min_y + 4
    .byte angus_min_y + 2
    .byte angus_min_y + 1

mae_min_x = sprite_min_x + 4 * 8
mae_min_y = sprite_min_y + 10 * 8 + 2
mae_animation_xs
    .byte mae_min_x 
    .byte mae_min_x 
    .byte mae_min_x + 1
    .byte mae_min_x + 3
    .byte mae_min_x + 5
    .byte mae_min_x + 7
    .byte mae_min_x + 8
    .byte mae_min_x + 8
    .byte mae_min_x + 8
    .byte mae_min_x + 8
    .byte mae_min_x + 7
    .byte mae_min_x + 5
    .byte mae_min_x + 3
    .byte mae_min_x + 1
    .byte mae_min_x 
    .byte mae_min_x 
mae_animation_ys
    .byte mae_min_y + 2
    .byte mae_min_y + 1
    .byte mae_min_y + 2
    .byte mae_min_y + 3
    .byte mae_min_y + 4
    .byte mae_min_y + 3
    .byte mae_min_y + 3
    .byte mae_min_y + 2
    .byte mae_min_y + 2
    .byte mae_min_y + 1
    .byte mae_min_y + 2
    .byte mae_min_y + 3
    .byte mae_min_y + 4
    .byte mae_min_y + 4
    .byte mae_min_y + 3
    .byte mae_min_y + 3

gregg_min_x = sprite_min_x + 28 * 8
gregg_min_y = sprite_min_y + 10 * 8 + 3
gregg_animation_xs
    .byte gregg_min_x
    .byte gregg_min_x
    .byte gregg_min_x + 1
    .byte gregg_min_x + 3 - 256
    .byte gregg_min_x + 5 - 256
    .byte gregg_min_x + 6 - 256
    .byte gregg_min_x + 7 - 256
    .byte gregg_min_x + 7 - 256
    .byte gregg_min_x + 7 - 256
    .byte gregg_min_x + 7 - 256
    .byte gregg_min_x + 6 - 256
    .byte gregg_min_x + 5 - 256
    .byte gregg_min_x + 3 - 256
    .byte gregg_min_x + 1
    .byte gregg_min_x
    .byte gregg_min_x
gregg_animation_x_msbs
    .byte %00000000
    .byte %00000000
    .byte %00000000
    .byte %00111000
    .byte %00111000
    .byte %00111000
    .byte %00111000
    .byte %00111000
    .byte %00111000
    .byte %00111000
    .byte %00111000
    .byte %00111000
    .byte %00111000
    .byte %00000000
    .byte %00000000
    .byte %00000000
gregg_animation_ys
    .byte gregg_min_y + 3
    .byte gregg_min_y + 3
    .byte gregg_min_y + 2
    .byte gregg_min_y + 1
    .byte gregg_min_y + 1
    .byte gregg_min_y + 2
    .byte gregg_min_y + 3
    .byte gregg_min_y + 3
    .byte gregg_min_y + 3
    .byte gregg_min_y + 3
    .byte gregg_min_y + 2
    .byte gregg_min_y + 1
    .byte gregg_min_y + 1
    .byte gregg_min_y + 2
    .byte gregg_min_y + 3
    .byte gregg_min_y + 3

setup_new_frame
    ; calculate scroll offset
    lda scroll_val
    sec
    sbc #4
    and #%00001111

    ; reset beatline sprites to top of note area
    clc
    adc #(sprite_min_y + note_area_min_y * 8)
    sta sprite_y(6)
    sta sprite_y(7)

    ; set first interrupt to shift the beatline sprites
    lda #(raster_first_visible_line + note_area_min_y * 8 + 16)
    sta raster_line
    sta target_raster_line
    set_irq_vector shift_beatline_sprites_irq

    ; advance animal animation
    inc animation_timer

    ; reset character sprites to top animals
    lda #top_sprite_y
    .for i in range(3)
        stx sprite_x(i)
        sta sprite_y(i)
    .endfor

    ; reset bea
    lda animation_timer
    and #%00001111
    tax
    lda bea_animation_xs, x
    ldy bea_animation_ys, x
    .for i in range(3)
        sta sprite_x(i)
        sty sprite_y(i)
    .endfor

    lda #bea_face
    sta sprite_data_ptr(0)
    lda #bea_pupil
    sta sprite_data_ptr(1)
    lda #bea_details
    sta sprite_data_ptr(2)

    lda #color_light_blue
    sta sprite_color(0)
    lda #color_red
    sta sprite_color(1)
    lda #color_black
    sta sprite_color(2)

    ; reset angus
    ldx scroll_val
    ldy angus_animation_ys, x
    lda #angus_min_x
    .for i in range(3, 6)
        sta sprite_x(i)
        sty sprite_y(i)
    .endfor

    lda #0
    sta sprite_x_msbs

    lda #angus_face
    sta sprite_data_ptr(3)
    lda #angus_details
    sta sprite_data_ptr(4)
    lda #angus_eyes
    sta sprite_data_ptr(5)

    lda #color_brown
    sta sprite_color(3)
    lda #color_black
    sta sprite_color(4)
    lda #color_white
    sta sprite_color(5)

    rts

shift_beatline_sprites_irq
    lda sprite_y(6)
    clc
    adc #32

    cmp #(raster_first_visible_line + note_area_max_y * 8 + 8)
    blt skip_setup_end_frame
        jmp setup_end_frame
    skip_setup_end_frame
        ; move beatline sprites
        sta sprite_y(6)
        sta sprite_y(7)

        ; setup next beatline irq
        lda target_raster_line
        clc
        adc #32
        sta raster_line
        sta target_raster_line

        cmp #(raster_first_visible_line + note_area_min_y * 8 + 80)
        beq set_change_animals_irq
            jmp irq_exit 

        set_change_animals_irq
            lda #(raster_first_visible_line + 10 * 8)
            sta raster_line

            set_irq_vector change_animals_irq

            jmp irq_exit

    setup_end_frame

        ; setup end frame irq
        lda #(raster_last_visible_line + 1)
        sta raster_line
        set_irq_vector frame_end_irq
        jmp irq_exit

change_animals_irq

    ; setup mae
    lda animation_timer 
    and #%00011110
    clc
    ror
    tax
    ldy mae_animation_ys, x
    lda mae_animation_xs, x
    .for i in range(3)
        sta sprite_x(i)
        sty sprite_y(i)
    .endfor   

    lda #mae_face
    sta sprite_data_ptr(0)
    lda #mae_pupils
    sta sprite_data_ptr(1)
    lda #mae_bg
    sta sprite_data_ptr(2)
    
    lda #color_dark_blue
    sta sprite_color(0)
    lda #color_red
    sta sprite_color(1)
    lda #color_yellow
    sta sprite_color(2)

    ; setup gregg
    lda animation_timer 
    and #%00011110
    clc
    ror
    tax
    ldy gregg_animation_ys, x
    lda gregg_animation_xs, x
    .for i in range(3, 6)
        sta sprite_x(i)
        sty sprite_y(i)
    .endfor

    lda gregg_animation_x_msbs, x 
    sta sprite_x_msbs

    lda #gregg_face
    sta sprite_data_ptr(3)
    lda #gregg_teeth
    sta sprite_data_ptr(4)
    lda #gregg_nose_eye
    sta sprite_data_ptr(5)

    lda #color_orange
    sta sprite_color(3)
    lda #color_white
    sta sprite_color(4)
    lda #color_black
    sta sprite_color(5)

    ; setup next beatline irq
    lda #(raster_first_visible_line + note_area_min_y * 8 + 80) 
    sta raster_line
    set_irq_vector shift_beatline_sprites_irq

    jmp irq_exit
