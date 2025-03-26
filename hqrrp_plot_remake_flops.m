function[] = hqrrp_plot_remake_flops(filename_Intel, filename_AMD_AOCL, filename_AMD_MKL, num_mat_sizes, num_thread_nums, num_iters, num_algs, show_labels)
    Data_in_Intel = readfile(filename_Intel, 7);
    Data_in_AMD_AOCL = readfile(filename_AMD_AOCL, 7);
    Data_in_AMD_MKL = readfile(filename_AMD_MKL, 7);

    % A way of ensuring that Intel plots are in the left column and AMD
    % plots are in the right ones
    plot_num_Intel    = 1;
    plot_num_AMD_AOCL = 2;
    plot_num_AMD_MKL  = 3;

    % Plot controls
    num_plot_rows = 3;
    num_plot_cols = 3;

    tiledlayout(num_plot_rows, num_plot_cols, "TileSpacing", "tight");
    process_and_plot(Data_in_Intel, num_thread_nums, num_mat_sizes, num_iters, num_algs, plot_num_Intel, show_labels, num_plot_rows, num_plot_cols);
    process_and_plot(Data_in_AMD_MKL, num_thread_nums+1, num_mat_sizes, num_iters, num_algs, plot_num_AMD_AOCL, show_labels, num_plot_rows, num_plot_cols);
    process_and_plot(Data_in_AMD_AOCL, num_thread_nums+1, num_mat_sizes, num_iters, num_algs, plot_num_AMD_MKL, show_labels, num_plot_rows, num_plot_cols);
end


function[] = process_and_plot(Data_in, num_thread_nums, num_mat_sizes, num_iters, num_algs, plot_num, show_labels, num_plot_rows, num_plot_cols)

    Data_out          = [];
    Data_in_processed = [];
    dim = 1000;
    marker_array = {'-o', '-s', '-^', '-v', '-d', '-p', '-*', '-x', '-+'};
    color_array = {'b', 'r', 'g', 'm', 'c', 'k', 'y', [0.5, 0.5, 0.5], [1, 0.647, 0]};

    for j = 1:num_thread_nums
        % Row block defines timing results for matrices of size 1k ... 10k
        % for a single number of threads used, assuming a single iteration
        % per each run (since the data that is vewed in row block format 
        % has already been proessed to inlude only the "best" iteration).
        rb_start = num_mat_sizes*(j-1)+1;
        rb_end   = num_mat_sizes*j;
        Data_in_processed(rb_start:rb_end,:) = data_preprocessing_best(Data_in((num_iters*num_mat_sizes*(j-1)+1):(num_iters*num_mat_sizes*j),:), num_mat_sizes, num_iters, num_algs); %#ok<AGROW>
    
        for i = 0:num_mat_sizes-1
            geqrf_gflop = (2 * dim * dim^2 - (2 / 3) * dim^3 + dim * dim + dim^2 + (14 / 3) * dim) / 10^9;
            Data_out(rb_start+i,1) = geqrf_gflop ./ (Data_in_processed(rb_start+i, 3) ./ 10^6); %#ok<AGROW> % HQRRP GFLOPS
            Data_out(rb_start+i,2) = geqrf_gflop ./ (Data_in_processed(rb_start+i, 6) ./ 10^6); %#ok<AGROW> % GEQP3 GFLOPS
            Data_out(rb_start+i,3) = geqrf_gflop ./ (Data_in_processed(rb_start+i, 7) ./ 10^6); %#ok<AGROW> % GEQRF GFLOPS
            dim = dim + 1000;
        end
        dim = 1000;
    end
    x = [1000 2000 3000 4000 5000 6000 7000 8000 9000 10000];
    
    nexttile(plot_num)
    for j = 1:num_thread_nums
        rb_start = num_mat_sizes*(j-1)+1;
        rb_end   = num_mat_sizes*j;
        semilogy(x, Data_out(rb_start:rb_end, 1), marker_array{j}, 'Color', color_array{j}, "MarkerSize", 18,'LineWidth', 1.8) % HQRRP GFLOPS
        hold on
    end
    plot_config(plot_num, 0, 200, [1 10 50 100 150 200], show_labels, num_plot_rows, num_plot_cols);
    plot_num = plot_num + num_plot_cols;

    nexttile(plot_num)
    for j = 1:num_thread_nums
        rb_start = num_mat_sizes*(j-1)+1;
        rb_end   = num_mat_sizes*j;
        semilogy(x, Data_out(rb_start:rb_end, 2), marker_array{j}, 'Color', color_array{j}, "MarkerSize", 18,'LineWidth', 1.8) % GEQP3 GFLOPS
        hold on
    end
    plot_config(plot_num, 0, 2000, [100 500 1000 1500 2000], show_labels, num_plot_rows, num_plot_cols);
    plot_num = plot_num + num_plot_cols;

    nexttile(plot_num)
    for j = 1:num_thread_nums
        rb_start = num_mat_sizes*(j-1)+1;
        rb_end   = num_mat_sizes*j;
        semilogy(x, Data_out(rb_start:rb_end, 3), marker_array{j}, 'Color', color_array{j}, "MarkerSize", 18,'LineWidth', 1.8) % GEQRF GFLOPS
        hold on
    end
    plot_config(plot_num, 0, 170, [10 50 100 150], show_labels, num_plot_rows, num_plot_cols);

end

function[] = plot_config(plot_num, y_min_lim, y_max_lim, y_ticks, show_labels, num_plot_rows, num_plot_cols)
    if plot_num == num_plot_cols
        lgd=legend('threads=1', 'threads=4', 'threads=16', 'threads=64', 'threads=128', '448 threads');
        lgd.FontSize = 20;
        legend('Location','northeastoutside');
    end
    ylim([y_min_lim y_max_lim]);
    xlim([1000 10000]);
    xticks([2000 4000 6000 8000 10000]);
    yticks(y_ticks);
    ax = gca;
    ax.XAxis.FontSize = 20;
    ax.YAxis.FontSize = 20;
    grid on

    if show_labels
        switch plot_num
            case 1
                ylabel('HQRRP GFLOP/s', 'FontSize', 20);
                title('Sapphire Rapids + MKL', 'FontSize', 20);
            case 2
                title('Zen4c + MKL', 'FontSize', 20);
            case 3
                title('Zen4c + AOCL', 'FontSize', 20);
            case 4
                ylabel('GEQRF GFLOP/s', 'FontSize', 20);
            case 7
                ylabel('GEQP3 GFLOP/s', 'FontSize', 20);
                xlabel('dim', 'FontSize', 20);
            case 8
                xlabel('dim', 'FontSize', 20);
            case 9
                xlabel('dim', 'FontSize', 20);
        end
    end
    switch plot_num
        case 1
            set(gca,'Xticklabel',[])
        case 2
            set(gca,'Yticklabel',[])
            set(gca,'Xticklabel',[])
        case 3
            set(gca,'Yticklabel',[])
            set(gca,'Xticklabel',[])
        case 4
            set(gca,'Xticklabel',[])
        case 5
            set(gca,'Yticklabel',[])
            set(gca,'Xticklabel',[])
        case 6
            set(gca,'Yticklabel',[])
            set(gca,'Xticklabel',[])
        case 8
            set(gca,'Yticklabel',[])
        case 9
            set(gca,'Yticklabel',[])
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