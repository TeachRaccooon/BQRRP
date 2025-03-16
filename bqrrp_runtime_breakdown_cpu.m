function[] = bqrrp_runtime_breakdown_cpu()
    % 65k DATA
    Data_in_CQR_Intel = readfile('Data_in/2025_02/SapphireRapids/BQRRRP_runtime_breakdown/2025_02_19_BQRRP_runtime_breakdown_num_info_lines_7.txt', 7);
    Data_in_HQR_Intel = readfile('Data_in/2025_02/SapphireRapids/BQRRRP_runtime_breakdown/2025_02_07_BQRRP_runtime_breakdown_num_info_lines_7.txt', 7);
    % 448 threads
    Data_in_CQR_AMD   = readfile('Data_in/2025_02/Zen4c/BQRRRP_runtime_breakdown/2025_03_01_BQRRP_runtime_breakdown_num_info_lines_7.txt', 7);
    Data_in_HQR_AMD   = readfile('Data_in/2025_02/Zen4c/BQRRRP_runtime_breakdown/2025_03_02_BQRRP_runtime_breakdown_num_info_lines_7.txt', 7);
    
    % 64k DATA
    %Data_in_CQR_Intel = readfile('Data_in/2025_02/SapphireRapids/BQRRRP_runtime_breakdown/2025_02_15_BQRRP_runtime_breakdown_num_info_lines_7.txt', 7);
    %Data_in_HQR_Intel = readfile('Data_in/2025_02/SapphireRapids/BQRRRP_runtime_breakdown/2025_02_16_BQRRP_runtime_breakdown_num_info_lines_7.txt', 7);
    %Data_in_CQR_AMD  = readfile('Data_in/2025_02/Zen4c/BQRRRP_runtime_breakdown/2025_03_03_BQRRP_runtime_breakdown_num_info_lines_7.txt', 7);
    %Data_in_HQR_AMD  = readfile('Data_in/2025_02/Zen4c/BQRRRP_runtime_breakdown/2025_03_04_BQRRP_runtime_breakdown_num_info_lines_7.txt', 7);

    num_block_sizes = 6;
    numiters = 3;

    show_labels = 0;

    % Vertically stacking BQRRP_CQR and BQRRP_HQR
    % Horizontally stacking Intel and AMD machines
    tiledlayout(2, 2,"TileSpacing","tight")
    nexttile
    process_and_plot(Data_in_CQR_Intel, num_block_sizes, numiters, 1, show_labels)
    nexttile
    process_and_plot(Data_in_CQR_AMD, num_block_sizes, numiters, 2, show_labels)
    nexttile
    process_and_plot(Data_in_HQR_Intel, num_block_sizes, numiters, 3, show_labels)
    nexttile
    process_and_plot(Data_in_HQR_AMD, num_block_sizes, numiters, 4, show_labels)

end

function[] = process_and_plot(Data_in, num_block_sizes, numiters, plot_position, show_labels)

    Data_in = data_preprocessing_best(Data_in, num_block_sizes, numiters);

    for i = 1:size(Data_in, 1)
        Data_out_ICQRRP_CPU(i, 7) = 100 * Data_in(i, 1)                  /Data_in(i, 10); %#ok<AGROW> % SKOP
        Data_out_ICQRRP_CPU(i, 6) = 100 * Data_in(i, 3)                  /Data_in(i, 10); %#ok<AGROW> % QRCP
        Data_out_ICQRRP_CPU(i, 5) = 100 * Data_in(i, 4)                  /Data_in(i, 10); %#ok<AGROW> % Panel processing
        Data_out_ICQRRP_CPU(i, 4) = 100 * Data_in(i, 5)                  /Data_in(i, 10); %#ok<AGROW> % QR tall
        Data_out_ICQRRP_CPU(i, 3) = 100 * Data_in(i, 6)                  /Data_in(i, 10); %#ok<AGROW> % Q reconstruction
        Data_out_ICQRRP_CPU(i, 2) = 100 * Data_in(i, 7)                  /Data_in(i, 10); %#ok<AGROW> % Apply Q trans
        Data_out_ICQRRP_CPU(i, 1) = 100 * (Data_in(i, 2) + Data_in(i, 8) + Data_in(i, 9)) /Data_in(i, 10); %#ok<AGROW> % preallocation, sample update, other
    end

    bplot = bar(Data_out_ICQRRP_CPU,'stacked');

    bplot(1).FaceColor = 'cyan';
    bplot(2).FaceColor = '#EDB120';
    bplot(3).FaceColor = 'magenta';
    bplot(4).FaceColor = 'red';
    bplot(5).FaceColor = 'black';
    bplot(6).FaceColor = 'blue';
    bplot(7).FaceColor = 'green';
    
    bplot(1).FaceAlpha = 0.8;
    bplot(2).FaceAlpha = 0.8;
    bplot(3).FaceAlpha = 0.8;
    bplot(4).FaceAlpha = 0.8;
    bplot(5).FaceAlpha = 0.8;
    bplot(6).FaceAlpha = 0.8;
    bplot(7).FaceAlpha = 0.8;
    
    ylim([0 100]);
    ax = gca;
    ax.FontSize  = 20; 
    set(gca,'XTickLabel',{'', '512', '', '2048', '', '8192'});

    if show_labels 
        switch plot_position
            case 1
                title('Intel CPU', 'FontSize', 20);
                ylabel('CQR // Runtime %', 'FontSize', 20);
            case 2
                title('AMD CPU', 'FontSize', 20);
            case 3
                ylabel('HQR // Runtime %', 'FontSize', 20);
                xlabel('block size', 'FontSize', 20); 
            case 4
                xlabel('block size', 'FontSize', 20); 
        end
    end
    switch plot_position
        case 1
            set(gca,'Xticklabel',[])
        case 2
            lgd = legend('Other','Apply Q', 'Reconstruct Q', 'Tall QR', 'Permutation', 'QRCP(M^{sk})', 'Sketching');
            lgd.FontSize = 20;
            legend('Location', 'northeastoutside');
            %legend('Location', 'northoutside', 'Orientation', 'horizontal');
            %lgd.Position(1) = lgd.Position(1) - 0.1;
            set(gca,'Xticklabel',[])
            set(gca,'Yticklabel',[])
        case 4
            set(gca,'Yticklabel',[])
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
            if Data_in(i, 10) < best_speed
                best_speed = Data_in(i, 10);
                best_speed_idx = i;
            end
            i = i + 1;
        end
        Data_out = [Data_out; Data_in(best_speed_idx, :)]; %#ok<AGROW>
    end
end