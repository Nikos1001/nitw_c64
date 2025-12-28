
; a note in the string notes
snote .function string, pitch
    .byte (string << 6) | pitch
    .endfunction

; wait in the string notes
; time is measured in eighth notes
swait .function t
    .byte 0
    .byte t
    .endfunction

song_end .function
    swait 0
    .endfunction