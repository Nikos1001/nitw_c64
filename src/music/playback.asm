
.include "drum_table.asm"
.include "vibrato_table.asm"

melody_playback_addr_lo = $f7
melody_playback_addr_hi = $f8
drumln_playback_addr_lo = $f9
drumln_playback_addr_hi = $fa

melody_playback_wait .byte 1
drumln_playback_wait .byte 1

music_command .byte 0

drum_wave_table_pos .byte 0
drum_pitch_table_pos .byte 0

melody_note_on_cmd .byte $21
melody_note_off_cmd .byte $20

melody_vibrato_on .byte 0
melody_vibrato_offset .byte 0
melody_vibrato_base_note .byte 0
melody_vibrato_value .byte 0

lyric_loop_var .byte 0

init_music_playback
    lda #08
    sta sid_v3_duty_hi

    lda #$36
    sta sid_v2_ad
    lda #$f9
    sta sid_v2_sr

    rts

drumln_playback
    .block

    dec drumln_playback_wait
    beq read_loop
        jmp drumln_tick

    add_playback_addr .function n
        add_const_to_16bit n, drumln_playback_addr_lo
        .endfunction

    start_drum .function ad, sr, pitch_hi, wave_table_pos, pitch_table_pos
        ; turn off previous drum 
        lda #$00
        sta sid_v3_ctrl

        ; set up next sound
        lda #ad
        sta sid_v3_ad
        lda #sr
        sta sid_v3_sr
        lda #pitch_hi
        sta sid_v3_freq_hi

        ; set up table positions
        lda #wave_table_pos
        sta drum_wave_table_pos
        lda #pitch_table_pos
        sta drum_pitch_table_pos

        .endfunction
    
    read_loop
        ldy #0
        lda (drumln_playback_addr_lo), y

        cmp #%10000001 ; kick
        long_beq kick

        cmp #%10000010 ; snare
        long_beq snare

        cmp #%10000100 ; hi hat
        long_beq hihat

        cmp #%10000101 ; hi hat open
        long_beq hihat_open

        tax

        and #%11000000 ; wait
        cmp #%11000000
        long_beq wait

        ; unknown command!
        add_playback_addr 1 ; incr addr to skip the byte
        inc border_color ; obnoxious border color error 
        jmp read_loop

        kick
            start_drum $00, $c7, 14, kick_wave_table, kick_pitch_table 
            add_playback_addr 1
            jmp read_loop
        
        snare
            start_drum $00, $d6, 14, snare_wave_table, snare_pitch_table 
            add_playback_addr 1
            jmp read_loop
        
        hihat
            start_drum $00, $c5, 30, hihat_wave_table, hihat_pitch_table 
            add_playback_addr 1
            jmp read_loop

        hihat_open
            start_drum $00, $c7, 30, hihat_open_wave_table, hihat_pitch_table 
            add_playback_addr 1
            jmp read_loop

        wait

            ; get time to wait
            txa
            and #%00111111
            beq drumln_tick ; end of song check 
            sta drumln_playback_wait

            ; move playback addr
            add_playback_addr 1
            jmp drumln_tick 

drumln_tick

    ; tick pitch table
    ldx drum_pitch_table_pos 
    lda drum_pitch_table, x 
    cmp #$ff
    beq skip_pitch_table
        sta sid_v3_freq_lo
        inc drum_pitch_table_pos
    skip_pitch_table

    ; tick wave table
    ldx drum_wave_table_pos
    lda drum_wave_table, x 
    cmp #$ff
    beq skip_wave_table
        sta sid_v3_ctrl
        inc drum_wave_table_pos
    skip_wave_table

    .endblock

melody_playback
    .block

    dec melody_playback_wait
    beq read_loop
        jmp melody_tick

    add_playback_addr .function n
        add_const_to_16bit n, melody_playback_addr_lo 
        .endfunction

    read_loop
        ldy #0
        lda (melody_playback_addr_lo), y

        cmp #%10000000 ; note off
        long_beq note_off

        cmp #%10000001 ; vibrato on
        long_beq vibrato_on

        cmp #%10000000 ; vibrato on
        long_beq vibrato_off

        cmp #%10000011 ; change instrument
        long_beq change_instrument

        cmp #%10001000 ; set note
        long_beq set_note

        cmp #%10000100 ; lyrics line 0
        long_beq lyrics0

        tax

        and #%10000000 ; note on
        long_beq note_on

        txa ; wait
        and #%11000000
        cmp #%11000000
        long_beq wait

        ; unknown command!
        add_playback_addr 1 ; incr addr to skip the byte
        dec border_color ; obnoxious border color error 
        jmp read_loop

        note_on
            ; note off
            lda #0
            sta sid_v2_ctrl

            ; set pitch
            lda pitch_lo_byte, x
            sta sid_v2_freq_lo
            lda pitch_hi_byte, x
            sta sid_v2_freq_hi

            ; note on
            lda melody_note_on_cmd
            sta sid_v2_ctrl

            ; save vibrato base note
            stx melody_vibrato_base_note

            add_playback_addr 1
            jmp read_loop

        note_off

            lda melody_note_off_cmd
            sta sid_v2_ctrl

            lda #0
            sta melody_vibrato_on

            add_playback_addr 1
            jmp read_loop
        
        vibrato_on
            lda #1
            sta melody_vibrato_on

            add_playback_addr 1
            jmp read_loop

        vibrato_off
            lda #0
            sta melody_vibrato_on

            add_playback_addr 1
            jmp read_loop
        
        change_instrument
            ; read waveform
            ldy #1
            lda (melody_playback_addr_lo), y
            tax

            ; generate note on and off cmd
            and #%11110000
            sta melody_note_off_cmd
            ora #%00000001
            sta melody_note_on_cmd

            ; read pulse width
            txa
            and #%00001111
            sta sid_v2_duty_hi

            ; read attack/decay
            ldy #2
            lda (melody_playback_addr_lo), y
            sta sid_v2_ad

            ; read sustain/release 
            ldy #3
            lda (melody_playback_addr_lo), y
            sta sid_v2_sr

            add_playback_addr 4
            jmp read_loop
        
        set_note
            ; fetch note
            ldy #1
            lda (melody_playback_addr_lo), y
            tax

            ; set pitch
            lda pitch_lo_byte, x
            sta sid_v2_freq_lo
            lda pitch_hi_byte, x
            sta sid_v2_freq_hi

            ; set vibrato base note
            stx melody_vibrato_base_note

            add_playback_addr 2
            jmp read_loop

        wait
            txa
            and #%00111111
            beq melody_tick ; end of song check

            sta melody_playback_wait

            add_playback_addr 1
            jmp melody_tick
        
        lyrics0
            ldy #1 
            lyric_loop
                lda (melody_playback_addr_lo), y
                sta screen_chars_addr(0, 21), y
                lda #color_white
                sta screen_color_addr(0, 21), y
                iny
                cpy #40
                bne lyric_loop

            add_playback_addr 41
            jmp read_loop 

melody_tick

    lda melody_vibrato_on
    beq skip_vibrato
        ; fetch and increment vibrato offset
        lda melody_vibrato_offset
        adc #1
        and #%00001111
        sta melody_vibrato_offset

        ; fetch vibrato offset
        and #%00000111
        sta temp
        lda melody_vibrato_base_note
        and #%11111000
        ora temp
        tax
        lda vibrato_table, x
        sta melody_vibrato_value

        ; calculate frequency 
        ldx melody_vibrato_base_note
        lda melody_vibrato_offset
        and #%00001000
        beq add_vibrato
            lda pitch_lo_byte, x
            clc
            adc melody_vibrato_value
            tay
            lda pitch_hi_byte, x
            adc #0
            jmp skip_add_vibrato
        add_vibrato
            lda pitch_lo_byte, x
            sec 
            sbc melody_vibrato_value
            tay
            lda pitch_hi_byte, x
            sbc #0
        skip_add_vibrato

        ; set frequency
        sty sid_v2_freq_lo
        sta sid_v2_freq_hi
    skip_vibrato

    rts
    .endblock
