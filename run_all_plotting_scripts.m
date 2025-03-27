figure
filename1 = 'benchmark-output-bqrrp-paper/SapphireRapids/BQRRP_speed_comparisons_block_size_small/BQRRP_speed_comparisons_block_size_num_info_lines_7.txt';
filename2 = 'benchmark-output-bqrrp-paper/Zen4c/BQRRP_speed_comparisons_block_size_small/BQRRP_speed_comparisons_block_size_num_info_lines_7.txt';
bqrrp_speed_comparisons_block_size_cpu_small_data(filename1, filename2, 1000, 1000, 3, 8, 3, 7, 1);

filename1 = 'benchmark-output-bqrrp-paper/SapphireRapids/BQRRP_speed_comparisons_mat_size_rectangular/BQRRP_speed_comparisons_mat_size_num_info_lines_7.txt';
filename2 = 'benchmark-output-bqrrp-paper/Zen4c/BQRRP_speed_comparisons_mat_size_rectangular/BQRRP_speed_comparisons_mat_size_num_info_lines_7.txt';
bqrrp_speed_comparisons_mat_size_rectangle_cpu(filename1, filename2, 8000, 4000, 4, 3, 7, 1);

figure
filename1 = 'benchmark-output-bqrrp-paper/SapphireRapids/HQRRP_runtime_breakdown/HQRRP_runtime_breakdown_num_info_lines_7.txt';
filename2 = 'benchmark-output-bqrrp-paper/Zen4c/HQRRP_runtime_breakdown/HQRRP_runtime_breakdown_num_info_lines_7.txt';
hqrrp_runtime_breakdown(filename1, filename2, 5, 11, 3, 1)

figure
filename1 = 'benchmark-output-bqrrp-paper/SapphireRapids/HQRRP_speed_comparisons_block_size/BQRRP_speed_comparisons_block_size_num_info_lines_7.txt';
filename2 = 'benchmark-output-bqrrp-paper/Zen4c/HQRRP_speed_comparisons_block_size/BQRRP_speed_comparisons_block_size_num_info_lines_7.txt';
hqrrp_speed_comparisons_block_size(filename1, filename2, 32000, 32000, 5, 11, 3, 7, 1);

figure
filename1 = 'benchmark-output-bqrrp-paper/SapphireRapids/HQRRP_plot_remake/BQRRP_speed_comparisons_mat_size_num_info_lines_7.txt';
filename2 = 'benchmark-output-bqrrp-paper/Zen4c/HQRRP_plot_remake/AOCL_BQRRP_speed_comparisons_mat_size_num_info_lines_7.txt';
filename3 = 'benchmark-output-bqrrp-paper/Zen4c/HQRRP_plot_remake/MKL_BQRRP_speed_comparisons_mat_size_num_info_lines_7.txt';
hqrrp_plot_remake_flops(filename1, filename2, filename3, 10, 5, 20, 7, 1);

figure
filename = 'benchmark-output-bqrrp-paper/A100/BQRRP_speed_comparisons_block_size/BQRRP_GPU_speed_comparisons_block_size_num_info_lines_6.txt';
bqrrp_speed_comparisons_block_size_gpu(filename, 2^11, 2^11, 28, 5, 1);

figure
filename1 = 'benchmark-output-bqrrp-paper/SapphireRapids/BQRRP_speed_comparisons_mat_size/BQRRP_speed_comparisons_mat_size_num_info_lines_7.txt';
filename2 = 'benchmark-output-bqrrp-paper/Zen4c/BQRRP_speed_comparisons_mat_size/BQRRP_speed_comparisons_mat_size_num_info_lines_7.txt';
bqrrp_speed_comparisons_mat_size_cpu(filename1, filename2, 8000, 8000, 3, 5, 3, 7, 1);

figure
filename1 = 'benchmark-output-bqrrp-paper/SapphireRapids/BQRRP_speed_comparisons_block_size/BQRRP_speed_comparisons_block_size_num_info_lines_7.txt';
filename2 = 'benchmark-output-bqrrp-paper/Zen4c/BQRRP_speed_comparisons_block_size/BQRRP_speed_comparisons_block_size_num_info_lines_7.txt';
bqrrp_speed_comparisons_block_size_cpu(filename1, filename2, 2^16, 2^16, 64000, 64000, 6, 3, 7, 1);

figure
filename1 = 'benchmark-output-bqrrp-paper/SapphireRapids/BQRRP_pivot_quality/BQRRP_pivot_quality_metric_1_num_info_lines_6.txt';
filename2 = 'benchmark-output-bqrrp-paper/SapphireRapids/BQRRP_pivot_quality/BQRRP_pivot_quality_metric_2_num_info_lines_6.txt';
bqrrp_pivot_quality(filename1, filename2, 16384, 1);

figure
filename1 = 'benchmark-output-bqrrp-paper/A100/BQRRRP_runtime_breakdown/BQRRP_GPU_runtime_breakdown_cholqr__num_info_lines_7.txt';
filename2 = 'benchmark-output-bqrrp-paper/A100/BQRRRP_runtime_breakdown/BQRRP_GPU_runtime_breakdown_qrf__num_info_lines_7.txt';
bqrrp_runtime_breakdown_gpu(filename1, filename2, 1);

figure
filename1 = 'benchmark-output-bqrrp-paper/SapphireRapids/BQRRP_runtime_breakdown/BQRRP_runtime_breakdown_num_info_lines_7.txt';
filename2 = 'benchmark-output-bqrrp-paper/Zen4c/BQRRP_runtime_breakdown/BQRRP_runtime_breakdown_num_info_lines_7.txt';
bqrrp_runtime_breakdown_cpu(filename1, filename2, 6, 3, 1);

figure
filename1 = 'benchmark-output-bqrrp-paper/SapphireRapids/BQRRP_subroutines_speed/BQRRP_subroutines_speed_num_info_lines_10.txt';
filename2 = 'benchmark-output-bqrrp-paper/Zen4c/BQRRP_subroutines_speed/BQRRP_subroutines_speed_num_info_lines_10.txt';
bqrrp_subroutine_performance_apply_q(filename1, filename2, 2^16, 256, 64000, 250, 6, 3, 7, 1);

figure
filename1 = 'benchmark-output-bqrrp-paper/SapphireRapids/BQRRP_subroutines_speed/BQRRP_subroutines_speed_num_info_lines_10.txt';
filename2 = 'benchmark-output-bqrrp-paper/Zen4c/BQRRP_subroutines_speed/BQRRP_subroutines_speed_num_info_lines_10.txt';
bqrrp_subroutine_performance_tall_qr(filename1, filename2, 2^16, 256, 64000, 250, 6, 3, 12, 1);

figure
filename1 = 'benchmark-output-bqrrp-paper/SapphireRapids/BQRRP_subroutines_speed/BQRRP_subroutines_speed_num_info_lines_10.txt';
filename2 = 'benchmark-output-bqrrp-paper/Zen4c/BQRRP_subroutines_speed/BQRRP_subroutines_speed_num_info_lines_10.txt';
bqrrp_subroutine_performance_wide_qrcp(filename1, filename2, 256, 2^16, 250, 64000, 6, 3, 2, 1);

figure
filename1 = 'benchmark-output-bqrrp-paper/SapphireRapids/HQRRP_plot_remake/BQRRP_speed_comparisons_mat_size_num_info_lines_7.txt';
filename2 = 'benchmark-output-bqrrp-paper/Zen4c/HQRRP_plot_remake/MKL_BQRRP_speed_comparisons_mat_size_num_info_lines_7.txt';
hqrrp_plot_remake_ratios(filename1, filename2, 10, 5, 20, 7, 1);
