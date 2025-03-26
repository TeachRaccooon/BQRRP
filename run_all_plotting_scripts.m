
% GPU PLOTS
%{
figure
filename = 'benchmark-output-bqrrp-paper/A100/BQRRP_speed_comparisons_block_size/BQRRP_GPU_speed_comparisons_block_size_num_info_lines_6.txt';
bqrrp_performance_varying_block_size_gpu(filename, 2^11, 2^11, 28, 5, 1);

figure
filename1 = 'benchmark-output-bqrrp-paper/A100/BQRRRP_runtime_breakdown/BQRRP_GPU_runtime_breakdown_cholqr__num_info_lines_7.txt';
filename2 = 'benchmark-output-bqrrp-paper/A100/BQRRRP_runtime_breakdown/BQRRP_GPU_runtime_breakdown_qrf__num_info_lines_7.txt';
bqrrp_runtime_breakdown_gpu(filename1, filename2, 1);

% CPU PLOTS
figure
filename1 = 'benchmark-output-bqrrp-paper/SapphireRapids/BQRRP_runtime_breakdown/BQRRP_runtime_breakdown_num_info_lines_7.txt';
filename2 = 'benchmark-output-bqrrp-paper/Zen4c/BQRRP_runtime_breakdown/BQRRP_runtime_breakdown_num_info_lines_7.txt';
bqrrp_runtime_breakdown_cpu(filename1, filename2, 6, 3, 1);

figure
filename1 = 'benchmark-output-bqrrp-paper/SapphireRapids/BQRRP_speed_comparisons_block_size/BQRRP_speed_comparisons_block_size_num_info_lines_7.txt';
filename2 = 'benchmark-output-bqrrp-paper/Zen4c/BQRRP_speed_comparisons_block_size/BQRRP_speed_comparisons_block_size_num_info_lines_7.txt';
bqrrp_speed_comparisons_block_size_cpu(filename1, filename2, 2^16, 2^16, 64000, 64000, 6, 3, 7, 1);

figure
filename1 = 'benchmark-output-bqrrp-paper/SapphireRapids/BQRRP_speed_comparisons_block_size_small/BQRRP_speed_comparisons_block_size_num_info_lines_7.txt';
filename2 = 'benchmark-output-bqrrp-paper/Zen4c/BQRRP_speed_comparisons_block_size_small/BQRRP_speed_comparisons_block_size_num_info_lines_7.txt';
bqrrp_speed_comparisons_block_size_cpu_small_data(filename1, filename2, 1000, 1000, 3, 8, 3, 7, 1);

figure
filename1 = 'benchmark-output-bqrrp-paper/SapphireRapids/BQRRP_speed_comparisons_mat_size/BQRRP_speed_comparisons_mat_size_num_info_lines_7.txt';
filename2 = 'benchmark-output-bqrrp-paper/Zen4c/BQRRP_speed_comparisons_mat_size/BQRRP_speed_comparisons_mat_size_num_info_lines_7.txt';
bqrrp_speed_comparisons_mat_size_cpu(filename1, filename2, 8000, 8000, 3,
5, 3, 7, 1);

filename1 = 'benchmark-output-bqrrp-paper/SapphireRapids/BQRRP_speed_comparisons_mat_size_rectangular/BQRRP_speed_comparisons_mat_size_num_info_lines_7.txt';
filename2 = 'benchmark-output-bqrrp-paper/Zen4c/BQRRP_speed_comparisons_mat_size_rectangular/BQRRP_speed_comparisons_mat_size_num_info_lines_7.txt';
bqrrp_speed_comparisons_mat_size_rectangle_cpu(filename1, filename2, 8000, 4000, 4, 3, 7, 1);
%}

figure
filename1 = 'benchmark-output-bqrrp-paper/SapphireRapids/BQRRP_subroutines_speed/2025_02_07_BQRRP_subroutines_speed_num_info_lines_10.txt';
filename2 = 'benchmark-output-bqrrp-paper/Zen4c/BQRRP_subroutines_speed/2025_03_01_BQRRP_subroutines_speed_num_info_lines_10.txt';
bqrrp_subroutine_performance_apply_q(filename1, filename2, 2^16, 256, 64000, 250, 6, 3, 7, 1)

