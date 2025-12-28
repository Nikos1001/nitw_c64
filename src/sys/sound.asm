
sid_v1_freq_lo = $d400
sid_v1_freq_hi = $d401
sid_v1_duty_lo = $d402
sid_v1_duty_hi = $d403
sid_v1_ctrl = $d404
sid_v1_ad = $d405
sid_v1_sr = $d406

sid_v2_freq_lo = $d407
sid_v2_freq_hi = $d408
sid_v2_duty_lo = $d409
sid_v2_duty_hi = $d40a
sid_v2_ctrl = $d40b
sid_v2_ad = $d40c
sid_v2_sr = $d40d

sid_v3_freq_lo = $d40e
sid_v3_freq_hi = $d40f
sid_v3_duty_lo = $d410
sid_v3_duty_hi = $d411
sid_v3_ctrl = $d412
sid_v3_ad = $d413
sid_v3_sr = $d414

sid_filter_freq_lo = $d415
sid_filter_freq_hi = $d416
sid_filter_ctrl = $d417

sid_ctrl = $d418

init_sound

    ; set volume to max
    lda #$0f
    sta sid_ctrl

    rts