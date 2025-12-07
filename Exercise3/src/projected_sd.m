clear; clc; close all;

syms x y
f_sym  = (1/3)*x.^2 + 3*y.^2;
gf_sym = gradient(f_sym, [x, y]);

f  = matlabFunction(f_sym,  'Vars', {x, y});
gf = matlabFunction(gf_sym, 'Vars', {x, y});

f_wr  = @(v) f(v(1), v(2));
gf_wr = @(v) gf(v(1), v(2));

% --- Define All Scenarios ---
scenarios = {
    % {x0, gamma, sigma, title_tag}
    {[5; -5], 0.5, 5, 'x0=(5, -5), γ=0.5, s=5'}
    {[-5; 10], 0.1, 15, 'x0=(-5, 10), γ=0.1, s=15'}
    {[8; -10], 0.2, 0.1, 'x0=(8, -10), γ=0.2, s=0.1'}
};
epsilon = 0.01;
maxiter = 50000;
fmin_true = 0;

for i = 1:length(scenarios)
    x0 = scenarios{i}{1};
    gamma = scenarios{i}{2};
    sigma = scenarios{i}{3};
    title_tag = scenarios{i}{4};
    
    % --- Run Algorithm ---
    [xs, fs, k] = projected_steepest_descent(f_wr, gf_wr, x0, gamma, sigma, epsilon, maxiter);
    
    % --- Plotting ---
    figure('Position',[100 + (i-1)*50 100 800 600])
    plot(0:length(fs)-1, fs, 'LineWidth', 2); hold on;
    yline(fmin_true, 'r--', 'LineWidth', 1.5);
    grid on
    
    xlabel('Iteration k')
    ylabel('f(x_k)')
    title('Projected Steepest Descent ', title_tag)
    
    fprintf("--- %s ---\n", title_tag);
    fprintf("Iterations: %d\n", k);
    fprintf("Final point: (%.6f, %.6f)\n", xs(1,end), xs(2,end))
    fprintf("f_min = %.6f\n\n", fs(end));
    hold off;
end

function x_proj = project_to_box(x)
    lower_bounds = [-10; -8];
    upper_bounds = [5; 12];
    
    x_proj(1, 1) = max(lower_bounds(1), min(x(1), upper_bounds(1)));
    x_proj(2, 1) = max(lower_bounds(2), min(x(2), upper_bounds(2)));
end

function [xs, fs, k] = projected_steepest_descent(f, gf, x0, gamma, sigma, epsilon, maxiter)

    xs = x0;
    fs = f(x0);

    for k = 1:maxiter
        xk = xs(:,end);
        gk = gf(xk);
        xk_proj = project_to_box(xk - sigma*gk);
        x_new = xk + gamma * (xk_proj - xk);

        xs(:,end+1) = x_new;
        fs(end+1) = f(x_new);

        if norm(gk) < epsilon
            return;
        end
    end
end
