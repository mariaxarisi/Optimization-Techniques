clear; clc; close all;
rng(2);

root_dir = fileparts(mfilename('fullpath'));
addpath(fullfile(root_dir, 'utils'));
addpath(fullfile(root_dir, 'helpers'));
assets_dir = fullfile(root_dir, 'assets');

true_f = @(u1, u2) sin(u1 + u2) .* sin(u2.^2);

fprintf('Generating Data...\n');
[u1_train, u2_train, y_train] = generate_data(true_f, 300);
[u1_val, u2_val, y_val]       = generate_data(true_f, 150);
visualize_data(u1_train, u2_train, y_train, fullfile(assets_dir, 'train_data.png'));

% GA Configuration
params = struct();
params.pop_size       = 100;
params.num_gaussians  = 5;
params.generations    = 3000;
params.c1_range       = [-1, 2];
params.c2_range       = [-2, 1];
params.w_range        = [-10, 10];
params.sigma_range    = [0.2, 1.5];
params.crossover_prob = 0.6;
params.mutation_prob  = 0.1;
params.mutation_noise = 0.1;

% Tune number of Gaussians
optimal_n = tune_complexity(u1_train, u2_train, y_train, ...
                            u1_val, u2_val, y_val, params, assets_dir);
params.num_gaussians = optimal_n;

% Tune crossover and mutation probabilities
[opt_cross, opt_mut] = tune_hyperparameters(u1_train, u2_train, y_train, ...
                                            u1_val, u2_val, y_val, params, assets_dir);
params.crossover_prob = opt_cross;
params.mutation_prob  = opt_mut;

% Genetic Algorithm
fprintf('\n--- Starting Final Run with Optimized Parameters ---\n');
fprintf('Gaussians: %d | Cross: %.2f | Mut: %.2f\n', ...
        params.num_gaussians, params.crossover_prob, params.mutation_prob);
[best_sol, train_mse, history] = ga(u1_train, u2_train, y_train, params);

% Validation
y_val_pred = evaluate_gaussians(best_sol, u1_val, u2_val);
val_mse = mean((y_val_pred - y_val).^2);

fprintf('\n--- Results ---\n');
fprintf('Training MSE:   %.6f\n', train_mse);
fprintf('Validation MSE: %.6f\n', val_mse);

visualize_convergence(history, fullfile(assets_dir, 'mse_convergence.png'));
visualize_surface_comparison(true_f, best_sol, val_mse, fullfile(assets_dir, 'comparison.png'));
