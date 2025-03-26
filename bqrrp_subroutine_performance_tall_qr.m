function[] = bqrrp_subroutine_performance_tall_qr(filename_Intel, filename_AMD, rows1, cols1, rows2, cols2, num_block_sizes, num_iters, num_algs, show_labels)
    Data_in_Intel = readfile(filename_Intel, 10);
    Data_in_AMD   = readfile(filename_AMD, 10);

    Data_in_Intel_65k = Data_in_Intel(1:3*num_block_sizes*num_iters,:);
    Data_in_Intel_64k = Data_in_Intel(3*num_block_sizes*num_iters+1:end,:);
    Data_in_AMD_65k   = Data_in_AMD(1:3*num_block_sizes*num_iters,:);
    Data_in_AMD_64k   = Data_in_AMD(3*num_block_sizes*num_iters+1:end,:);

    Data_in_Intel_65k = Data_in_Intel_65k((num_block_sizes * num_iters)+1:(2 * num_block_sizes * num_iters), :);
    Data_in_Intel_64k = Data_in_Intel_64k((num_block_sizes * num_iters)+1:(2 * num_block_sizes * num_iters), :);
    Data_in_AMD_65k   = Data_in_AMD_65k((num_block_sizes * num_iters)+1:(2 * num_block_sizes * num_iters), :);
    Data_in_AMD_64k   = Data_in_AMD_64k((num_block_sizes * num_iters)+1:(2 * num_block_sizes * num_iters), :);

    % Horizontally stacking Intel and AMD machines
    tiledlayout(2, 2,"TileSpacing","tight")
    nexttile
    process_and_plot(Data_in_Intel_65k, num_block_sizes, num_iters, num_algs, rows1, cols1, 1, show_labels, 3100);
    nexttile
    process_and_plot(Data_in_AMD_65k, num_block_sizes, num_iters, num_algs, rows1, cols1, 2, show_labels, 3100);
    nexttile
    process_and_plot(Data_in_Intel_64k, num_block_sizes, num_iters, num_algs, rows2, cols2, 3, show_labels, 3800);
    nexttile
    process_and_plot(Data_in_AMD_64k, num_block_sizes, num_iters, num_algs, rows2, cols2, 4, show_labels, 3800);

end

function[] = process_and_plot(Data_in, num_block_sizes, num_iters, num_algs, rows, cols, plot_position, show_labels, y_lim)

   
    Data_in = data_preprocessing_best(Data_in, num_block_sizes, num_iters, num_algs);

    for i = 1:num_block_sizes
        geqrf_gflop = (2 * rows * cols^2 - (2 / 3) * cols^3 + rows * cols + cols^2 + (14 / 3) * cols) / 10^9;
        cols = cols * 2;

        Data_out(i, 1) = geqrf_gflop / (Data_in(i, 1) / 10^6); %#ok<AGROW> % GEQRF
        Data_out(i, 2) = geqrf_gflop / (Data_in(i, 2) / 10^6); %#ok<AGROW> % GEQR
        Data_out(i, 3) = geqrf_gflop / (Data_in(i, 3) / 10^6); %#ok<AGROW  % CHOLQR
        Data_out(i, 4) = geqrf_gflop / ((Data_in(i, 3) + Data_in(i, 4) + Data_in(i, 5) + Data_in(i, 6)) / 10^6); %#ok<AGROW  % CHOLQR+dependencies
        Data_out(i, 5)  = geqrf_gflop / (Data_in(i, 7)  / 10^6);  %#ok<AGROW  % GEQRT NB 256
        Data_out(i, 6)  = geqrf_gflop / (Data_in(i, 8)  / 10^6);  %#ok<AGROW  % GEQRT NB 512
        Data_out(i, 7)  = geqrf_gflop / (Data_in(i, 9)  / 10^6);  %#ok<AGROW  % GEQRT NB 1024
        Data_out(i, 8)  = geqrf_gflop / (Data_in(i, 10)  / 10^6); %#ok<AGROW  % GEQRT NB 2048
    end

    x = [256 512 1024 2048 4096 8192];
    semilogx(x, Data_out(:, 1), '-^', 'Color', 'red', "MarkerSize", 18,'LineWidth', 1.8)     % GEQRF
    hold on
    semilogx(x, Data_out(:, 2), '-v', 'Color', '#EDB120', "MarkerSize", 18,'LineWidth', 1.8) % GEQR
    hold on
    semilogx(x, Data_out(:, 3), '-<', 'Color', 'blue', "MarkerSize", 18,'LineWidth', 1.8)    % CHOLQR
    hold on
    semilogx(x, Data_out(:, 4), '->', 'Color', 'black', "MarkerSize", 18,'LineWidth', 1.8)   % CHOLQR+dependencies
    hold on
    semilogx(x, Data_out(:, 5), '-*', 'Color', 'magenta', "MarkerSize", 18,'LineWidth', 1.8) % GEQRT NB 256
    hold on
    semilogx(x, Data_out(:, 6), '-*', 'Color', 'magenta', "MarkerSize", 18,'LineWidth', 1.8) % GEQRT NB 512
    hold on
    semilogx(x, Data_out(:, 7), '-*', 'Color', 'magenta', "MarkerSize", 18,'LineWidth', 1.8) % GEQRT NB 1024
    hold on
    semilogx(x, Data_out(:, 8), '-*', 'Color', 'magenta', "MarkerSize", 18,'LineWidth', 1.8) % GEQRT NB 2048
    xticks([512 2048 8192]);
    xlim([256 8192]);
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
            lgd=legend('GEQRF', 'LATSQR', 'CholQR', 'CholQR + dep', 'GEQRT');
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