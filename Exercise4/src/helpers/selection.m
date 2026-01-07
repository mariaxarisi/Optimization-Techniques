function parents = selection(pop, fitness, num_parents)

    [pop_size, num_genes] = size(pop);


    f_min = min(fitness);
    f_max = max(fitness);
    
    if (f_max - f_min) < 1e-6
        scaled_fitness = ones(size(fitness)); 
    else
        scaled_fitness = (fitness - f_min) ./ (f_max - f_min) + eps;
    end

    total_fitness = sum(scaled_fitness);
    probs = scaled_fitness / total_fitness;
    cum_probs = cumsum(probs);

    parents = zeros(num_parents, num_genes);
    
    for i = 1:num_parents
        r = rand();
        
        selected_idx = find(cum_probs >= r, 1);
        
        if isempty(selected_idx)
            selected_idx = pop_size;
        end
        
        parents(i, :) = pop(selected_idx, :);
    end
end
