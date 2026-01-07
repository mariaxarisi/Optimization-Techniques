function [best_sol, best_mse, mse_history] = ga(u1, u2, y, params)

    pop_size      = params.pop_size;
    generations   = params.generations;
    
    % Initialize population
    pop = init_population(params);
    
    global_best_mse = inf;
    global_best_sol = [];
    mse_history = zeros(generations, 1);
    
    for gen = 1:generations
        
        % Fitness Calculation
        [fit_scores, best_idx, current_min_mse] = fitness(pop, u1, u2, y);
        
        % Update Global Best (Elitism Tracking)
        if current_min_mse < global_best_mse
            global_best_mse = current_min_mse;
            global_best_sol = pop(best_idx, :);
        end
        mse_history(gen) = global_best_mse;
        
        % Selection (Roulette Wheel)
        parents = selection(pop, fit_scores, pop_size);
        
        % Crossover
        offspring = crossover(parents, params.crossover_prob);
        
        % Mutation
        offspring = mutation(offspring, params);
                             
        % Apply Elitism (Force best solution into next gen)
        offspring(1, :) = global_best_sol;
        
        pop = offspring;
    end
    
    best_sol = global_best_sol;
    best_mse = global_best_mse;
    
end
