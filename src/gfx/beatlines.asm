

beatline_raster_start = raster_first_visible_line + 2 * 8 - 5

target_raster_line .byte 0

frame_begin_irq
    ; setup first beatline raster irq for the frame
    lda scroll_val
    and #%00000111 

    cmp #5
    beq use_hi_badline_irq
        cmp #4
    beq use_lo_badline_irq
        set_irq_vector beatline_irq 
        lda #beatline_raster_start
        jmp finish_frame_begin_irq 

    use_lo_badline_irq
        set_irq_vector lo_badline_beatline_irq 
        lda #beatline_raster_start
        jmp finish_frame_begin_irq 

    use_hi_badline_irq
        set_irq_vector hi_badline_beatline_irq 
        lda #(beatline_raster_start - 1)
        jmp finish_frame_begin_irq 

    finish_frame_begin_irq

    clc
    adc scroll_val
    sta raster_line
    sta target_raster_line

    jmp irq_exit

beatline_irq_start .function t
    lda #color_dark_grey
    sta background_color
    nop_wait t
    lda #color_black
    sta background_color
    .endfunction

beatline_irq
    beatline_irq_start 30
    jmp beatline_irq_end
    
lo_badline_beatline_irq
    beatline_irq_start 15
    jmp beatline_irq_end

hi_badline_beatline_irq
    nop_wait 20
    beatline_irq_start 24
    jmp beatline_irq_end

beatline_irq_end
    lda target_raster_line
    cmp #180
    bcs stop_beatlines
        clc
        adc #16
        sta raster_line
        sta target_raster_line
        jmp irq_exit
    
    stop_beatlines
        lda #(raster_last_visible_line + 1)
        sta raster_line
        set_irq_vector frame_end_irq
        jmp irq_exit
