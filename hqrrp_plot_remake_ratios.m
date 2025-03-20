function[] = hqrrp_plot_remake_ratios()
    %Data_in_AMD_AOCL = readfile('Data_in/2025_02/Zen4c/BQRRP_speed_comparisons_mat_size/2025_02_22_BQRRP_speed_comparisons_mat_size_num_info_lines_7.txt', 7);
    Data_in_AMD_MKL  = readfile('Data_in/2025_02/Zen4c/BQRRP_speed_comparisons_mat_size/2025_02_25_BQRRP_speed_comparisons_mat_size_num_info_lines_7.txt', 7);
    Data_in_Intel    = readfile('Data_in/2025_02/SapphireRapids/BQRRP_speed_comparisons_mat_size/2025_02_20_BQRRP_speed_comparisons_mat_size_num_info_lines_7.txt', 7);
    
    num_thread_nums = 5;
    num_mat_sizes   = 10;
    num_iters       = 20;
    num_algs        = 7;

    % A way of ensuring that Intel plots are in the left column and AMD
    % plots are in the right ones
    plot_num_Intel = 1;
    plot_num_AMD_MKL = 2;
    plot_num_AMD_AOCL = 3;

    % Label controls
    show_labels = 0;
    % Plot controls
    num_plot_rows = 2;
    num_plot_cols = 2;

    figure;
    tiledlayout(num_plot_rows, num_plot_cols, "TileSpacing", "tight");
    process_and_plot(Data_in_Intel, num_thread_nums, num_mat_sizes, num_iters, num_algs, plot_num_Intel, show_labels, num_plot_rows, num_plot_cols);
    process_and_plot(Data_in_AMD_MKL, num_thread_nums+1, num_mat_sizes, num_iters, num_algs, plot_num_AMD_MKL, show_labels, num_plot_rows, num_plot_cols);
    %process_and_plot(Data_in_AMD_AOCL, num_thread_nums+1, num_mat_sizes, num_iters, num_algs, plot_num_AMD_AOCL, show_labels, num_plot_rows, num_plot_cols);
end


function[] = process_and_plot(Data_in, num_thread_nums, num_mat_sizes, num_iters, num_algs, plot_num, show_labels, num_plot_rows, num_plot_cols)

    Data_out          = [];
    Data_in_processed = [];
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

        Data_out(rb_start:rb_end,1) = Data_in_processed(rb_start:rb_end, 7) ./ Data_in_processed(rb_start:rb_end, 3); %#ok<AGROW> % GEQP3 time / HQRRP time
        Data_out(rb_start:rb_end,2) = Data_in_processed(rb_start:rb_end, 7) ./ Data_in_processed(rb_start:rb_end, 6); %#ok<AGROW> % GEQP3 time / GEQRF time

    end
    x = [1000 2000 3000 4000 5000 6000 7000 8000 9000 10000];
    
    nexttile(plot_num)
    for j = 1:num_thread_nums
        rb_start = num_mat_sizes*(j-1)+1;
        rb_end   = num_mat_sizes*j;
        semilogy(x, Data_out(rb_start:rb_end, 1), marker_array{j}, 'Color', color_array{j}, "MarkerSize", 18,'LineWidth', 1.8) % GEQP3 time / HQRRP time
        hold on
    end
    plot_config(plot_num, 0.015, 15, [0 0.1 1 5 10 15], show_labels, num_plot_rows, num_plot_cols);
    plot_num = plot_num + num_plot_cols;

    nexttile(plot_num)
    for j = 1:num_thread_nums
        rb_start = num_mat_sizes*(j-1)+1;
        rb_end   = num_mat_sizes*j;
        semilogy(x, Data_out(rb_start:rb_end, 2), marker_array{j}, 'Color', color_array{j}, "MarkerSize", 18,'LineWidth', 1.8) % GEQP3 time / GEQRF time
        hold on
    end
    plot_config(plot_num, 0, 100, [0 1 10 25 50, 100], show_labels, num_plot_rows, num_plot_cols);

end

function[] = plot_config(plot_num, y_min_lim, y_max_lim, y_ticks, show_labels, num_plot_rows, num_plot_cols)
    if plot_num == num_plot_cols
        lgd=legend('1 thread', '4 threads', '16 threads', '64 threads', '128 threads', '448 threads');
        lgd.FontSize = 20;
        legend('Location','northeastoutside');
    end
    ylim([y_min_lim y_max_lim]);
    xlim([0 10000]);
    xticks([2000 4000 6000 8000 10000]);
    yticks(y_ticks);
    ax = gca;
    ax.XAxis.FontSize = 20;
    ax.YAxis.FontSize = 20;
    grid on

    if show_labels
        switch plot_num
            case 1
                ylabel('GEQP3/HQRRP', 'FontSize', 20);
                title('Sapphire Rapids + MKL', 'FontSize', 20);
            case 2
                title('Zen4c + MKL', 'FontSize', 20);
            case 3
                if num_plot_cols == 3
                    title('Zen4c + AOCL', 'FontSize', 20);
                elseif num_plot_cols == 2
                    ylabel('GEQP3/GEQRF', 'FontSize', 20);
                    xlabel('dim', 'FontSize', 20);
                end
            case 4
                if num_plot_cols == 3
                    ylabel('GEQP3/GEQRF', 'FontSize', 20);
                end
                xlabel('dim', 'FontSize', 20);
            case 5
                xlabel('dim', 'FontSize', 20);
            case 6
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
            if num_plot_cols == 3
                set(gca,'Yticklabel',[])
                set(gca,'Xticklabel',[])
            end
        case 4
            if num_plot_cols == 2
                set(gca,'Yticklabel',[])
            end
        case 5
            set(gca,'Yticklabel',[])
        case 6
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

function[Data_out] = data_preprocessing_avg(Data_in, num_col_sizes, num_iters, num_algs)
    
    Data_out = [];

    i = 1;
    for k = 1:num_algs
        Data_out_col = [];
        while i < num_col_sizes * num_iters
            avg_speed = 0;
            for j = 1:num_iters
                avg_speed = avg_speed +  Data_in(i, k);
                i = i + 1;
            end
            Data_out_col = [Data_out_col; avg_speed / i]; %#ok<AGROW>
        end
        i = 1;
        Data_out = [Data_out, Data_out_col]; %#ok<AGROW>
    end
end