
wire kernel_monitor_reset;
wire kernel_monitor_clock;
wire kernel_monitor_report;
assign kernel_monitor_reset = ~ap_rst_n;
assign kernel_monitor_clock = ap_clk;
assign kernel_monitor_report = 1'b0;
wire [3:0] axis_block_sigs;
wire [13:0] inst_idle_sigs;
wire [6:0] inst_block_sigs;
wire kernel_block;

assign axis_block_sigs[0] = ~AXIvideo2xfMat_32_9_128_128_1_2_U0.grp_AXIvideo2xfMat_32_9_128_128_1_2_Pipeline_loop_start_hunt_fu_185.p_src_TDATA_blk_n;
assign axis_block_sigs[1] = ~AXIvideo2xfMat_32_9_128_128_1_2_U0.grp_AXIvideo2xfMat_32_9_128_128_1_2_Pipeline_loop_col_zxi2mat_fu_205.p_src_TDATA_blk_n;
assign axis_block_sigs[2] = ~AXIvideo2xfMat_32_9_128_128_1_2_U0.grp_AXIvideo2xfMat_32_9_128_128_1_2_Pipeline_loop_last_hunt_fu_232.p_src_TDATA_blk_n;
assign axis_block_sigs[3] = ~xfMat2AXIvideo_32_9_128_128_1_2_U0.grp_xfMat2AXIvideo_32_9_128_128_1_2_Pipeline_loop_col_mat2axi_fu_86.p_dst_TDATA_blk_n;

assign inst_idle_sigs[0] = Block_entry1_proc_U0.ap_idle;
assign inst_block_sigs[0] = (Block_entry1_proc_U0.ap_done & ~Block_entry1_proc_U0.ap_continue);
assign inst_idle_sigs[1] = AXIvideo2xfMat_32_9_128_128_1_2_U0.ap_idle;
assign inst_block_sigs[1] = (AXIvideo2xfMat_32_9_128_128_1_2_U0.ap_done & ~AXIvideo2xfMat_32_9_128_128_1_2_U0.ap_continue) | ~AXIvideo2xfMat_32_9_128_128_1_2_U0.grp_AXIvideo2xfMat_32_9_128_128_1_2_Pipeline_loop_col_zxi2mat_fu_205.img_buf_0_data103_blk_n | ~AXIvideo2xfMat_32_9_128_128_1_2_U0.img_buf_0_rows_c_blk_n | ~AXIvideo2xfMat_32_9_128_128_1_2_U0.img_buf_0_cols_c_blk_n;
assign inst_idle_sigs[2] = bgr2gray_9_0_128_128_1_2_2_U0.ap_idle;
assign inst_block_sigs[2] = (bgr2gray_9_0_128_128_1_2_2_U0.ap_done & ~bgr2gray_9_0_128_128_1_2_2_U0.ap_continue) | ~bgr2gray_9_0_128_128_1_2_2_U0.p_src_rows_blk_n | ~bgr2gray_9_0_128_128_1_2_2_U0.p_src_cols_blk_n | ~bgr2gray_9_0_128_128_1_2_2_U0.grp_bgr2gray_9_0_128_128_1_2_2_Pipeline_columnloop_fu_64.img_buf_0_data103_blk_n | ~bgr2gray_9_0_128_128_1_2_2_U0.grp_bgr2gray_9_0_128_128_1_2_2_Pipeline_columnloop_fu_64.img_buf_1_data104_blk_n;
assign inst_idle_sigs[3] = Sobel_0_3_0_0_128_128_1_false_2_2_2_U0.ap_idle;
assign inst_block_sigs[3] = (Sobel_0_3_0_0_128_128_1_false_2_2_2_U0.ap_done & ~Sobel_0_3_0_0_128_128_1_false_2_2_2_U0.ap_continue) | ~Sobel_0_3_0_0_128_128_1_false_2_2_2_U0.grp_xFSobelFilter3x3_0_0_128_128_1_0_0_1_2_2_2_1_1_128_false_s_fu_36.grp_xFSobelFilter3x3_Pipeline_Col_Loop_fu_157.img_buf_1_data104_blk_n | ~Sobel_0_3_0_0_128_128_1_false_2_2_2_U0.grp_xFSobelFilter3x3_0_0_128_128_1_0_0_1_2_2_2_1_1_128_false_s_fu_36.grp_xFSobelFilter3x3_Pipeline_Clear_Row_Loop_fu_148.img_buf_1_data104_blk_n | ~Sobel_0_3_0_0_128_128_1_false_2_2_2_U0.grp_xFSobelFilter3x3_0_0_128_128_1_0_0_1_2_2_2_1_1_128_false_s_fu_36.grp_xFSobelFilter3x3_Pipeline_Col_Loop_fu_157.img_buf_1a_data105_blk_n | ~Sobel_0_3_0_0_128_128_1_false_2_2_2_U0.grp_xFSobelFilter3x3_0_0_128_128_1_0_0_1_2_2_2_1_1_128_false_s_fu_36.img_buf_1a_data105_blk_n | ~Sobel_0_3_0_0_128_128_1_false_2_2_2_U0.grp_xFSobelFilter3x3_0_0_128_128_1_0_0_1_2_2_2_1_1_128_false_s_fu_36.grp_xFSobelFilter3x3_Pipeline_Col_Loop_fu_157.img_buf_1b_data106_blk_n | ~Sobel_0_3_0_0_128_128_1_false_2_2_2_U0.grp_xFSobelFilter3x3_0_0_128_128_1_0_0_1_2_2_2_1_1_128_false_s_fu_36.img_buf_1b_data106_blk_n;
assign inst_idle_sigs[4] = addWeighted_0_0_128_128_1_2_2_2_U0.ap_idle;
assign inst_block_sigs[4] = (addWeighted_0_0_128_128_1_2_2_2_U0.ap_done & ~addWeighted_0_0_128_128_1_2_2_2_U0.ap_continue) | ~addWeighted_0_0_128_128_1_2_2_2_U0.grp_AddWeightedKernel_0_0_128_128_1_2_2_2_1_0_0_1_1_128_s_fu_36.grp_AddWeightedKernel_Pipeline_ColLoop_fu_56.img_buf_1a_data105_blk_n | ~addWeighted_0_0_128_128_1_2_2_2_U0.grp_AddWeightedKernel_0_0_128_128_1_2_2_2_1_0_0_1_1_128_s_fu_36.grp_AddWeightedKernel_Pipeline_ColLoop_fu_56.img_buf_1b_data106_blk_n | ~addWeighted_0_0_128_128_1_2_2_2_U0.grp_AddWeightedKernel_0_0_128_128_1_2_2_2_1_0_0_1_1_128_s_fu_36.grp_AddWeightedKernel_Pipeline_ColLoop_fu_56.img_buf_2_data107_blk_n;
assign inst_idle_sigs[5] = gray2bgr_0_9_128_128_1_2_2_U0.ap_idle;
assign inst_block_sigs[5] = (gray2bgr_0_9_128_128_1_2_2_U0.ap_done & ~gray2bgr_0_9_128_128_1_2_2_U0.ap_continue) | ~gray2bgr_0_9_128_128_1_2_2_U0.grp_gray2bgr_0_9_128_128_1_2_2_Pipeline_columnloop_fu_54.img_buf_2_data107_blk_n | ~gray2bgr_0_9_128_128_1_2_2_U0.grp_gray2bgr_0_9_128_128_1_2_2_Pipeline_columnloop_fu_54.img_buf_3_data108_blk_n;
assign inst_idle_sigs[6] = xfMat2AXIvideo_32_9_128_128_1_2_U0.ap_idle;
assign inst_block_sigs[6] = (xfMat2AXIvideo_32_9_128_128_1_2_U0.ap_done & ~xfMat2AXIvideo_32_9_128_128_1_2_U0.ap_continue) | ~xfMat2AXIvideo_32_9_128_128_1_2_U0.grp_xfMat2AXIvideo_32_9_128_128_1_2_Pipeline_loop_col_mat2axi_fu_86.img_buf_3_data108_blk_n;

assign inst_idle_sigs[7] = 1'b0;
assign inst_idle_sigs[8] = AXIvideo2xfMat_32_9_128_128_1_2_U0.ap_idle;
assign inst_idle_sigs[9] = AXIvideo2xfMat_32_9_128_128_1_2_U0.grp_AXIvideo2xfMat_32_9_128_128_1_2_Pipeline_loop_start_hunt_fu_185.ap_idle;
assign inst_idle_sigs[10] = AXIvideo2xfMat_32_9_128_128_1_2_U0.grp_AXIvideo2xfMat_32_9_128_128_1_2_Pipeline_loop_col_zxi2mat_fu_205.ap_idle;
assign inst_idle_sigs[11] = AXIvideo2xfMat_32_9_128_128_1_2_U0.grp_AXIvideo2xfMat_32_9_128_128_1_2_Pipeline_loop_last_hunt_fu_232.ap_idle;
assign inst_idle_sigs[12] = xfMat2AXIvideo_32_9_128_128_1_2_U0.ap_idle;
assign inst_idle_sigs[13] = xfMat2AXIvideo_32_9_128_128_1_2_U0.grp_xfMat2AXIvideo_32_9_128_128_1_2_Pipeline_loop_col_mat2axi_fu_86.ap_idle;

hls_sobel_axi_stream_top_hls_deadlock_idx0_monitor hls_sobel_axi_stream_top_hls_deadlock_idx0_monitor_U (
    .clock(kernel_monitor_clock),
    .reset(kernel_monitor_reset),
    .axis_block_sigs(axis_block_sigs),
    .inst_idle_sigs(inst_idle_sigs),
    .inst_block_sigs(inst_block_sigs),
    .block(kernel_block)
);


always @ (kernel_block or kernel_monitor_reset) begin
    if (kernel_block == 1'b1 && kernel_monitor_reset == 1'b0) begin
        find_kernel_block = 1'b1;
    end
    else begin
        find_kernel_block = 1'b0;
    end
end
