function [u1, u2, y] = generate_data(func_handle, num_samples)

    u1_min = -1;
    u1_max =  2;
    
    u2_min = -2;
    u2_max =  1;
    
    u1 = u1_min + (u1_max - u1_min) * rand(num_samples, 1);
    u2 = u2_min + (u2_max - u2_min) * rand(num_samples, 1);
    
    y = func_handle(u1, u2);

end
