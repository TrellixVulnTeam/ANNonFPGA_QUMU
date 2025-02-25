onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /fcl_fsmd_tb/clk_tb
add wave -noupdate /fcl_fsmd_tb/rst_tb
add wave -noupdate /fcl_fsmd_tb/start_tb
add wave -noupdate /fcl_fsmd_tb/x_tb
add wave -noupdate /fcl_fsmd_tb/w_tb
add wave -noupdate /fcl_fsmd_tb/b_tb
add wave -noupdate /fcl_fsmd_tb/y_tb
add wave -noupdate /fcl_fsmd_tb/stop
add wave -noupdate /fcl_fsmd_tb/x_temp
add wave -noupdate /fcl_fsmd_tb/w_temp
add wave -noupdate /fcl_fsmd_tb/x_verif
add wave -noupdate /fcl_fsmd_tb/w_verif
add wave -noupdate /fcl_fsmd_tb/b_verif
add wave -noupdate /fcl_fsmd_tb/x_prev_tb
add wave -noupdate /fcl_fsmd_tb/w_prev_tb
add wave -noupdate /fcl_fsmd_tb/b_prev_tb
add wave -noupdate /fcl_fsmd_tb/y_exp
add wave -noupdate /fcl_fsmd_tb/DUV/x
add wave -noupdate /fcl_fsmd_tb/DUV/w
add wave -noupdate /fcl_fsmd_tb/DUV/b
add wave -noupdate /fcl_fsmd_tb/DUV/state_reg
add wave -noupdate /fcl_fsmd_tb/DUV/state_next
add wave -noupdate /fcl_fsmd_tb/DUV/sample_cnt_reg
add wave -noupdate /fcl_fsmd_tb/DUV/sample_cnt_next
add wave -noupdate /fcl_fsmd_tb/DUV/dec_sample_cnt
add wave -noupdate /fcl_fsmd_tb/DUV/sample_cnt_is_zero
add wave -noupdate /fcl_fsmd_tb/DUV/x_reg
add wave -noupdate /fcl_fsmd_tb/DUV/x_next
add wave -noupdate /fcl_fsmd_tb/DUV/w_reg
add wave -noupdate /fcl_fsmd_tb/DUV/w_next
add wave -noupdate /fcl_fsmd_tb/DUV/b_reg
add wave -noupdate /fcl_fsmd_tb/DUV/b_next
add wave -noupdate /fcl_fsmd_tb/DUV/x_ppl
add wave -noupdate /fcl_fsmd_tb/DUV/w_ppl
add wave -noupdate /fcl_fsmd_tb/DUV/b_ppl
add wave -noupdate /fcl_fsmd_tb/DUV/y_out
add wave -noupdate /fcl_fsmd_tb/DUV/GEN_LAYER(0)/FCUNIT/x
add wave -noupdate /fcl_fsmd_tb/DUV/GEN_LAYER(0)/FCUNIT/w
add wave -noupdate /fcl_fsmd_tb/DUV/GEN_LAYER(0)/FCUNIT/b
add wave -noupdate /fcl_fsmd_tb/DUV/GEN_LAYER(0)/FCUNIT/y
add wave -noupdate /fcl_fsmd_tb/DUV/GEN_LAYER(0)/FCUNIT/x_reg
add wave -noupdate /fcl_fsmd_tb/DUV/GEN_LAYER(0)/FCUNIT/x_next
add wave -noupdate /fcl_fsmd_tb/DUV/GEN_LAYER(0)/FCUNIT/w_reg
add wave -noupdate /fcl_fsmd_tb/DUV/GEN_LAYER(0)/FCUNIT/w_next
add wave -noupdate /fcl_fsmd_tb/DUV/GEN_LAYER(0)/FCUNIT/b_reg
add wave -noupdate /fcl_fsmd_tb/DUV/GEN_LAYER(0)/FCUNIT/b_next
add wave -noupdate /fcl_fsmd_tb/DUV/GEN_LAYER(0)/FCUNIT/y_reg
add wave -noupdate /fcl_fsmd_tb/DUV/GEN_LAYER(0)/FCUNIT/y_next
add wave -noupdate /fcl_fsmd_tb/DUV/GEN_LAYER(0)/FCUNIT/add_reg
add wave -noupdate /fcl_fsmd_tb/DUV/GEN_LAYER(0)/FCUNIT/add_next
add wave -noupdate /fcl_fsmd_tb/DUV/GEN_LAYER(1)/FCUNIT/x
add wave -noupdate /fcl_fsmd_tb/DUV/GEN_LAYER(1)/FCUNIT/w
add wave -noupdate /fcl_fsmd_tb/DUV/GEN_LAYER(1)/FCUNIT/b
add wave -noupdate /fcl_fsmd_tb/DUV/GEN_LAYER(1)/FCUNIT/y
add wave -noupdate /fcl_fsmd_tb/DUV/GEN_LAYER(1)/FCUNIT/x_reg
add wave -noupdate /fcl_fsmd_tb/DUV/GEN_LAYER(1)/FCUNIT/x_next
add wave -noupdate /fcl_fsmd_tb/DUV/GEN_LAYER(1)/FCUNIT/w_reg
add wave -noupdate /fcl_fsmd_tb/DUV/GEN_LAYER(1)/FCUNIT/w_next
add wave -noupdate /fcl_fsmd_tb/DUV/GEN_LAYER(1)/FCUNIT/b_reg
add wave -noupdate /fcl_fsmd_tb/DUV/GEN_LAYER(1)/FCUNIT/b_next
add wave -noupdate /fcl_fsmd_tb/DUV/GEN_LAYER(1)/FCUNIT/y_reg
add wave -noupdate /fcl_fsmd_tb/DUV/GEN_LAYER(1)/FCUNIT/y_next
add wave -noupdate /fcl_fsmd_tb/DUV/GEN_LAYER(1)/FCUNIT/add_reg
add wave -noupdate /fcl_fsmd_tb/DUV/GEN_LAYER(1)/FCUNIT/add_next
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {28 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 449
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {528 ns} {1336 ns}
