function[] = bqrrp_performance_varying_mat_size_gpu()
    Data_in_65k_Intel = readfile('Data_in/2025_02/H100/BQRRP_speed_comparisons_mat_size/2025_03_03_BQRRP_GPU_speed_comparisons_mat_size_num_info_lines_6.txt', 6);
    Data_in_60k_Intel = readfile('Data_in/2025_02/H100/BQRRP_speed_comparisons_mat_size/2025_03_04_BQRRP_GPU_speed_comparisons_mat_size_num_info_lines_6.txt', 6);

    rows1 = 512;
    cols1 = 512;

    rows2 = 500;
    cols2 = 500;

    num_mat_sizes = 7;

    show_labels = 0;

    tiledlayout(1, 1,"TileSpacing","tight")
    nexttile
    process_and_plot(Data_in_65k_Intel, num_mat_sizes, rows1, cols1, 1, show_labels, 13000);
    %nexttile
    %process_and_plot(Data_in_60k_Intel, num_mat_sizes, rows2, cols2, 2, show_labels, 13000);
end


function[] = process_and_plot(Data_in, num_mat_sizes, rows, cols, plot_position, show_labels, y_lim)
    for i = 1:num_mat_sizes
        geqrf_gflop = (2 * rows * cols^2 - (2 / 3) * cols^3 + rows * cols + cols^2 + (14 / 3) * cols) / 10^9;
        Data_out(i, 1) = geqrf_gflop / (Data_in(i, 1) / 10^6); %#ok<AGROW> % BQRRP_CQR
        Data_out(i, 2) = geqrf_gflop / (Data_in(i, 2) / 10^6); %#ok<AGROW> % BQRRP_HQR
        Data_out(i, 3) = geqrf_gflop / (Data_in(i, 3) / 10^6); %#ok<AGROW> % GEQRF
        rows = rows * 2;
        cols = cols * 2;
    end

    if mod(rows, 10)
        x = [512 1024 2048 4096 8192 16384 32768];
    else
        x = [500 1000 2000 4000 8000 16000 32000];
    end

    loglog(x, Data_out(:, 1), '->', 'Color', '#EDB120', "MarkerSize", 18,'LineWidth', 1.8)   % BQRRP_CQR
    hold on
    loglog(x, Data_out(:, 2), '-<', 'Color', 'black', "MarkerSize", 18,'LineWidth', 1.8) % BQRRP_HQR
    hold on
    loglog(x, Data_out(:, 3), '-o', 'Color', 'blue', "MarkerSize", 18,'LineWidth', 1.8)     % GEQRF

    yticks([1, 10, 100, 1000, 5000, 10000]);
    ylim([0 y_lim]);
    ax = gca;
    ax.XAxis.FontSize = 20;
    ax.YAxis.FontSize = 20;
    grid on

    if show_labels 
        switch plot_position
            case 1
                title('NVIDIA H100', 'FontSize', 20);
                ylabel('dim = 32,768; GigaFLOP/s', 'FontSize', 20);
                xlabel('block size', 'FontSize', 20); 
            case 2
                title('AMD CPU', 'FontSize', 20);
                ylabel('dim = 32,000; GigaFLOP/s', 'FontSize', 20); 
                xlabel('block size', 'FontSize', 20); 
            case 3
            case 4
                xlabel('block size', 'FontSize', 20); 
        end
    end
    switch plot_position
        case 1
            lgd = legend('BQRRP\_HQR\_GPU', 'BQRRP\_CQR\_GPU', 'GEQRF\_GPU');
            lgd.FontSize = 20;
            legend('Location','northeastoutside'); 
            xticks([1024, 4096, 16384]);
            xlim([512 32768]);
        case 2
            xticks([1000, 4000, 16000]);
            xlim([500 32000]);
    end
end