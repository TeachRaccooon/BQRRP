function[] = bqrrp_performance_varying_mat_size_rectangle_cpu()
    Data_in_Intel_tall = readfile('Data_in/2025_02/SapphireRapids/BQRRP_speed_comparisons_mat_size_rectangular/2025_03_18_BQRRP_speed_comparisons_mat_size_num_info_lines_7.txt', 7);
    Data_in_AMD_tall   = readfile('Data_in/2025_02/Zen4c/BQRRP_speed_comparisons_mat_size_rectangular/2025_03_19_20_29_53_BQRRP_speed_comparisons_mat_size_num_info_lines_7.txt', 7);
    Data_in_Intel_wide = readfile('Data_in/2025_02/SapphireRapids/BQRRP_speed_comparisons_mat_size_rectangular/2025_03_19_BQRRP_speed_comparisons_mat_size_num_info_lines_7.txt', 7);
    Data_in_AMD_wide   = readfile('Data_in/2025_02/Zen4c/BQRRP_speed_comparisons_mat_size_rectangular/2025_03_20_10_10_49_BQRRP_speed_comparisons_mat_size_num_info_lines_7.txt', 7);

    rows = 8000;
    cols = 4000;

    num_mat_sizes = 4;
    num_iters = 3;
    num_algs = 7;

    show_labels = 0;

    %128 threads - 1 thread
    figure
    tiledlayout(1, 2,"TileSpacing","compact")
    nexttile
    process_and_plot(Data_in_Intel_tall, num_mat_sizes, num_iters, num_algs, rows, cols, 1, show_labels, 4200)
    nexttile
    process_and_plot(Data_in_AMD_tall, num_mat_sizes, num_iters, num_algs, rows, cols, 2, show_labels, 4200)

    figure
    tiledlayout(1, 2,"TileSpacing","compact")
    nexttile
    process_and_plot(Data_in_Intel_wide, num_mat_sizes, num_iters, num_algs, cols, rows, 3, show_labels, 4900)
    nexttile
    process_and_plot(Data_in_AMD_wide, num_mat_sizes, num_iters, num_algs, cols, rows, 4, show_labels, 4900)
end


function[] = process_and_plot(Data_in, num_mat_sizes, num_iters, num_algs, rows, cols, plot_position, show_labels, y_lim)

    Data_in = data_preprocessing_best(Data_in, num_mat_sizes, num_iters, num_algs);

    for i = 1:num_mat_sizes
        geqrf_gflop = (2 * rows * cols^2 - (2 / 3) * cols^3 + rows * cols + cols^2 + (14 / 3) * cols) / 10^9;
        Data_out(i, 1) = geqrf_gflop / (Data_in(i, 1) / 10^6); %#ok<AGROW> % BQRRP_CQR
        Data_out(i, 2) = geqrf_gflop / (Data_in(i, 2) / 10^6); %#ok<AGROW> % BQRRP_HQR
        Data_out(i, 3) = geqrf_gflop / (Data_in(i, 3) / 10^6); %#ok<AGROW> % HQRRP_BASIC
        Data_out(i, 4) = geqrf_gflop / (Data_in(i, 4) / 10^6); %#ok<AGROW> % HQRRP_CQR
        Data_out(i, 5) = geqrf_gflop / (Data_in(i, 5) / 10^6); %#ok<AGROW> % HQRRP_HQR
        Data_out(i, 6) = geqrf_gflop / (Data_in(i, 6) / 10^6); %#ok<AGROW> % GEQRF
        Data_out(i, 7) = geqrf_gflop / (Data_in(i, 7) / 10^6); %#ok<AGROW> % GEQP3
        rows = rows * 2;
        cols = cols * 2;
    end

    x = [8000 16000 32000 64000];

    loglog(x, Data_out(:, 1), '->', 'Color', 'black', "MarkerSize", 18,'LineWidth', 1.8)   % BQRRP_CQR
    hold on
    loglog(x, Data_out(:, 2), '-<', 'Color', '#EDB120', "MarkerSize", 18,'LineWidth', 1.8)   % BQRRP_HQR
    hold on
    loglog(x, Data_out(:, 3), '-d', 'Color', 'magenta', "MarkerSize", 18,'LineWidth', 1.8) % HQRRP_BASIC
    %hold on
    %loglog(x, Data_out(:, 4), '->', 'Color', 'magenta', "MarkerSize", 18,'LineWidth', 1.8) % HQRRP_CQR
    %hold on
    %loglog(x, Data_out(:, 5), '-<', 'Color', 'magenta', "MarkerSize", 18,'LineWidth', 1.8) % HQRRP_HQR
    hold on
    loglog(x, Data_out(:, 6), '-o', 'Color', 'red', "MarkerSize", 18,'LineWidth', 1.8)     % GEQRF
    hold on
    loglog(x, Data_out(:, 7), '-s', 'Color', 'blue', "MarkerSize", 18,'LineWidth', 1.8)    % GEQP3

    xlim([8000 64000]);
    ylim([0 y_lim]);
    yticks([0, 50, 250, 500, 1000, 2000, 4000]);
    ax = gca;
    ax.XAxis.FontSize = 20;
    ax.YAxis.FontSize = 20;
    grid on
    
    if show_labels 
        if mod(plot_position, 2)
            ylabel('GigaFLOP/s', 'FontSize', 20);
        end
        switch plot_position
            case 1
                title('Intel CPU', 'FontSize', 20);
                xlabel('m', 'FontSize', 20); 
            case 2
                title('AMD CPU', 'FontSize', 20);
                xlabel('m', 'FontSize', 20);
            case 13
                xlabel('n', 'FontSize', 20);
            case 14
                xlabel('n', 'FontSize', 20);
        end
    end

    switch plot_position
        case 1
            xticks([8000 16000 32000 64000]);
            xticklabels({'8000', '', '32000', ''})
        case 2
            set(gca,'Yticklabel',[])
            lgd=legend('BQRRP\_CQR', 'BQRRP\_HQR', 'HQRRP', 'GEQRF', 'GEQP3');
            lgd.FontSize = 20;
            legend('Location','northeastoutside'); 
            set(gca,'Yticklabel',[])
            xticks([8000 16000 32000 64000]);
            xticklabels({'8000', '', '32000', ''})
        case 3
            xticks([8000 16000 32000 64000]);
            xticklabels({'8000', '', '32000', ''})
        case 4
            set(gca,'Yticklabel',[])
            lgd=legend('BQRRP\_CQR', 'BQRRP\_HQR', 'HQRRP', 'GEQRF', 'GEQP3');
            lgd.FontSize = 20;
            legend('Location','northeastoutside'); 
            set(gca,'Yticklabel',[])
            xticks([8000 16000 32000 64000]);
            set(gca,'Yticklabel',[])
            xticks([8000 16000 32000 64000]);
            xticklabels({'8000', '', '32000', ''})
    end
end


function[Data_out] = data_preprocessing_best(Data_in, num_col_sizes, num_iters, num_algs)
    
    Data_out = [];

    i = 1;
    for k = 1:num_algs
        Data_out_col = [];
        while i < num_col_sizes * num_iters
            best_speed = intmax;
            best_speed_idx = i;
            for j = 1:num_iters
                if Data_in(i, k) < best_speed
                    best_speed = Data_in(i, k);
                    best_speed_idx = i;
                end
                i = i + 1;
            end
            Data_out_col = [Data_out_col; Data_in(best_speed_idx, k)]; %#ok<AGROW>
        end
        i = 1;
        Data_out = [Data_out, Data_out_col]; %#ok<AGROW>
    end
end