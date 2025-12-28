
; MELODY CHANNEL COMMAND FORMAT
; 0nnnnnnn => note on pitch n
; 10000000 => note off
; 10000001 => vibrato on
; 10000010 => vibrato off
; 10000011 => change instrument
    ; npstwwww => waveform/duty cycle 
    ; aaaadddd => attack/decay
    ; ssssrrrr => sustain/release
; 100001yy => lyrics on line y
    ; followed by 40 PETSCII characters to be displayed
; 10001000 => set note pitch
    ; 0nnnnnnn => new note
; 11tttttt => wait t (t = 0 => end song)

; DRUMLINE CHANNEL COMMAND FORMAT
; 0xxxxxxx
; 10000000
; 10000001 => kick 
; 10000010 => snare
; 10000011
; 10000100 => hi hat
; 10000101 => hi hat open
; 11tttttt => wait t

; MELODY CHANNEL FUNCTIONS
mnote .function note
    .cerror note > 127, "note value too high"
    .byte note
    .endfunction

mnote_off .function
    .byte %10000000
    .endfunction

mvibrato .function
    .byte %10000001
    .endfunction

mvibrato_off .function
    .byte %10000010
    .endfunction

minstr .function waveform, ad, sr
    .byte %10000011
    .byte waveform
    .byte ad
    .byte sr
    .endfunction

mwait .function t
    .rept t / 63
        .byte %11111111
    .endrept
    .if (t % 63) > 0
        .byte %11000000 | (t % 63)
    .endif
    .endfunction

mlyrics .function y, txt
    .byte %10000100 | y
    .enc "screen"
    .cerror len(txt) > screen_w, "lyrics line cannot be longer than 40 chars"
    .rept (screen_w - len(txt)) / 2
        .text " "
    .endrept
    .text txt
    .rept screen_w - len(txt) - (screen_w - len(txt)) / 2
        .text " "
    .endrept
    .endfunction

mset_note .function note
    .byte %10001000
    .byte note
    .endfunction

; DRUMLINE CHANNEL FUNCTIONS
dkick .function
    .byte %10000001
    .endfunction

dsnare .function
    .byte %10000010
    .endfunction

dhihat .function
    .byte %10000100
    .endfunction

dhihat_open .function
    .byte %10000101
    .endfunction

dwait .function t
    mwait t
    .endfunction

; UTILS
music_head .function
    mwait 8 ; align playback time with beatlines
    .endfunction

music_end .function
    .byte %11000000
    .endfunction

mt_sixteenth = 4
mt_sixteenth_dot = 6
mt_eighth = 8
mt_eighth_dot = 12
mt_quarter = 16
mt_quarter_dot = 24
mt_half = 32
mt_half_dot = 48
mt_whole = 64
