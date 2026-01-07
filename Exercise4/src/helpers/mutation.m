function pop = mutation(pop, params)
    
    pop_size = params.pop_size;
    num_genes = params.num_gaussians*5;
    mut_prob = params.mutation_prob;
    mut_noise = params.mutation_noise;
    w_r = params.w_range;
    c1_r = params.c1_range;
    c2_r = params.c2_range;
    s_r = params.sigma_range;
    
    for i = 1:pop_size
        for j = 1:num_genes
            if rand < mut_prob

                noise = mut_noise * randn; 
                val = pop(i, j) + noise;
                
                param_type = mod(j-1, 5) + 1;
                
                switch param_type
                    case 1 % w
                        val = max(w_r(1), min(w_r(2), val));
                    case 2 % c1
                        val = max(c1_r(1), min(c1_r(2), val));
                    case 3 % s1
                        val = max(s_r(1), min(s_r(2), val));
                    case 4 % c2
                        val = max(c2_r(1), min(c2_r(2), val));
                    case 5 % s2
                        val = max(s_r(1), min(s_r(2), val));
                end
                
                pop(i, j) = val;
            end
        end
    end
end
