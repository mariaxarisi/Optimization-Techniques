function visualize_data(u1, u2, y, save_path)

    h_fig = figure;
    scatter3(u1, u2, y, 'filled');
    grid on;

    title(sprintf('Training Data Distribution (N=%d)', length(u1)));
    xlabel('u1'); ylabel('u2'); zlabel('y');

    if nargin >= 4 && ~isempty(save_path)
        
        folder = fileparts(save_path);
        if ~isempty(folder) && ~exist(folder, 'dir')
            mkdir(folder);
        end
        
        saveas(h_fig, save_path);
        close(h_fig);
    end
    
end
