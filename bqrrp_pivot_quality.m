function[] = bqrrp_pivot_quality(filename1, filename2, dim, show_labels)
    Data_in_r_norm    = readfile(filename1, 6);
    Data_in_sv_ratio  = readfile(filename2, 6);

    tiledlayout(2, 2,"TileSpacing","tight");
    nexttile
    plot_r_norm(Data_in_r_norm(1, :), dim, 1, show_labels, 10^5)
    nexttile
    plot_r_norm(Data_in_r_norm(2, :), dim, 2, show_labels, 10^5)
    nexttile
    plot_sv_ratio(Data_in_sv_ratio(1:2, :), dim, 3, show_labels, 10^10)
    nexttile
    plot_sv_ratio(Data_in_sv_ratio(3:4, :), dim, 4, show_labels, 10^10)
end

function[] = plot_sv_ratio(Data_in, dim, plot_position, show_labels, y_lim)

    semilogy( Data_in(1, 1:dim), '', 'Color', 'red', "MarkerSize", 1.8,'LineWidth', 2.0)
    hold on
    semilogy( Data_in(2, 1:dim), '', 'Color', 'blue', "MarkerSize", 1.8,'LineWidth', 2.0)
    ax = gca;
    ax.XAxis.FontSize = 20;
    ax.YAxis.FontSize = 20;
    grid on 
    xlim([0 dim]);
    ylim([0 y_lim]);

    if show_labels 
        switch plot_position
            case 3
                ylabel('R[k, k]/sigma[k]', 'FontSize', 20);
                xlabel('k', 'FontSize', 20);
            case 4
                xlabel('k', 'FontSize', 20);
        end
    end

    switch plot_position
        case 3
        case 4
            set(gca,'Yticklabel',[])
            lgd=legend('GEQP3', 'BQRRP');
            lgd.FontSize = 20;
            legend('Location','northwest'); 
    end

    xticks([4000 12000]);
end

        
function[] = plot_r_norm(Data_in, dim, plot_position, show_labels, y_lim)
    
    semilogy( Data_in(1, 1:dim), '-o', 'Color', 'black', "MarkerSize", 1.8,'LineWidth', 2.0)
    ax = gca;
    ax.XAxis.FontSize = 20;
    ax.YAxis.FontSize = 20;
    grid on 
    xlim([0 dim]);
    ylim([10^-15 y_lim]);

    if show_labels 
        switch plot_position
            case 1
                ylabel('||R_{qp3}[k+1:,:]||/||R_{cqrrp}[k+1:,:]||', 'FontSize', 20);
                title('BQRRP b = 64', 'FontSize', 20);
            case 2
                title('BQRRP b = 4086', 'FontSize', 20); 
        end
    end

    switch plot_position
        case 1
            set(gca,'Xticklabel',[])
        case 2
            set(gca,'Xticklabel',[])
            set(gca,'Yticklabel',[])
    end
end