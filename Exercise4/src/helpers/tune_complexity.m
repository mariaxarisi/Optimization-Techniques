function best_n = tune_complexity(u1_t, u2_t, y_t, u1_v, u2_v, y_v, base_params, assets_dir)

    fprintf('\n--- Tuning 1: Number of Gaussians ---\n');
    
    n_list = 2:15;
    mse_results = zeros(length(n_list), 1);
    
    tuning_params = base_params;
    tuning_params.generations = 1000;
    tuning_params.pop_size = 100;
    tuning_params.crossover_prob = 0.7;
    tuning_params.mutation_pob = 0.1;
    
    for i = 1:length(n_list)
        n = n_list(i);
        tuning_params.num_gaussians = n;
        
        fprintf('Testing N=%d... ', n);
        
        [sol, ~, ~] = ga(u1_t, u2_t, y_t, tuning_params);
        
        y_pred = evaluate_gaussians(sol, u1_v, u2_v);
        val_mse = mean((y_pred - y_v).^2);
        mse_results(i) = val_mse;
        
        fprintf('Val MSE: %.5f\n', val_mse);
    end
    
    [min_mse, idx] = min(mse_results);
    best_n = n_list(idx);
    
    fprintf('>>> Best Number of Gaussians: %d (MSE: %.5f)\n', best_n, min_mse);

    save_path = fullfile(assets_dir, 'tuning_complexity.png');
    visualize_tuning_complexity(n_list, mse_results, save_path);
end
