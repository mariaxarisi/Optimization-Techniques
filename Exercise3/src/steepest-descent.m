clear; clc; close all;

syms x y
f_sym  = (1/3)*x.^2 + 3*y.^2;
gf_sym = gradient(f_sym, [x, y]);

f  = matlabFunction(f_sym,  'Vars', {x, y});
gf = matlabFunction(gf_sym, 'Vars', {x, y});

f_wr  = @(v) f(v(1), v(2));
gf_wr = @(v) gf(v(1), v(2));

% Parameters for the exercise
start = [5; 5];
gammas = [0.1, 0.3, 3, 5];
epsilon = 0.01;
maxiter = 50000;
fmin_true = 0;

% ---------- PLOTTING ----------
figure('Position',[100 100 1200 900])
tiledlayout(2,2, 'Padding', 'compact', 'TileSpacing', 'compact')

for i = 1:length(gammas)
    gamma = gammas(i);
    x0 = start;

    fprintf("\n----------- Starting point: (5,5), gamma = %.1f -----------\n", gamma)

    [xs, fs, k] = steepest_descent_fixedstep(f_wr, gf_wr, x0, gamma, epsilon, maxiter);

    fprintf("Iterations: %d\n", k);
    fprintf("Final point: (%.6f, %.6f)\n", xs(1,end), xs(2,end))
    fprintf("f_min = %.6f\n", fs(end));

    nexttile
    plot(0:length(fs)-1, fs, 'LineWidth', 1.5); hold on;
    yline(fmin_true, 'r--', 'LineWidth', 1.5);
    grid on
    xlabel('Iteration k')
    ylabel('f(x_k)')
    title(sprintf('γ = %.1f', gamma))
end

sgtitle('Steepest Descent Convergence', 'FontSize', 16)

function [xs, fs, k] = steepest_descent_fixedstep(f, gf, x0, gamma, epsilon, maxiter)

    xs = x0;
    fs = f(x0);

    for k = 1:maxiter
        xk = xs(:,end);
        gk = gf(xk);
        dk = -gk;
        x_new = xk + gamma * dk;

        xs(:,end+1) = x_new;
        fs(end+1) = f(x_new);

        if norm(gk) < epsilon
            return;
        end
    end
end
