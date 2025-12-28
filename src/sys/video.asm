
video_memory_addrs = $d018

screen_w = 40
screen_h = 25
screen_chars = $0400
screen_color = $d800
screen_offset .sfunction x, y, x + screen_w * y
screen_chars_addr .sfunction x, y, screen_chars + screen_offset(x, y)
screen_color_addr .sfunction x, y, screen_color + screen_offset(x, y)

sprite_data_ptrs = screen_chars + $3f8
sprite_data_ptr .sfunction idx, sprite_data_ptrs + idx

sprite_coords = $d000
sprite_x_msbs = $d010
sprite_x .sfunction idx, sprite_coords + 2 * idx
sprite_y .sfunction idx, sprite_coords + 2 * idx + 1

sprite_enable = $d015
sprite_x_expansions = $d01d
sprite_y_expansions = $d017

sprite_colors = $d027
sprite_color .sfunction idx, sprite_colors + idx

sprite_min_x = 30
sprite_min_y = 50

border_color = $d020
background_color = $d021



vic_ctrl_1 = $d011

