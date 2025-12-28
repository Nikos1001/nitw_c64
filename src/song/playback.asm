
song_playback_addr_lo = $fd 
song_playback_addr_hi = song_playback_addr_lo + 1

note_buffer_len = note_area_height + 1

; we keep two copies of the note buffer side by side to
; make it easier to look up data before the current playback location 
note_buffer_size = note_buffer_len * 2

string0_note_buffer
    .rept note_buffer_size
        .byte 0
    .endrept
string1_note_buffer
    .rept note_buffer_size
        .byte 0
    .endrept
string2_note_buffer
    .rept note_buffer_size
        .byte 0
    .endrept
string3_note_buffer
    .rept note_buffer_size
        .byte 0
    .endrept

string_note_buffer .sfunction idx, string0_note_buffer + idx * note_buffer_size

note_playback_loc .byte 0
song_playback_wait .byte 1

next_note_command .byte 0
next_note_pitch .byte 0

tick_note_playback
    .block

    add_playback_addr .function n
        lda song_playback_addr_lo
        clc
        adc #n
        sta song_playback_addr_lo
        lda song_playback_addr_hi
        adc #0
        sta song_playback_addr_hi
        .endfunction
    
    ; move to next position in the note playback buffer
    inc note_playback_loc
    lda note_playback_loc
    cmp #note_buffer_len
    bne skip_reset_playback_loc
        lda #0
        sta note_playback_loc
    skip_reset_playback_loc

    ; zero out previous notes
    ldy note_playback_loc
    lda #0
    .for i in range(4)
        sta string_note_buffer(i), y
        sta string_note_buffer(i) + note_buffer_len, y
    .endfor

    ; check playback wait timer
    dec song_playback_wait
    beq read_loop 
        rts
        
    read_loop
        ; read next note command
        ldy #0
        lda (song_playback_addr_lo), y
        beq init_wait 
        sta next_note_command

        ; get note pitch
        and #%00111111
        sta next_note_pitch

        ; get playback buffer offset into Y register
        ldy note_playback_loc

        ; check string idx
        lda next_note_command
        and #%11000000
        cmp #%11000000
        beq string3_note
        cmp #%10000000
        beq string2_note
        cmp #%01000000
        beq string1_note
        
        ; set note in the corresponding buffer
        string0_note
            lda next_note_pitch
            sta string0_note_buffer, y
            sta string0_note_buffer + note_buffer_len, y
            jmp finish_note_set
        string1_note
            lda next_note_pitch
            sta string1_note_buffer, y
            sta string1_note_buffer + note_buffer_len, y
            jmp finish_note_set
        string2_note
            lda next_note_pitch
            sta string2_note_buffer, y
            sta string2_note_buffer + note_buffer_len, y
            jmp finish_note_set
        string3_note
            lda next_note_pitch
            sta string3_note_buffer, y
            sta string3_note_buffer + note_buffer_len, y
            jmp finish_note_set

        finish_note_set

        ; increment playback address
        add_playback_addr 1

        jmp read_loop

    init_wait
        ; read wait time 
        ldy #1
        lda (song_playback_addr_lo), y

        ; wait time of zero indicates the end of the song 
        beq end_of_song

        ; set wait time
        sta song_playback_wait

        ; increment playback addr by 2 bytes
        add_playback_addr 2 

        rts
    
    end_of_song
        rts

    .endblock
