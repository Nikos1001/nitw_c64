
import math

note_names = ['C', 'Db', 'D', 'Eb', 'E', 'F', 'Gb', 'G', 'Ab', 'A', 'Bb', 'B']

n_notes = 12 * 8 - 1
vibrato_table_step = 8
vibrato_size = 0.03
vibrato_len = 16

with open('src/sys/notes.asm', 'w') as f:
    for i in range(n_notes):
        f.write('note_' + note_names[i % 12] + str(i // 12) + ' = ' + str(i + 1) + '\n')

def calc_freq_val(note):
    freq = 440.0 * 2.0 ** ((note - 57.0) / 12.0)
    freq_val = round(freq / 1022727.0 * 0x1000000)
    return freq_val

def calc_freq_bytes(note):
    freq_val = calc_freq_val(note)
    return (freq_val % 256, freq_val // 256)

with open('src/sys/pitches.asm', 'w') as f:
    f.write('pitch_lo_byte\n')
    f.write('\t.byte 0 ; null note\n')
    for i in range(n_notes):
        freq_lo, freq_hi = calc_freq_bytes(i)
        f.write('\t.byte ' + str(freq_lo) + '\n')

    f.write('pitch_hi_byte\n')
    f.write('\t.byte 0 ; null note\n')
    for i in range(n_notes):
        freq_lo, freq_hi = calc_freq_bytes(i) 
        f.write('\t.byte ' + str(freq_hi) + '\n')

with open('src/music/vibrato_table.asm', 'w') as f:
    f.write('vibrato_table\n')
    for i in range(0, n_notes, vibrato_table_step):
        base_freq_val = calc_freq_val(i)
        for t in range(vibrato_len // 2):
            note = i + vibrato_size * math.sin(t * 2 * math.pi / vibrato_len)
            vibrato_freq_val = calc_freq_val(note)
            offset = vibrato_freq_val - base_freq_val
            f.write('\t.byte ' + str(offset) + '\n')