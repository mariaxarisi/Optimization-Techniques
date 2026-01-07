function visualize_surface_comparison(true_f, chromosome, mse, save_path)

    [U1_grid, U2_grid] = meshgrid(linspace(-1, 2, 50), linspace(-2, 1, 50));
    u1_flat = U1_grid(:);
    u2_flat = U2_grid(:);
    
    Y_true_grid = reshape(true_f(u1_flat, u2_flat), size(U1_grid));
    
    y_pred_flat = evaluate_gaussians(chromosome, u1_flat, u2_flat);
    Y_pred_grid = reshape(y_pred_flat, size(U1_grid));
    
    h_fig = figure('Name', 'Model Comparison', 'Position', [100, 100, 1000, 400]);
    
    subplot(1, 2, 1);
    surf(U1_grid, U2_grid, Y_true_grid);
    title('True Function');
    xlabel('u_1'); ylabel('u_2'); zlabel('y');
    shading interp; colormap jet;
    
    subplot(1, 2, 2);
    surf(U1_grid, U2_grid, Y_pred_grid);
    title(sprintf('GA Approximation (MSE: %.4f)', mse));
    xlabel('u_1'); ylabel('u_2'); zlabel('y');
    shading interp; colormap jet;

    if nargin >= 4 && ~isempty(save_path)
        
        folder = fileparts(save_path);
        if ~isempty(folder) && ~exist(folder, 'dir')
            mkdir(folder);
        end
        
        saveas(h_fig, save_path);
        close(h_fig);
    end

end
