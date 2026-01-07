function [best_cross, best_mut] = tune_hyperparameters(u1_t, u2_t, y_t, u1_v, u2_v, y_v, base_params, assets_dir)

    fprintf('\n--- Tuning 2: Crossover & Mutation Probabilities ---\n');

    cross_vals = 0.5 : 0.1 : 0.9;
    mut_vals   = 0.05 : 0.05 : 0.25;
    
    results_matrix = zeros(length(mut_vals), length(cross_vals));
    
    tuning_params = base_params;
    tuning_params.generations = 1000;
    tuning_params.pop_size = 100;
    
    total_runs = length(cross_vals) * length(mut_vals);
    count = 0;
    
    best_mse = inf;
    best_cross = 0.7;
    best_mut = 0.1;
    
    for c = 1:length(cross_vals)
        for m = 1:length(mut_vals)
            count = count + 1;
            
            p_c = cross_vals(c);
            p_m = mut_vals(m);
            
            tuning_params.crossover_prob = p_c;
            tuning_params.mutation_prob = p_m;
            
            fprintf('[%d/%d] Testing Cross=%.2f, Mut=%.2f... ', count, total_runs, p_c, p_m);
            
            [sol, ~, ~] = ga(u1_t, u2_t, y_t, tuning_params);
            
            y_pred = evaluate_gaussians(sol, u1_v, u2_v);
            val_mse = mean((y_pred - y_v).^2);
            
            results_matrix(m, c) = val_mse;
            
            if val_mse < best_mse
                best_mse = val_mse;
                best_cross = p_c;
                best_mut = p_m;
            end
            
            fprintf('MSE: %.5f\n', val_mse);
        end
    end
    
    fprintf('>>> Best Parameters: Cross=%.2f, Mut=%.2f\n', best_cross, best_mut);

    save_path = fullfile(assets_dir, 'tuning_heatmap.png');
    visualize_tuning_heatmap(cross_vals, mut_vals, results_matrix, save_path);
end
