

; BASIC PROGRAM
* = $0801
    .word (+), 2005 ; pointer, line number
    .null $9e, format("%4d", start) ; BASIC sys command to run
+
    .word 0 ; basic line end

.include "gfx/sprite.asm"

.include "util.asm"
.include "sys/interrupt.asm"
.include "sys/video.asm"
.include "sys/colors.asm"
.include "sys/keyboard.asm"
.include "sys/sound.asm"
.include "sys/pitches.asm"
.include "sys/notes.asm"

; MAIN CODE
start

    ; initialize irq
    jsr init_irq 

    ; init sound
    jsr init_sound
    jsr init_music_playback

    ; set voice 1 to a bass sound
    lda #$29
    sta sid_v1_ad
    lda #$00
    sta sid_v1_sr
    lda #$00
    sta sid_v1_duty_hi
    lda #$01
    sta sid_v1_duty_hi

    ; set playback vector to "die anywhere else"
    lda #<die_anywhere_else_song
    sta song_playback_addr_lo
    lda #>die_anywhere_else_song
    sta song_playback_addr_hi

    lda #<die_anywhere_else_drumln
    sta drumln_playback_addr_lo 
    lda #>die_anywhere_else_drumln
    sta drumln_playback_addr_hi 

    lda #<die_anywhere_else_melody
    sta melody_playback_addr_lo 
    lda #>die_anywhere_else_melody
    sta melody_playback_addr_hi 

    ; setup keyboard
    jsr init_keyboard

    ; init gfx
    jsr init_gfx
    jsr setup_screen_layout

    ; setup first raster interrupt
    set_irq_vector frame_end_irq
    lda #(raster_last_visible_line + 1)
    sta raster_line

    jmp *

scroll_val .byte 12
scroll_val8 .byte 0

frame_end_irq

    jsr drumln_playback 

    jsr read_keyboard

    ; increment scroll val
    .block
        inc scroll_val
        lda scroll_val

        cmp #16
        bne skip_reset_scroll
            lda #0
            sta scroll_val
        skip_reset_scroll

        and #%00000111
        sta scroll_val8

        bne skip_update_notes
            jsr update_notes
        skip_update_notes
    .endblock

    jsr animate_note_chars

    ; setup frame begin irq for next frame
    ; this stabilizes the raster timing for rendering the beatlines
    lda #0
    sta raster_line
    set_irq_vector frame_begin_irq

    jmp irq_exit

prev_key0 .byte 0
prev_key1 .byte 0
prev_key2 .byte 0
prev_key3 .byte 0
curr_key0 .byte 0
curr_key1 .byte 0
curr_key2 .byte 0
curr_key3 .byte 0

read_keyboard
    .block

    ldx note_playback_loc

    .bfor i in range(4)
        ; check key
        lda #([%11111101, %11111011, %11101111, %11011111][i])
        sta cia_a_pr
        lda cia_b_pr
        and #%00000100
        sta curr_key0 + i
        eor prev_key0 + i
        and prev_key0 + i

        beq skip_key_pressed
            ldy string_note_buffer(i) + 1, x
            clc

            lda #56
            sta string0_anim_frame + i

            beq skip_key_pressed

            lda pitch_lo_byte, y            
            sta sid_v1_freq_lo
            lda pitch_hi_byte, y
            sta sid_v1_freq_hi
            lda #$40
            sta sid_v1_ctrl
            lda #$41
            sta sid_v1_ctrl

        skip_key_pressed

        ; update prev key state
        lda curr_key0 + i
        sta prev_key0 + i
    .endfor

    rts
    .endblock

update_notes
    jsr tick_note_playback

    ; shift note characters down
    set_tmp_indr_addr screen_chars_addr(string0_x, note_area_max_y - 1)
    ldx #0
    note_shift_loop

        .for i in range(4)
            ldy #(i * string_spacing)
            lda (temp_indr_lo), y
            ldy #(screen_w + i * string_spacing)
            sta (temp_indr_lo), y
        .endfor 

        lda temp_indr_lo
        sec
        sbc #screen_w
        sta temp_indr_lo
        lda temp_indr_hi 
        sbc #0
        sta temp_indr_hi 

        inx
        cpx #(note_area_height - 1)
        bne note_shift_loop
    
    ; add new note characters to top of note area
    .block
        ldy note_playback_loc
        .bfor i in range(4)

            lda string_note_buffer(i), y
            beq no_new_note
                .block

                lda screen_chars_addr(string_x(i), note_area_min_y + 1)
                cmp #char_string(i)
                beq no_note_below
                cmp #char_note_top(i)
                beq no_note_below
                    lda #char_note_mid(i)
                    jmp end_note_checks

                no_note_below
                    lda #char_note_btm(i) 
                    jmp end_note_checks

                .endblock

            no_new_note
                .block

                lda screen_chars_addr(string_x(i), note_area_min_y + 1)
                cmp #char_string(i)
                beq no_note_below
                cmp #char_note_top(i)
                beq no_note_below

                    lda #char_note_top(i)
                    jmp end_note_checks
                
                no_note_below
                    lda #char_string(i)
                    jmp end_note_checks

                .endblock
            end_note_checks

            sta screen_chars_addr(string_x(i), note_area_min_y)
        .endfor
    .endblock

    rts

.include "gfx/gfx.asm"
.include "gfx/layout.asm"
.include "gfx/beatlines.asm"
.include "gfx/charset_anim.asm"

.include "song/song.asm"
.include "song/playback.asm"

.include "music/music.asm"
.include "music/playback.asm"

.include "gfx/charset.asm"

.include "songs/die_anywhere_else.asm"