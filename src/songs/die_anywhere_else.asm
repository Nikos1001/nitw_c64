
* = * + 1

die_anywhere_else_song
    .block

    ; pattern
    verse_pattern .function
        ; bar 1
            snote 0, note_C2
            swait 3
            snote 0, note_C2
            swait 2
            snote 2, note_D2
            swait 3

        ; bar 2
            snote 3, note_Eb2
            swait 3
            snote 3, note_Eb2
            swait 2
            snote 2, note_D2
            swait 3

        ; bar 3
            snote 0, note_Ab1
            swait 8
        
        ; bar 4
            snote 3, note_Eb2
            swait 3
            snote 2, note_Bb1
            swait 5

        ; bar 5
            snote 2, note_C2
            swait 3
            snote 2, note_C2
            swait 2
            snote 2, note_D2
            swait 3

        ; bar 6
            snote 3, note_Eb2
            swait 3
            snote 3, note_Eb2
            swait 2
            snote 3, note_D2
            swait 3
        
        ; bar 7
            snote 0, note_Ab1
            swait 8

        ; bar 8
            snote 3, note_Eb2
            swait 3
            snote 2, note_Bb1
            swait 5
        .endfunction
    
    verse .function
        .rept 2
            verse_pattern
        .endrept
        .endfunction
    
    chorus_pattern .function
        ; bar 17-18
            snote 2, note_Bb1
            swait 2
            snote 2, note_Eb2
            swait 2
            snote 3, note_G1
            swait 3
            snote 0, note_C2
            swait 3

            snote 3, note_Eb2
            swait 2
            snote 3, note_G1
            swait 4
        
        ; bar 19
            snote 0, note_Ab1
            swait 2
            snote 3, note_Eb2
            swait 2
            snote 0, note_Ab1
            swait 4

        ; bar 20
            snote 0, note_Ab1
            swait 1
            snote 3, note_G1
            swait 2
            snote 1, note_F1
            swait 2
            snote 0, note_Ab1
            swait 3
        .endfunction
    
    chorus_end_pattern .function
        ; bar 25-26
            snote 2, note_Bb1
            swait 2
            snote 2, note_Eb2
            swait 2
            snote 3, note_G1
            swait 3
            snote 0, note_C2
            swait 3

            snote 3, note_Eb2
            swait 2
            snote 3, note_G1
            swait 4
        
        ; bar 27
            snote 0, note_Ab1
            swait 2
            snote 3, note_Eb2
            swait 2
            snote 0, note_Ab1
            swait 4

        ; bar 28
            snote 0, note_Ab1
            swait 1
            snote 3, note_G1
            swait 2
            snote 1, note_F1
            swait 2
            snote 2, note_D1
            swait 3

        ; bar 29-30
            snote 2, note_Bb1
            swait 16
            
        ; bar 31
            snote 0, note_Ab1
            swait 8
        
        ; bar 32
            snote 2, note_D1
            swait 8
        .endfunction
    
    chorus .function
        chorus_pattern
        chorus_pattern
        chorus_end_pattern
        .endfunction
    
    bridge_pattern_1 .function
        ; bar 65
            snote 0, note_Ab1
            swait 3
            snote 0, note_Ab1
            swait 2
            snote 0, note_Ab1
            swait 3
        
        ; bar 66
            snote 2, note_Bb1
            swait 3
            snote 2, note_Bb1
            swait 2
            snote 2, note_Bb1
            swait 3
        .endfunction
    
    bridge_pattern_2 .function
        ; bar 67
        snote 3, note_Eb2
            swait 3
            snote 3, note_Eb2
            swait 2
            snote 3, note_Eb2
            swait 3

        ; bar 68
            snote 3, note_G2
            swait 3
            snote 3, note_G2
            swait 2
            snote 3, note_G2
            swait 3
        .endfunction

    bridge_pattern_3 .function
        ; bar 67
            snote 0, note_C2
            swait 3
            snote 0, note_C2
            swait 2
            snote 0, note_C2
            swait 3

        ; bar 68
            snote 3, note_G2
            swait 3
            snote 3, note_G2
            swait 2
            snote 3, note_G2
            swait 3
        .endfunction
    
    bridge_spam .function string, note
        .rept 8
            snote string, note
            swait 1
        .endrept
        .endfunction
    
    bridge_end_pattern .function
        .rept 2
            snote 0, note_Ab1
            swait 1
            snote 3, note_G1
            swait 2
            snote 2, note_Eb1
            swait 1
        .endrept
        .endfunction

    bridge .function
        bridge_pattern_1
        bridge_pattern_2
        bridge_pattern_1
        bridge_pattern_3
        bridge_spam 0, note_Ab1
        bridge_spam 2, note_Bb1
        bridge_spam 3, note_Eb2
        bridge_spam 3, note_G1
        bridge_spam 0, note_Ab1
        bridge_spam 1, note_F1
        bridge_spam 2, note_Bb1
        bridge_end_pattern
        .endfunction
    
    ; song layout
    verse
    chorus
    verse
    chorus
    bridge
    chorus

    ; end
    song_end

    .endblock

voice_waveform = $28
voice_attack = $5
voice_decay = $3
voice_sustain = $b
voice_release = $8

die_anywhere_else_melody
    .block
    music_head

    ; instruments
    voice .function
        minstr $28, $36, $f9
        .endfunction
    
    voice_long_release .function
        minstr $28, $36, $fb
        .endfunction
    
    quiet_voice .function
        minstr $28, $36, $8b
        .endfunction
    
    organ .function
        minstr $45, $36, $f9
        .endfunction
    
    ; utils
    tap_note .function note, length
        .cerror length <= mt_sixteenth, "not enough time for note off"
        mnote note
        mwait length - mt_sixteenth

        mnote_off
        mwait mt_sixteenth
        .endfunction
    
    long_note .function note, length
        mnote note
        mwait length
        mnote_off

        .endfunction

    ; patterns
    verse_fall_pattern .function transpose

        quiet_voice 
        mnote note_Eb4 + transpose
        mwait mt_quarter_dot - 3
        mset_note note_E4 + transpose ; glissando 
        mwait 1
        mset_note note_Db4 + transpose
        mwait 1
        mset_note note_B3 + transpose
        mwait 1
        mset_note note_Bb3 + transpose
        mvibrato
        mwait mt_quarter_dot
        mnote_off

        mwait mt_quarter

        .endfunction

    verse_q_pattern .function
        voice
        tap_note note_Eb4, mt_quarter_dot
        tap_note note_Eb4, mt_quarter
        tap_note note_F4, mt_quarter_dot
        tap_note note_G4, mt_quarter_dot
        tap_note note_G4, mt_quarter
        tap_note note_Eb4, mt_quarter_dot

        voice_long_release
        mvibrato 
        long_note note_Eb4, mt_half 
        mwait mt_half

        verse_fall_pattern 0

        .endfunction

    verse_a_pattern .function
        voice
        tap_note note_F4, mt_quarter_dot
        tap_note note_F4, mt_quarter
        tap_note note_G4, mt_quarter_dot
        tap_note note_Ab4, mt_eighth
        tap_note note_G4, mt_quarter
        tap_note note_F4, mt_quarter
        tap_note note_Eb4, mt_quarter_dot

        voice_long_release
        mvibrato 
        long_note note_C5, mt_half 
        mwait mt_half

        verse_fall_pattern 12 

        .endfunction
    
    verse .function lyric1, lyric2, lyric3, lyric4
        mlyrics 0, lyric1
        verse_q_pattern
        mlyrics 0, lyric2
        verse_a_pattern
        mlyrics 0, lyric3
        verse_q_pattern
        mlyrics 0, lyric4
        verse_a_pattern
        .endfunction
    
    chorus_pattern_intro .function
        voice
        tap_note note_D5, mt_quarter
        tap_note note_D5, mt_quarter
        tap_note note_D5, mt_eighth
        tap_note note_D5, mt_quarter
        tap_note note_Eb5, mt_half 
        tap_note note_Bb4, mt_quarter 
        tap_note note_Bb4, mt_eighth 
        tap_note note_Bb4, mt_quarter 
        .endfunction

    chorus_q_pattern .function
        chorus_pattern_intro

        tap_note note_Bb4, mt_eighth 
        voice_long_release
        mvibrato
        long_note note_C5, 2 * mt_whole - mt_eighth - mt_half 
        mwait mt_half

        .endfunction

    chorus_a1_pattern .function
        chorus_pattern_intro

        tap_note note_Bb4, mt_eighth 
        voice_long_release
        mvibrato
        long_note note_Ab4, 2 * mt_whole - mt_eighth - mt_half 
        mwait mt_half

        .endfunction
    
    chorus_a2_pattern .function oh_no
        tap_note note_Ab4, mt_quarter_dot
        tap_note note_G4, mt_quarter_dot
        voice_long_release
        mvibrato
        long_note note_Eb4, mt_quarter + mt_whole - mt_half 
        voice
        mwait mt_half

        tap_note note_Ab4, mt_quarter_dot
        tap_note note_G4, mt_quarter_dot
        voice_long_release
        mvibrato
        long_note note_D4, 2 * mt_quarter + mt_sixteenth 
        voice
        mwait mt_quarter

        mwait mt_sixteenth
        .if oh_no
            mlyrics 0, "oh no"
        .endif
        tap_note note_C4, mt_eighth
        tap_note note_D4, mt_eighth
        tap_note note_C4, mt_eighth

        .endfunction
    
    chorus .function oh_no
        mlyrics 0, "i just wanna die anywhere else"
        chorus_q_pattern
        mlyrics 0, "if only i could die anywhere else"
        chorus_a1_pattern
        mlyrics 0, "so come with me lets die anywhere else"
        chorus_q_pattern
        mlyrics 0, "an-y-where... just not here..."
        chorus_a2_pattern oh_no
        .endfunction
    
    bridge_q_intro_pattern .function lyrics
        mwait mt_eighth
        mlyrics 0, lyrics
        .rept 4
            tap_note note_Bb4, mt_eighth
        .endrept
        tap_note note_Ab4, mt_quarter
        tap_note note_G4, mt_quarter
        tap_note note_Ab4, mt_quarter
        .endfunction
    
    bridge_q1_pattern .function lyrics
        mwait mt_half
        bridge_q_intro_pattern lyrics
        tap_note note_G4, mt_eighth + mt_half
        .endfunction

    bridge_a1_pattern .function
        mwait mt_quarter
        mlyrics 0, "will they know i walked alone"
        .rept 3
            tap_note note_G4, mt_eighth
        .endrept
        tap_note note_F4, mt_quarter
        tap_note note_Eb4, mt_quarter
        tap_note note_F4, mt_quarter
        tap_note note_Eb4, mt_eighth + mt_half 
        .endfunction
    
    bridge_p2_pattern .function
        bridge_q_intro_pattern "around these dusty streets - my"
        mlyrics 0, "tired old home"
        tap_note note_C5, mt_half
        tap_note note_Bb4, mt_quarter_dot
        tap_note note_Eb4, mt_quarter
        tap_note note_Bb4, mt_eighth
        tap_note note_G4, mt_quarter
        tap_note note_F4, mt_quarter
        tap_note note_G4, mt_quarter_dot
        .endfunction
    
    bridge_a2_pattern .function
        mwait mt_quarter
        mlyrics 0, "what was here before, no"
        .rept 2
            tap_note note_F4, mt_eighth
        .endrept
        tap_note note_G4, mt_eighth
        tap_note note_F4, mt_quarter
        tap_note note_Eb4, mt_quarter
        tap_note note_F4, mt_quarter
        .endfunction
    
    bridge_end_pattern .function
        mlyrics 0, "they wont remember that im gone" 
        tap_note note_Ab4, mt_half
        tap_note note_Ab4, mt_quarter
        tap_note note_G4, mt_eighth
        tap_note note_Ab4, mt_quarter_dot
        tap_note note_G4, mt_quarter
        tap_note note_F4, mt_quarter
        tap_note note_Eb4, mt_quarter_dot
        vibrato
        tap_note note_F4, mt_whole

        .rept 2
            tap_note note_Ab4, 11
            tap_note note_G4, 11
            tap_note note_D4, 10
        .endrept
        .endfunction
    
    bridge .function
        organ
        bridge_q1_pattern "and if they ever hear my name"
        bridge_a1_pattern
        bridge_p2_pattern
        bridge_q1_pattern "and will they ever stop to think"
        bridge_a2_pattern
        bridge_end_pattern
        .endfunction

    ; count-in
    .for i in range(8)
        mlyrics 0, format("%d", 8 - i)
        mwait mt_quarter
    .endfor

    ; song layout
    verse "dust on this tired old street", "mark corners where we used to play", "dust trace our tired old feet", "in circles as we pace our time away"
    chorus false
    verse "stuck on this dead end street", "where all the new kids come to play", "stuck - where past and future meet", "watching all our autumns drift away"
    chorus false
    bridge
    chorus true

    music_end

    .endblock

die_anywhere_else_drumln
    .block
    music_head

    ; patterns
    verse_pattern .function 
        .rept 3
            dkick
            dwait mt_quarter

            dhihat
            dwait mt_eighth
            
            dkick
            dwait mt_eighth

            dkick
            dwait mt_quarter

            dhihat
            dwait mt_quarter
        .endrept

        dkick
        dwait mt_quarter

        dhihat
        dwait mt_eighth
        
        dkick
        dwait mt_eighth
 
        dkick
        dwait mt_eighth

        dkick
        dwait mt_eighth

        dhihat
        dwait mt_eighth

        dkick
        dwait mt_eighth

        .endfunction
    
    verse .function
        .rept 4
            verse_pattern
        .endrept
        .endfunction
    
    chorus_pattern .function
        .rept 4
            dkick
            dwait mt_quarter

            dhihat
            dwait mt_eighth

            dkick 
            dwait mt_eighth

            dkick 
            dwait mt_eighth

            dkick 
            dwait mt_eighth

            dhihat 
            dwait mt_eighth

            dkick 
            dwait mt_eighth
        .endrept
        .endfunction
    
    chorus_end_pattern .function
        .rept 4
            dsnare
            dwait mt_whole
        .endrept
        .endfunction

    chorus .function
        .rept 3
            chorus_pattern
        .endrept
        chorus_end_pattern
        .endfunction
    
    bridge .function
        .rept 8
            dhihat_open
            dwait mt_quarter_dot

            dhihat_open
            dwait mt_quarter_dot + mt_quarter
        .endrept

        .rept 7
            dwait mt_half + mt_eighth

            dhihat
            dwait mt_eighth

            dhihat
            dwait mt_eighth

            dhihat
            dwait mt_eighth
        .endrept

        .rept 2
            dsnare 
            dwait 11 

            dsnare 
            dwait 11 

            dsnare 
            dwait 10 
        .endrept

        .endfunction

    ; count-in
    .rept 4
        dkick 
        dwait mt_quarter
    .endrept

    .rept 4
        dsnare 
        dwait mt_quarter
    .endrept

    ; song layout
    verse
    chorus
    verse
    chorus
    bridge
    chorus

    music_end
    .endblock
