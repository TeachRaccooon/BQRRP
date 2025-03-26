function[] = bqrrp_pivot_quality()
    Data_in_r_norm_small    = dlmread('benchmark-output-bqrrp-paper/SapphireRapids/BQRRP_pivot_quality/QR_R_norm_ratios_rows_16384_cols_16384_b_sz_64_d_factor_1.000000.dat');
    Data_in_sv_ratio_small  = dlmread('benchmark-output-bqrrp-paper/SapphireRapids/BQRRP_pivot_quality/QR_sv_ratios_rows_16384_cols_16384_b_sz_64_d_factor_1.000000.dat');
    Data_in_r_norm_large   = dlmread('benchmark-output-bqrrp-paper/SapphireRapids/BQRRP_pivot_quality/QR_R_norm_ratios_rows_16384_cols_16384_b_sz_4096_d_factor_1.000000.dat');
    Data_in_sv_ratio_large = dlmread('benchmark-output-bqrrp-paper/SapphireRapids/BQRRP_pivot_quality/QR_sv_ratios_rows_16384_cols_16384_b_sz_4096_d_factor_1.000000.dat');

    tiledlayout(2, 2,"TileSpacing","tight");
    nexttile
    plot_r_norm(Data_in_r_norm_small, 0, 0);
    nexttile
    plot_r_norm(Data_in_r_norm_large, 0, 1);
    nexttile
    plot_sv_ratio(Data_in_sv_ratio_small, 1, 0);
    nexttile
    plot_sv_ratio(Data_in_sv_ratio_large, 1, 1);

end

function[] = plot_sv_ratio(Data_in, row, col)

    semilogy( Data_in(1, 1:16384), '', 'Color', 'red', "MarkerSize", 1.8,'LineWidth', 2.0)
    hold on
    semilogy( Data_in(2, 1:16384), '', 'Color', 'blue', "MarkerSize", 1.8,'LineWidth', 2.0)
    ax = gca;
    ax.FontSize = 20; 
    grid on    
    xlim([0 16384]);
    ylim([0 10^10]);

    %ylabel('R[k, k]/sigma[k]', 'FontSize', 20);
    %xlabel('k', 'FontSize', 20); 

    if col
        lgd=legend('GEQP3', 'BQRRP');
        lgd.FontSize = 20;
        legend('Location','northwest');
    end
    %xticks([0, 1000, 2000, 3000, 4000]);
    %xticklabels('', '1000', '', '3000', '')
    xticks([4000 12000]);

    if col
        set(gca,'Yticklabel',[])
    end
end

        
function[] = plot_r_norm(Data_in, col, row)
    
    semilogy( Data_in(1, 1:16384), '-o', 'Color', 'black', "MarkerSize", 1.8,'LineWidth', 2.0)
    ax = gca;
    ax.FontSize = 20; 
    grid on
    xlim([0 16384]);
    ylim([10^-15 10^5]);

    %ylabel('||R_{qp3}[k+1:,:]||/||R_{cqrrp}[k+1:,:]||', 'FontSize', 15);
    %xlabel('k', 'FontSize', 20); 

    set(gca,'Xticklabel',[])
    if row
        set(gca,'Yticklabel',[])
    end
end