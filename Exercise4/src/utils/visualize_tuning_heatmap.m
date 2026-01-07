function visualize_tuning_heatmap(cross_vals, mut_vals, mse_matrix, save_path)

    h_fig = figure('Name', 'Tuning: Hyperparameters Heatmap');
    
    imagesc(cross_vals, mut_vals, mse_matrix);
    
    colorbar;
    colormap jet;
    
    xlabel('Crossover Probability');
    ylabel('Mutation Probability');
    title('Validation MSE (Blue is Better)');
    
    set(gca, 'XTick', cross_vals);
    set(gca, 'YTick', mut_vals);
    axis xy;
    
    if nargin >= 4 && ~isempty(save_path)
        folder = fileparts(save_path);
        if ~isempty(folder) && ~exist(folder, 'dir')
            mkdir(folder);
        end
        saveas(h_fig, save_path);
        close(h_fig);
    end
end
