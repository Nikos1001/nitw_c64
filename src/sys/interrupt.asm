
interrupt_flag = $d019
interrupt_enabled = $d01a
cia_irc = $dc0d

raster_line = $d012
raster_irq_lo = $0314
raster_irq_hi = $0315
raster_first_visible_line = 51
raster_last_visible_line = 250

set_irq_vector .function addr
    lda #<addr
    sta raster_irq_lo
    lda #>addr
    sta raster_irq_hi
    .endfunction

irq_exit
    lda interrupt_flag
    sta interrupt_flag

    pla
    tay
    pla
    tax
    pla

    rti

init_irq

    sei 
        ; disable cia interrupts
        lda #$7f
        sta cia_irc

        ; setup raster irq vector
        set_irq_vector irq_exit 

        ; set desired raster line
        lda #(raster_last_visible_line + 1)
        sta raster_line
        lda vic_ctrl_1 ; set raster line msb
        and #%01111111
        sta vic_ctrl_1 

        ; enable raster interrupt only
        lda #%00000001 
        sta interrupt_enabled
    cli   

    rts