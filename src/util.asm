
nop_wait .function n
    .rept n
        nop
    .endrept
    .endfunction

temp_indr_lo = $fb
temp_indr_hi = temp_indr_lo + 1
temp .byte 0

set_tmp_indr_addr .function addr
    lda #<addr
    sta temp_indr_lo
    lda #>addr
    sta temp_indr_hi 
    .endfunction

long_beq .function addr
    .block
        bne skip
            jmp addr
        skip
    .endblock
    .endfunction

add_const_to_16bit .function n, addr
    lda addr
    clc
    adc #<n
    sta addr + 0
    lda addr + 1
    adc #>n
    sta addr + 1
    .endfunction

