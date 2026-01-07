function offspring = crossover(parents, cross_prob)
    [num_parents, ~] = size(parents);
    offspring = parents;
    
    for i = 1:2:num_parents-1
        if rand < cross_prob
            p1 = parents(i, :);
            p2 = parents(i+1, :);
            
            alpha = rand;
            
            offspring(i, :)   = alpha * p1 + (1-alpha) * p2;
            offspring(i+1, :) = alpha * p2 + (1-alpha) * p1;
        end
    end
end
