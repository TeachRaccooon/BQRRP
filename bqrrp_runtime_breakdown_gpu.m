function[] = bqrrp_runtime_breakdown_gpu(filename_CQR, filename_HQR, show_labels)
    Data_in_CQR = readfile(filename_CQR, 7);
    Data_in_HQR = readfile(filename_HQR, 7);

    % The test that acquires data uses the following block sizes:
    %{32, 64, 96, 128, 160, 192, 224, 256, 288, 320, 352, 384, 416, 448, 480, 512, 640, 768, 896, 1024, 1152, 1280, 1408, 1536, 1664, 1792, 1920, 2048};
    % We only want to plot powers of two:
    Data_in_CQR = Data_in_CQR([1, 2, 4, 8, 16, 20, 28], :);
    Data_in_HQR = Data_in_HQR([1, 2, 4, 8, 16, 20, 28], :);

    % Vertically stacking BQRRP_CQR and BQRRP_HQR
    tiledlayout(2, 1,"TileSpacing","tight")
    nexttile
    process_and_plot(Data_in_CQR, 1, show_labels)
    nexttile
    process_and_plot(Data_in_HQR, 2, show_labels)
end

function[] = process_and_plot(Data_in, plot_position, show_labels)

    for i = 1:size(Data_in, 1)
        Data_out(i, 6)  = 100 * (Data_in(i, 2) + Data_in(i, 3) + Data_in(i, 4))                                 / Data_in(i, 15); %#ok<AGROW> % QRCP
        Data_out(i, 5)  = 100 * (Data_in(i, 5) + Data_in(i, 6) + Data_in(i, 7) + Data_in(i, 8) + Data_in(i, 9)) / Data_in(i, 15); %#ok<AGROW> % Panel processing
        Data_out(i, 4)  = 100 *  Data_in(i, 10)                                                                 / Data_in(i, 15); %#ok<AGROW> % Tall QR
        Data_out(i, 3)  = 100 *  Data_in(i, 11)                                                                 / Data_in(i, 15); %#ok<AGROW> % Q reconstruction
        Data_out(i, 2)  = 100 *  Data_in(i, 12)                                                                 / Data_in(i, 15); %#ok<AGROW> % Apply Q trans
        Data_out(i, 1)  = 100 * (Data_in(i, 1) + Data_in(i, 13) + Data_in(i, 14))                               / Data_in(i, 15); %#ok<AGROW> % Other
    end

    bplot = bar(Data_out,'stacked');
    bplot(6).FaceColor  = 'blue';
    bplot(5).FaceColor  = 'black';
    bplot(4).FaceColor  = 'red';
    bplot(3).FaceColor  = 'magenta';
    bplot(2).FaceColor  = '#EDB120';
    bplot(1).FaceColor  = 'cyan';
    
    bplot(1).FaceAlpha  = 0.8;
    bplot(2).FaceAlpha  = 0.8;
    bplot(3).FaceAlpha  = 0.8;
    bplot(4).FaceAlpha  = 0.8;
    bplot(5).FaceAlpha  = 0.8;
    bplot(6).FaceAlpha  = 0.8;

    ylim([0 100]);
    ax = gca;
    ax.FontSize  = 20; 
    set(gca,'XTickLabel',{'', '64', '', '256', '', '1024'});

    if show_labels 
        switch plot_position
            case 1
                title('NVIDIA GPU', 'FontSize', 20);
                ylabel('CQR // Runtime %', 'FontSize', 20);
            case 2
                ylabel('HQR // Runtime %', 'FontSize', 20);
                xlabel('block size', 'FontSize', 20); 
        end
    end
    switch plot_position
        case 1
            lgd = legend('Other','Apply Q', 'Reconstruct Q', 'Tall QR', 'Permutation', 'QRCP(M^{sk})');
            lgd.FontSize = 20;
            legend('Location', 'northeastoutside');
            set(gca,'Xticklabel',[])
        case 2
    end
end
