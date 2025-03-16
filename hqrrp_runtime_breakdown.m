function[] = hqrrp_runtime_breakdown()
    % 65k DATA
    Data_in_Intel = readfile('Data_in/2025_02/SapphireRapids/HQRRP_runtime_breakdown/2025_03_09_HQRRP_runtime_breakdown_num_info_lines_7.txt', 7);
    Data_in_AMD   = readfile('Data_in/2025_02/Zen4c/HQRRP_runtime_breakdown/2025_03_06_HQRRP_runtime_breakdown_num_info_lines_7.txt', 7);
    
    num_block_sizes = 11;
    numiters = 3;
    num_thread_nums = 7;
    show_labels = 1;
    plot_position = 1;
    
    % Horizontally stacking Intel and AMD machines
    tiledlayout(7, 2,"TileSpacing","tight")
    for i = 1:num_thread_nums
        nexttile
        process_and_plot(Data_in_Intel(((i-1) * numiters * num_block_sizes + 1):i * numiters * num_block_sizes,:), num_block_sizes, numiters, plot_position, show_labels)
        plot_position = plot_position + 1;
        nexttile
        process_and_plot(Data_in_AMD(((i-1) * numiters * num_block_sizes + 1):i * numiters * num_block_sizes,:), num_block_sizes, numiters, plot_position, show_labels)
        plot_position = plot_position + 1;
    end
end
function[] = process_and_plot(Data_in, num_block_sizes, numiters, plot_position, show_labels)
    Data_in = data_preprocessing_best(Data_in, num_block_sizes, numiters);

    for i = 1:size(Data_in, 1)
        %{
        % Below is breakdown of all data we get from HQRRP benchmark - inpossible to plot 
        Data_out_HQRRP_CPU(i, 1) = 100 * Data_in(i, 1)                  /Data_in(i, 9); %#ok<AGROW> % preallocation
        Data_out_HQRRP_CPU(i, 2) = 100 * Data_in(i, 2)                  /Data_in(i, 9); %#ok<AGROW> % SKOP
        Data_out_HQRRP_CPU(i, 3) = 100 * Data_in(i, 3)                  /Data_in(i, 9); %#ok<AGROW> % downdating
        Data_out_HQRRP_CPU(i, 4) = 100 * Data_in(i, 4)                  /Data_in(i, 9); %#ok<AGROW> % QRCP -----------------> IMPLICITLY REMOVED
        Data_out_HQRRP_CPU(i, 5) = 100 * Data_in(i, 5)                  /Data_in(i, 9); %#ok<AGROW> % QR -------------------> IMPLICITLY REMOVED
        Data_out_HQRRP_CPU(i, 6) = 100 * Data_in(i, 6)                  /Data_in(i, 9); %#ok<AGROW> % update A -------------> IMPORTANT
        Data_out_HQRRP_CPU(i, 7) = 100 * Data_in(i, 7)                  /Data_in(i, 9); %#ok<AGROW> % update sketch
        Data_out_HQRRP_CPU(i, 8) = 100 * Data_in(i, 8)                  /Data_in(i, 9); %#ok<AGROW> % other ----------------> IMPORTANT
        % Skipping 9 - that is total time for HQRRP
        Data_out_HQRRP_CPU(i, 9) = 100 * Data_in(i, 10)                 /Data_in(i, 9); %#ok<AGROW> % QRCP preallocation
        Data_out_HQRRP_CPU(i, 10) = 100 * Data_in(i, 11)                /Data_in(i, 9); %#ok<AGROW> % QRCP norms
        Data_out_HQRRP_CPU(i, 11) = 100 * Data_in(i, 12)                /Data_in(i, 9); %#ok<AGROW> % QRCP pivoting --------> IMPORTANT
        Data_out_HQRRP_CPU(i, 12) = 100 * Data_in(i, 13)                /Data_in(i, 9); %#ok<AGROW> % QRCP gen_reflector_1
        Data_out_HQRRP_CPU(i, 13) = 100 * Data_in(i, 14)                /Data_in(i, 9); %#ok<AGROW> % QRCP gen_reflector_2 -> IMPORTANT
        Data_out_HQRRP_CPU(i, 14) = 100 * Data_in(i, 15)                /Data_in(i, 9); %#ok<AGROW> % QRCP downdating
        Data_out_HQRRP_CPU(i, 15) = 100 * Data_in(i, 16)                /Data_in(i, 9); %#ok<AGROW> % QRCP gen_T
        Data_out_HQRRP_CPU(i, 16) = 100 * Data_in(i, 17)                /Data_in(i, 9); %#ok<AGROW> % QRCP other
        % Skipping 18 - that is total time for QRCP
        Data_out_HQRRP_CPU(i, 18) = 100 * Data_in(i, 19)                /Data_in(i, 9); %#ok<AGROW> % QR preallocation
        Data_out_HQRRP_CPU(i, 19) = 100 * Data_in(i, 20)                /Data_in(i, 9); %#ok<AGROW> % QR norms
        Data_out_HQRRP_CPU(i, 20) = 100 * Data_in(i, 21)                /Data_in(i, 9); %#ok<AGROW> % QR pivoting
        Data_out_HQRRP_CPU(i, 21) = 100 * Data_in(i, 22)                /Data_in(i, 9); %#ok<AGROW> % QR gen_reflector_1
        Data_out_HQRRP_CPU(i, 22) = 100 * Data_in(i, 23)                /Data_in(i, 9); %#ok<AGROW> % QR gen_reflector_2 ---> IMPORTANT
        Data_out_HQRRP_CPU(i, 23) = 100 * Data_in(i, 24)                /Data_in(i, 9); %#ok<AGROW> % QR downdating
        Data_out_HQRRP_CPU(i, 24) = 100 * Data_in(i, 25)                /Data_in(i, 9); %#ok<AGROW> % QR gen_T -------------> IMPORTANT
        Data_out_HQRRP_CPU(i, 25) = 100 * Data_in(i, 26)                /Data_in(i, 9); %#ok<AGROW> % QR other 
        % Skipping 27 - that is total time for QRCP
        %}
        
        %{
        % Below are the HQRRP performance breakdown plots that do not
        investigate the internal performance of QR and QRCP
        Data_out_HQRRP_CPU(i, 7) = 100 * Data_in(i, 6)                                                                                              /Data_in(i, 9); %#ok<AGROW> % update A 
        Data_out_HQRRP_CPU(i, 6) = 100 * Data_in(i, 12)                                                                                             /Data_in(i, 9); %#ok<AGROW> % QRCP pivoting 
        Data_out_HQRRP_CPU(i, 5) = 100 * Data_in(i, 14)                                                                                             /Data_in(i, 9); %#ok<AGROW> % QRCP gen_reflector_2 
        Data_out_HQRRP_CPU(i, 4) = 100 * (Data_in(i, 10)+Data_in(i, 11)+Data_in(i, 13)+Data_in(i, 15)+Data_in(i, 16)+Data_in(i, 17))                /Data_in(i, 9); %#ok<AGROW> % QRCP other
        Data_out_HQRRP_CPU(i, 3) = 100 * Data_in(i, 23)                                                                                             /Data_in(i, 9); %#ok<AGROW> % QR gen_reflector_2 
        Data_out_HQRRP_CPU(i, 2) = 100 * (Data_in(i, 19)+Data_in(i, 20)+Data_in(i, 21)+Data_in(i, 22)+Data_in(i, 24)+Data_in(i, 25)+Data_in(i, 26)) /Data_in(i, 9); %#ok<AGROW> % QR other 
        Data_out_HQRRP_CPU(i, 1) = 100 * (Data_in(i, 1)+Data_in(i, 2)+Data_in(i, 3)+Data_in(i, 7)+Data_in(i, 8))                                    /Data_in(i, 9); %#ok<AGROW> % other 
        
        Data_out_HQRRP_CPU(i, 7) = 100 * Data_in(i, 2)                                                                                                             /Data_in(i, 9); %#ok<AGROW> % SKOP
        Data_out_HQRRP_CPU(i, 6) = 100 * Data_in(i, 3)                                                                                                             /Data_in(i, 9); %#ok<AGROW> % downdating
        Data_out_HQRRP_CPU(i, 5) = 100 * (Data_in(i, 10)+Data_in(i, 11)+Data_in(i, 12)+Data_in(i, 13)+Data_in(i, 14)+Data_in(i, 15)+Data_in(i, 16)+Data_in(i, 17)) /Data_in(i, 9); %#ok<AGROW> % QRCP 
        Data_out_HQRRP_CPU(i, 4) = 100 * (Data_in(i, 19)+Data_in(i, 20)+Data_in(i, 21)+Data_in(i, 22)+Data_in(i, 23)+Data_in(i, 24)+Data_in(i, 25)+Data_in(i, 26)) /Data_in(i, 9); %#ok<AGROW> % QR  
        Data_out_HQRRP_CPU(i, 3) = 100 * Data_in(i, 6)                                                                                                             /Data_in(i, 9); %#ok<AGROW> % update A 
        Data_out_HQRRP_CPU(i, 2) = 100 * Data_in(i, 7)                                                                                                             /Data_in(i, 9); %#ok<AGROW> % update sketch
        Data_out_HQRRP_CPU(i, 1) = 100 * (Data_in(i, 1) +Data_in(i, 8))                                                                                            /Data_in(i, 9); %#ok<AGROW> % preallocation, other
        %}

        % Top 5 most time-consuming indices: 23, 14, 25, 6, 12;  

        Data_out_HQRRP_CPU(i, 8) = 100 * Data_in(i, 12)                                                                              /Data_in(i, 9); %#ok<AGROW> % QRCP pivoting 
        Data_out_HQRRP_CPU(i, 7) = 100 * Data_in(i, 14)                                                                              /Data_in(i, 9); %#ok<AGROW> % QRCP gen_reflector_2
        Data_out_HQRRP_CPU(i, 6) = 100 * Data_in(i, 25)                                                                              /Data_in(i, 9); %#ok<AGROW> % QR gen_T 
        Data_out_HQRRP_CPU(i, 5) = 100 * Data_in(i, 23)                                                                              /Data_in(i, 9); %#ok<AGROW> % QR gen_reflector_2 
        Data_out_HQRRP_CPU(i, 4) = 100 * Data_in(i, 6)                                                                               /Data_in(i, 9); %#ok<AGROW> % update A 
        Data_out_HQRRP_CPU(i, 3) = 100 * (Data_in(i, 10)+Data_in(i, 11)+Data_in(i, 13)+Data_in(i, 15)+Data_in(i, 16)+Data_in(i, 17)) /Data_in(i, 9); %#ok<AGROW> % QRCP 
        Data_out_HQRRP_CPU(i, 2) = 100 * (Data_in(i, 19)+Data_in(i, 20)+Data_in(i, 21)+Data_in(i, 22)+Data_in(i, 24)+Data_in(i, 26)) /Data_in(i, 9); %#ok<AGROW> % QR 
        Data_out_HQRRP_CPU(i, 1) = 100 * (Data_in(i, 1) + Data_in(i, 2) + Data_in(i, 3) + Data_in(i, 7) + Data_in(i, 8))             /Data_in(i, 9); %#ok<AGROW> % preallocation, SKOP, downdating, update sketch, other

    end

    color_array = {'b', 'r', 'g', 'm', 'c', 'k', 'y', [0.5, 0.5, 0.5], [1, 0.647, 0]};

    bplot = bar(Data_out_HQRRP_CPU,'stacked');
    bplot(1).FaceColor = color_array{1};
    bplot(2).FaceColor = color_array{2};
    bplot(3).FaceColor = color_array{3};
    bplot(4).FaceColor = color_array{4};
    bplot(5).FaceColor = color_array{5};
    bplot(6).FaceColor = color_array{6};
    bplot(7).FaceColor = color_array{7};
    bplot(7).FaceColor = color_array{8};
    
    bplot(1).FaceAlpha = 0.8;
    bplot(2).FaceAlpha = 0.8;
    bplot(3).FaceAlpha = 0.8;
    bplot(4).FaceAlpha = 0.8;
    bplot(5).FaceAlpha = 0.8;
    bplot(6).FaceAlpha = 0.8;
    bplot(7).FaceAlpha = 0.8;
    bplot(8).FaceAlpha = 0.8;
    
    ylim([0 100]);
    ax = gca;
    ax.FontSize  = 20; 
    
    if show_labels 
        if mod(plot_position, 2)
            ylabel('runtime (%)', 'FontSize', 20);
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
            lgd=legend('Other', 'QR other', 'QRCP other', 'update M', 'QR compute H', 'QR compute T', 'QRCP compute H', 'QRCP pivoting');
            lgd.FontSize = 20;
            legend('Location','northeastoutside'); 
        case 13
            xticklabels({'', '10', '', '50', '', '250', '', '1000', '', '4000'})
        case 14
            xticklabels({'', '10', '', '50', '', '250', '', '1000', '', '4000'})
    end
end
function[Data_out] = data_preprocessing_best(Data_in, num_col_sizes, numiters)
    
    Data_out = [];
    i = 1;
    Data_out = [];
    while i < num_col_sizes * numiters
        best_speed = intmax;
        best_speed_idx = i;
        for j = 1:numiters
            if Data_in(i, 9) < best_speed
                best_speed = Data_in(i, 9);
                best_speed_idx = i;
            end
            i = i + 1;
        end
        Data_out = [Data_out; Data_in(best_speed_idx, :)]; %#ok<AGROW>
    end
end