
cia_a_pr = $dc00
cia_b_pr = $dc01
cia_a_ddr = $dc02
cia_b_ddr = $dc03

init_keyboard

    sei 
        ; set all port A bits to output
        lda #%11111111  
        sta cia_a_ddr

        ; set all port B bits to input 
        lda #%00000000 
        sta cia_b_ddr
    cli

    rts