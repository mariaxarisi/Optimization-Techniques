function [fitness, best_idx, min_mse] = fitness(pop, u1, u2, y_true)
    pop_size = size(pop, 1);
    fitness = zeros(pop_size, 1);
    mses = zeros(pop_size, 1);

    for i = 1:pop_size
        y_pred = evaluate_gaussians(pop(i,:), u1, u2);
        
        mses(i) = mean((y_pred - y_true).^2);
        
        fitness(i) = 1 / (1 + mses(i));
    end
    
    [~, best_idx] = max(fitness);
    min_mse = mses(best_idx);
end
