
drum_wave_table

    .byte $ff

    kick_wave_table = * - drum_wave_table
    .byte $81
    .byte $81
    .byte $80
    .byte $10
    .byte $00
    .byte $ff

    snare_wave_table = * - drum_wave_table 
    .byte $81
    .byte $80
    .byte $40
    .byte $80
    .byte $ff

    hihat_wave_table = * - drum_wave_table
    .byte $81
    .byte $80
    .byte $80
    .byte $80
    .byte $00
    .byte $ff

    hihat_open_wave_table = * - drum_wave_table
    .byte $81
    .byte $80
    .byte $80
    .byte $80
    .byte $80
    .byte $ff

drum_pitch_table

    .byte $ff

    kick_pitch_table = * - drum_pitch_table
    .byte $c0
    .byte $a8
    .byte $a0
    .byte $98
    .byte $94
    .byte $92
    .byte $91
    .byte $90
    .byte $ff

    snare_pitch_table = * - drum_pitch_table
    .byte $df
    .byte $ae
    .byte $df
    .byte $ff

    hihat_pitch_table = * - drum_pitch_table
    .byte $df
    .byte $ff
