function[] = bqrrp_speed_comparisons_block_size_gpu(filename, rows, cols, num_block_sizes, num_mat_sizes, show_labels);
    Data_in = readfile(filename, 6);
    
    plot_position = 1;
    % Vertically stacking 32k adn 16k data
    tiledlayout(num_mat_sizes, 1,"TileSpacing","tight")
    for i=1:num_mat_sizes
        nexttile
        process_and_plot(Data_in(num_block_sizes*(i-1)+1:num_block_sizes*i,:), num_block_sizes, rows, cols, plot_position, show_labels, 13);
        rows = rows * 2;
        cols = cols * 2;
        plot_position = plot_position + 1;
    end
end

function[] = process_and_plot(Data_in, num_block_sizes, rows, cols, plot_position, show_labels, y_lim)
    geqrf_tflop = (2 * rows * cols^2 - (2 / 3) * cols^3 + rows * cols + cols^2 + (14 / 3) * cols) / 10^12;

    for i = 1:num_block_sizes
        % The input data is in microseconds, we need TFLOP/s
        Data_out(i, 1) = geqrf_tflop / (Data_in(i, 1) / 10^6); %#ok<AGROW> % BQRRP_HQR
        Data_out(i, 2) = geqrf_tflop / (Data_in(i, 2) / 10^6); %#ok<AGROW> % BQRRP_CQR
        Data_out(i, 3) = geqrf_tflop / (Data_in(i, 3) / 10^6); %#ok<AGROW> % GEQRF
    end 

    % Making usre there's no variation in GEQRF
    Data_out(:, 3) = min(Data_out(:, 3)) * ones(size(Data_out, 3), 1);
   
    x = [32, 64, 96, 128, 160, 192, 224, 256, 288, 320, 352, 384, 416, 448, 480, 512, 640, 768, 896, 1024, 1152, 1280, 1408, 1536, 1664, 1792, 1920, 2048];

    plot(x, Data_out(:, 1), '-<', 'Color', '#EDB120', "MarkerSize", 18,'LineWidth', 1.8) % BQRRP_HQR
    hold on
    plot(x, Data_out(:, 2), '->', 'Color', 'black', "MarkerSize", 18,'LineWidth', 1.8) % BQRRP_CQR
    hold on
    plot(x, Data_out(:, 3), '', 'Color', 'blue',    "MarkerSize", 18,'LineWidth', 1.8) % GEQRF
    hold on

    xlim([32 2048]);
    %ylim([0 y_lim]);
    ax = gca;
    ax.XAxis.FontSize = 20;
    ax.YAxis.FontSize = 20;
    grid on

    if show_labels 
        switch plot_position
            case 1
                title('NVIDIA H100', 'FontSize', 20);
                ylabel('dim = 2048; GigaFLOP/s', 'FontSize', 20);
            case 2
                ylabel('dim = 4096; GigaFLOP/s', 'FontSize', 20);
            case 3
                ylabel('dim = 8,192; GigaFLOP/s', 'FontSize', 20);
            case 4
                ylabel('dim = 16384; GigaFLOP/s', 'FontSize', 20);
            case 5
                ylabel('dim = 32768; GigaFLOP/s', 'FontSize', 20);
                xlabel('block size', 'FontSize', 20); 
        end
    end
    switch plot_position
        case 1
            lgd = legend('BQRRP\_HQR\_GPU', 'BQRRP\_CQR\_GPU', 'GEQRF\_GPU');
            lgd.FontSize = 20;
            legend('Location','northoutside'); 
            set(gca,'Xticklabel',[])
        case 2
            set(gca,'Xticklabel',[])
        case 3
            set(gca,'Xticklabel',[])
        case 4
            set(gca,'Xticklabel',[])
        case 5
            xticks([32,  256, 512, 1024, 2048]);
    end
end
