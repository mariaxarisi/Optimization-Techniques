function pop = init_population(params)

    pop_size = params.pop_size;
    num_gaussians = params.num_gaussians;
    w_rng = params.w_range;
    c1_rng = params.c1_range;
    c2_rng = params.c2_range;
    s_rng = params.sigma_range;

    pop = zeros(pop_size, num_gaussians*5);
    
    for i = 1:num_gaussians
        idx = (i-1)*5;
        % w
        pop(:, idx+1) = w_rng(1) + (w_rng(2)-w_rng(1)) * rand(pop_size, 1);
        % c1
        pop(:, idx+2) = c1_rng(1) + (c1_rng(2)-c1_rng(1)) * rand(pop_size, 1);
        % sigma1
        pop(:, idx+3) = s_rng(1)  + (s_rng(2)-s_rng(1))  * rand(pop_size, 1);
        % c2
        pop(:, idx+4) = c2_rng(1) + (c2_rng(2)-c2_rng(1)) * rand(pop_size, 1);
        % sigma2
        pop(:, idx+5) = s_rng(1)  + (s_rng(2)-s_rng(1))  * rand(pop_size, 1);
    end
end
