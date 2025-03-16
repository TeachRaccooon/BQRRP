function[] = hqrrp_performance_varying_block_size()
    Data_in_Intel = readfile('Data_in/2025_02/SapphireRapids/HQRRP_speed_comparisons_block_size/2025_03_12_BQRRP_speed_comparisons_block_size_num_info_lines_7.txt', 7);
    Data_in_AMD  = readfile('Data_in/2025_02/Zen4c/HQRRP_speed_comparisons_block_size/2025_03_12_BQRRP_speed_comparisons_block_size_num_info_lines_7.txt', 7);

    rows = 32000;
    cols = 32000;

    num_thread_nums = 7;
    num_block_sizes = 11;
    num_iters = 3;
    num_algs = 7;

    show_labels = 0;
    plot_position = 1;
    y_lim = [90, 400, 800, 1600, 2800, 3800, 4200];

    % Vertically stacking 65k adn 64k data
    % Horizontally stacking Intel and AMD machines
    tiledlayout(7, 2,"TileSpacing","compact")
    for i = 1:num_thread_nums
        nexttile
        process_and_plot(Data_in_Intel(((i-1)*num_block_sizes*num_iters+1):(i*num_block_sizes*num_iters),:), num_block_sizes, num_iters, num_algs, rows, cols, plot_position, show_labels, y_lim(1, i));
        plot_position = plot_position + 1;
        nexttile
        process_and_plot(Data_in_AMD(((i-1)*num_block_sizes*num_iters+1):(i*num_block_sizes*num_iters),:), num_block_sizes, num_iters, num_algs, rows, cols, plot_position, show_labels, y_lim(1, i));
        plot_position = plot_position + 1;
    end
end


function[] = process_and_plot(Data_in, num_block_sizes, num_iters, num_algs, rows, cols, plot_position, show_labels, y_lim)

    Data_in = data_preprocessing_best(Data_in, num_block_sizes, num_iters, num_algs);

    geqrf_gflop = (2 * rows * cols^2 - (2 / 3) * cols^3 + rows * cols + cols^2 + (14 / 3) * cols) / 10^9;
    for i = 1:num_block_sizes
        Data_out(i, 1) = geqrf_gflop / (Data_in(i, 3) / 10^6); %#ok<AGROW> % HQRRP_BASIC
        Data_out(i, 2) = geqrf_gflop / (Data_in(i, 6) / 10^6); %#ok<AGROW> % GEQRF
        Data_out(i, 3) = geqrf_gflop / (Data_in(i, 7) / 10^6); %#ok<AGROW> % GEQP3
    end

    % Making usre there's no variation in GEQRF and GEQP3
    %Data_out_GEQRF = Data_out(:, 6);
    %Data_out_GEQRF = Data_out_GEQRF(~isinf(Data_out_GEQRF));
    %Data_out(:, 6) = max(Data_out_GEQRF) * ones(size(Data_out, 6), 1);
    %Data_out(:, 6) = max(Data_out(:, 6)) * ones(size(Data_out, 6), 1);
    %Data_out(:, 7) = min(Data_out(:, 7)) * ones(size(Data_out, 7), 1);

    
    x = [5, 10, 25, 50, 125, 250, 500, 1000, 2000, 4000, 8000];

    loglog(x, Data_out(:, 1), '-d', 'Color', 'magenta', "MarkerSize", 18,'LineWidth', 1.8) % HQRRP_BASIC
    hold on
    loglog(x, Data_out(:, 2), '  ', 'Color', 'red', "MarkerSize", 18,'LineWidth', 1.8)     % GEQRF
    hold on
    loglog(x, Data_out(:, 3), '  ', 'Color', 'blue', "MarkerSize", 18,'LineWidth', 1.8)    % GEQP3

    xlim([5 8000]);
    %ylim([0 y_lim]);
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
            case 2
                title('AMD CPU', 'FontSize', 20);
            case 13
                xlabel('block size', 'FontSize', 20); 
            case 14
                xlabel('block size', 'FontSize', 20); 
        end
    end

    if plot_position < 13
        set(gca,'Xticklabel',[])
    end
    if ~mod(plot_position, 2)
        set(gca,'Yticklabel',[])
    end
    switch plot_position
        case 2
            set(gca,'Yticklabel',[])
            lgd=legend('HQRRP', 'GEQRF', 'GEQP3');
            lgd.FontSize = 20;
            legend('Location','northeastoutside'); 
        case 13
            xticks([5, 10, 25, 50, 125, 250, 500, 1000, 2000, 4000, 8000]);
            xticklabels({'', '10', '', '50', '', '250', '', '1000', '', '4000'})
        case 14
            xticks([5, 10, 25, 50, 125, 250, 500, 1000, 2000, 4000, 8000]);
            xticklabels({'', '10', '', '50', '', '250', '', '1000', '', '4000'})
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