
init_gfx
    .block

    ; copy first quarter of default charset to custom charset memory
    ; this covers everything we need for lyrics
    sei
        lda 1
        and #%11111011
        sta 1

        ldx #0
        char_copy_loop
            lda $d000, x
            sta $2000, x
            lda $d100, x
            sta $2100, x

            dex
            bne char_copy_loop

        lda 1
        ora #%00000100
        sta 1
    cli

    ; set character set pointer to $2000
    lda #$18
    sta video_memory_addrs

    rts
    .endblock