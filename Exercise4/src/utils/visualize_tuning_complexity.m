function visualize_tuning_complexity(n_list, mse_results, save_path)

    h_fig = figure('Name', 'Tuning: Number of Gaussians');
    
    plot(n_list, mse_results, '-o', 'LineWidth', 2, 'MarkerFaceColor', 'b');
    xlabel('Number of Gaussians');
    ylabel('Validation MSE');
    title('Model Complexity vs. Error');
    grid on;
    xticks(n_list);
    
    if nargin >= 3 && ~isempty(save_path)
        folder = fileparts(save_path);
        if ~isempty(folder) && ~exist(folder, 'dir')
            mkdir(folder);
        end
        saveas(h_fig, save_path);
        close(h_fig);
    end
end
