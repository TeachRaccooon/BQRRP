

Data_in   = readfile('Data_in/2025_02/Zen4c/HQRRP_runtime_breakdown/2025_03_06_HQRRP_runtime_breakdown_num_info_lines_7.txt', 7);
    num_block_sizes = 11;
    numiters = 3;
    num_thread_nums = 7;
    show_labels = 0;
    plot_position = 1;

    format long g
    for j = 1:num_thread_nums
        Data_out = [];
        for i = 1:numiters * num_block_sizes
            new_col = sum(Data_in(((j-1) * numiters * num_block_sizes) + i, 10:17)); 
    
            % Insert after the 17th column
            Data_out(i, :) = Data_in(((j-1) * numiters * num_block_sizes) + i, 9);
        end
        writematrix(Data_out, 'matrix.txt', 'Delimiter', ' ', 'WriteMode', 'append');
        fileID = fopen('matrix.txt', 'a');
        fprintf(fileID, '\n');   % Append newline
        fclose(fileID);
    end

%{
A = [1207700 3102220 0 1398980000 1331130000 13740800 8613110 40839 2756810000 186 480467 126677000 280149 1259630000 11851800 0 58214 1398977816 745 0 0 19130100 1271190000 10 40766600 42295 1331130000 ];

% Sort the array in descending order and get the indices
[~, sorted_indices] = sort(A, 'descend');

% Display the sorted indices (1-based)
disp('Indices from largest to smallest:');
disp(sorted_indices);
%}

%{
Data_in   = readfile('Data_in/2025_02/SapphireRapids/HQRRP_runtime_breakdown/2025_03_09_HQRRP_runtime_breakdown_num_info_lines_7.txt', 7);
    num_block_sizes = 11;
    numiters = 3;
    num_thread_nums = 7;
    show_labels = 0;
    plot_position = 1;

    format long g
    for j = 1:num_thread_nums
        Data_out = [];
        for i = 1:numiters * num_block_sizes
            new_col = sum(Data_in(((j-1) * numiters * num_block_sizes) + i, 10:17)); 
    
            % Insert after the 17th column
            Data_out(i, :) = [Data_in(((j-1) * numiters * num_block_sizes) + i, 1:17) new_col Data_in(((j-1) * numiters * num_block_sizes) + i, 18:end)];
        end
        writematrix(Data_out, 'matrix.txt', 'Delimiter', ' ', 'WriteMode', 'append');
        fileID = fopen('matrix.txt', 'a');
        fprintf(fileID, '\n');   % Append newline
        fclose(fileID);
    end
%}
  