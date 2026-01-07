function y_pred = evaluate_gaussians(chromosome, u1, u2)

    num_genes = length(chromosome);
    num_gaussians = floor(num_genes / 5);
    
    y_pred = zeros(size(u1));
    
    for i = 1:num_gaussians
        idx = (i-1)*5; 
        
        w  = chromosome(idx + 1);
        c1 = chromosome(idx + 2);
        s1 = chromosome(idx + 3);
        c2 = chromosome(idx + 4);
        s2 = chromosome(idx + 5);
        
        if abs(s1) < 1e-6, s1 = 1e-6; end
        if abs(s2) < 1e-6, s2 = 1e-6; end
        
        term = w .* exp( - ( (u1 - c1).^2 ./ (2*s1^2) + ...
                             (u2 - c2).^2 ./ (2*s2^2) ) );
                         
        y_pred = y_pred + term;
    end
end
