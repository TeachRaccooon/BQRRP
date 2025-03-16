function[] = bqrrp_performance_varying_block_size_cpu()
    Data_in_65k_Intel = readfile('Data_in/2025_02/SapphireRapids/BQRRP_speed_comparisons_block_size/2025_01_27_BQRRP_speed_comparisons_block_size_num_info_lines_7.txt', 7);
    Data_in_64k_Intel = readfile('Data_in/2025_02/SapphireRapids/BQRRP_speed_comparisons_block_size/2025_02_13_BQRRP_speed_comparisons_block_size_num_info_lines_7.txt', 7);
    Data_in_65k_AMD  = readfile('Data_in/2025_02/Zen4c/BQRRP_speed_comparisons_block_size/2025_03_02_BQRRP_speed_comparisons_block_size_num_info_lines_7.txt', 7);
    Data_in_64k_AMD  = readfile('Data_in/2025_02/Zen4c/BQRRP_speed_comparisons_block_size/2025_03_04_BQRRP_speed_comparisons_block_size_num_info_lines_7.txt', 7);

    rows1 = 2^16;
    cols1 = 2^16;
    rows2 = 64000;
    cols2 = 64000;

    num_block_sizes = 6;
    num_iters = 3;
    num_algs = 7;

    show_labels = 0;

    % Vertically stacking 65k adn 64k data
    % Horizontally stacking Intel and AMD machines
    tiledlayout(2, 2,"TileSpacing","compact")
    nexttile
    process_and_plot(Data_in_65k_Intel, num_block_sizes, num_iters, num_algs, rows1, cols1, 1, show_labels, 5700);
    nexttile
    process_and_plot(Data_in_65k_AMD, num_block_sizes, num_iters, num_algs, rows1, cols1, 2, show_labels, 5700);
    nexttile
    process_and_plot(Data_in_64k_Intel, num_block_sizes, num_iters, num_algs, rows2, cols2, 3, show_labels, 6300);
    nexttile
    process_and_plot(Data_in_64k_AMD, num_block_sizes, num_iters, num_algs, rows2, cols2, 4, show_labels, 6300);
end


function[] = process_and_plot(Data_in, num_block_sizes, num_iters, num_algs, rows, cols, plot_position, show_labels, y_lim)

    Data_in = data_preprocessing_best(Data_in, num_block_sizes, num_iters, num_algs);

    geqrf_gflop = (2 * rows * cols^2 - (2 / 3) * cols^3 + rows * cols + cols^2 + (14 / 3) * cols) / 10^9;
    for i = 1:num_block_sizes
        Data_out(i, 1) = geqrf_gflop / (Data_in(i, 1) / 10^6); %#ok<AGROW> % BQRRP_CQR
        Data_out(i, 2) = geqrf_gflop / (Data_in(i, 2) / 10^6); %#ok<AGROW> % BQRRP_HQR
        Data_out(i, 3) = geqrf_gflop / (Data_in(i, 3) / 10^6); %#ok<AGROW> % HQRRP_BASIC
        Data_out(i, 4) = geqrf_gflop / (Data_in(i, 4) / 10^6); %#ok<AGROW> % HQRRP_CQR
        Data_out(i, 5) = geqrf_gflop / (Data_in(i, 5) / 10^6); %#ok<AGROW> % HQRRP_HQR
        Data_out(i, 6) = geqrf_gflop / (Data_in(i, 6) / 10^6); %#ok<AGROW> % GEQRF
        Data_out(i, 7) = geqrf_gflop / (Data_in(i, 7) / 10^6); %#ok<AGROW> % GEQP3
    end

    % Making usre there's no variation in GEQRF and GEQP3
    Data_out_GEQRF = Data_out(:, 6);
    Data_out_GEQRF = Data_out_GEQRF(~isinf(Data_out_GEQRF));
    Data_out(:, 6) = max(Data_out_GEQRF) * ones(size(Data_out, 6), 1);
    Data_out(:, 6) = max(Data_out(:, 6)) * ones(size(Data_out, 6), 1);
    Data_out(:, 7) = min(Data_out(:, 7)) * ones(size(Data_out, 7), 1);

    
    if mod(rows, 10)
        x = [256 512 1024 2048 4096 8192];
    else
        x = [250 500 1000 2000 4000 8000];
    end

    semilogx(x, Data_out(:, 1), '->', 'Color', 'black', "MarkerSize", 18,'LineWidth', 1.8)   % BQRRP_CQR
    hold on
    semilogx(x, Data_out(:, 2), '-<', 'Color', '#EDB120', "MarkerSize", 18,'LineWidth', 1.8)   % BQRRP_HQR
    hold on
    semilogx(x, Data_out(:, 3), '-d', 'Color', 'magenta', "MarkerSize", 18,'LineWidth', 1.8) % HQRRP_BASIC
    %hold on
    %semilogx(x, Data_out(:, 4), '->', 'Color', 'magenta', "MarkerSize", 18,'LineWidth', 1.8) % HQRRP_CQR
    %hold on
    %semilogx(x, Data_out(:, 5), '-<', 'Color', 'magenta', "MarkerSize", 18,'LineWidth', 1.8) % HQRRP_HQR
    hold on
    semilogx(x, Data_out(:, 6), '  ', 'Color', 'red', "MarkerSize", 18,'LineWidth', 1.8)     % GEQRF
    hold on
    semilogx(x, Data_out(:, 7), '  ', 'Color', 'blue', "MarkerSize", 18,'LineWidth', 1.8)    % GEQP3

    xlim([250 8192]);
    ylim([0 y_lim]);
    ax = gca;
    ax.XAxis.FontSize = 20;
    ax.YAxis.FontSize = 20;
    grid on

    if show_labels 
        switch plot_position
            case 1
                title('Intel CPU', 'FontSize', 20);
                ylabel('dim = 65,536; GigaFLOP/s', 'FontSize', 20);
            case 2
                title('AMD CPU', 'FontSize', 20);
            case 3
                ylabel('dim = 64,000; GigaFLOP/s', 'FontSize', 20); 
                xlabel('block size', 'FontSize', 20); 
            case 4
                xlabel('block size', 'FontSize', 20); 
        end
    end
    switch plot_position
        case 1
            xticks([512 2048 8192]);
        case 2
            set(gca,'Yticklabel',[])
            lgd=legend('BQRRP\_CQR', 'BQRRP\_HQR', 'HQRRP', 'GEQRF', 'GEQP3');
            lgd.FontSize = 20;
            legend('Location','northeastoutside'); 
            xticks([512 2048 8192]);
        case 3
            xticks([500 2000 8000]);
        case 4
            set(gca,'Yticklabel',[])
            xticks([500 2000 8000]);
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