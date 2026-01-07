function visualize_convergence(mse_history, save_path)

    h_fig = figure('Name', 'GA Convergence');
    plot(mse_history, 'LineWidth', 2);
    xlabel('Generations'); ylabel('Mean Squared Error (MSE)');
    title('Optimization Progress');
    grid on; set(gca, 'YScale', 'log');

    if nargin >= 2 && ~isempty(save_path)
        
        folder = fileparts(save_path);
        if ~isempty(folder) && ~exist(folder, 'dir')
            mkdir(folder);
        end
        
        saveas(h_fig, save_path);
        close(h_fig);
    end

end
