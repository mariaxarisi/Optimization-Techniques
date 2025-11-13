%% ==================== DICHOTOMY WITH DERIVATIVE ====================
function [min_x, min_f, num_calculations, k, ak_vector, bk_vector] = dichotomy_derivative(f, df, a, b, l)

    k = 1;
    ak_vector = a;
    bk_vector = b;
    num_calculations = 0;

    while (b - a) > l
        c = (a + b)/2;
        dfx = df(c);
        num_calculations = num_calculations + 1;

        if dfx > 0
            b = c;
        elseif dfx < 0
            a = c;
        else
            a = c;
            b = c;
        end

        ak_vector = [ak_vector, a];
        bk_vector = [bk_vector, b];
        k = k + 1;
    end

    min_x = (a+b)/2;
    min_f = f(min_x);
end

%% ==================== EXERCISE 4 - DICHOTOMY WITH DERIVATIVE ====================

clear; clc; close all;

% Given functions
f1 = @(x) 5.^x + (2 - cos(x)).^2;
f2 = @(x) (x - 1).^2 + exp(x - 5)*sin(x + 3);
f3 = @(x) exp(-3 * x) - (sin(x - 2) - 2).^2;
% Derivative functions
df1 = @(x) 5.^x * log(5) + 2 * (2 - cos(x)) .* sin(x);
df2 = @(x) 2*(x-1) + exp(x-5) .* (sin(x+3) + cos(x+3));
df3 = @(x) -3*exp(-3*x) - 2 * (sin(x-2)-2) .* cos(x-2);

% Initial interval
a = -1; 
b = 3;

%% === PART 1: Effect of final interval width l on function evaluations ===

ls = 0.005:0.005:0.1;

num_eval_l = zeros(length(ls), 3);

for i = 1:length(ls)
    [~, ~, num_eval_l(i,1)] = dichotomy_derivative(f1, df1, a, b, ls(i));
    [~, ~, num_eval_l(i,2)] = dichotomy_derivative(f2, df2, a, b, ls(i));
    [~, ~, num_eval_l(i,3)] = dichotomy_derivative(f3, df3, a, b, ls(i));
end

% --- Plot results ---
figure;
hold on;
plot(ls, num_eval_l(:,1), '-or', 'MarkerFaceColor','r', 'LineWidth',1.4, 'DisplayName','f_1(x)');
plot(ls, num_eval_l(:,2), '-sg', 'MarkerFaceColor','g', 'LineWidth',1.4, 'DisplayName','f_2(x)');
plot(ls, num_eval_l(:,3), '-^b', 'MarkerFaceColor','b', 'LineWidth',1.4, 'DisplayName','f_3(x)');
xlabel('Final interval width l');
ylabel('Number of function evaluations');
title('Dichotomy with Derivative Method: Variation of evaluations with l');
legend('Location','northeast');
grid on;
hold off;

%% === PART 2: Interval endpoints as functions of iteration index ===

L = [0.005, 0.01, 0.1];

for j = 1:length(L)
    l = L(j);

    [~, ~, ~, k1, ak1, bk1] = dichotomy_derivative(f1, df1, a, b, l);
    [~, ~, ~, k2, ak2, bk2] = dichotomy_derivative(f2, df2, a, b, l);
    [~, ~, ~, k3, ak3, bk3] = dichotomy_derivative(f3, df3, a, b, l);

    figure;

    % --- Plot for f1 ---
    subplot(3,1,1);
    plot(0:k1-1, ak1, '-sg', 'MarkerFaceColor','g', 'DisplayName','a_k');
    hold on;
    plot(0:k1-1, bk1, '-^m', 'MarkerFaceColor','m', 'DisplayName','b_k');
    xlabel('Iteration index k');
    ylabel('Interval endpoints');
    title(sprintf('f_1(x), l = %.3f', l));
    legend; grid on;

    % --- Plot for f2 ---
    subplot(3,1,2);
    plot(0:k2-1, ak2, '-sg', 'MarkerFaceColor','g', 'DisplayName','a_k');
    hold on;
    plot(0:k2-1, bk2, '-^m', 'MarkerFaceColor','m', 'DisplayName','b_k');
    xlabel('Iteration index k');
    ylabel('Interval endpoints');
    title(sprintf('f_2(x), l = %.3f', l));
    legend; grid on;

    % --- Plot for f3 ---
    subplot(3,1,3);
    plot(0:k3-1, ak3, '-sg', 'MarkerFaceColor','g', 'DisplayName','a_k');
    hold on;
    plot(0:k3-1, bk3, '-^m', 'MarkerFaceColor','m', 'DisplayName','b_k');
    xlabel('Iteration index k');
    ylabel('Interval endpoints');
    title(sprintf('f_3(x), l = %.3f', l));
    legend; grid on;
end
