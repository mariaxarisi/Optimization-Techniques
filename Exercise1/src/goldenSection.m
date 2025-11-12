%% ==================== GOLDEN SECTION METHOD ====================
function [min_x, min_f, num_calculations, k, ak_vector, bk_vector] = golden_section(f, a, b, l)

    phi = (sqrt(5)-1)/2;   % Golden ratio (~0.618)
    k = 1;
    ak_vector = a;
    bk_vector = b;
    num_calculations = 0;

    x1 = b - phi*(b-a);
    x2 = a + phi*(b-a);
    f1 = f(x1);
    f2 = f(x2);
    num_calculations = num_calculations + 2;

    while (b - a) > l
        if f1 < f2
            b = x2;
            x2 = x1;
            f2 = f1;
            x1 = b - phi*(b-a);
            f1 = f(x1);
        else
            a = x1;
            x1 = x2;
            f1 = f2;
            x2 = a + phi*(b-a);
            f2 = f(x2);
        end

        ak_vector = [ak_vector, a];
        bk_vector = [bk_vector, b];
        num_calculations = num_calculations + 1;
        k = k + 1;
    end

    min_x = (a+b)/2;
    min_f = f(min_x);
end

%% ==================== EXERCISE 2 - GOLDEN SECTION ====================

clear; clc; close all;

% Given functions
f1 = @(x) 5.^x + (2 - cos(x)).^2;
f2 = @(x) (x - 1).^2 + exp(x - 5)*sin(x + 3);
f3 = @(x) exp(-3 * x) - (sin(x - 2) - 2).^2;

% Initial interval
a = -1; 
b = 3;

%% === PART 1: Effect of final interval width l on function evaluations ===

ls = 0.005:0.005:0.1;

num_eval_l = zeros(length(ls), 3);

for i = 1:length(ls)
    [~, ~, num_eval_l(i,1)] = golden_section(f1, a, b, ls(i));
    [~, ~, num_eval_l(i,2)] = golden_section(f2, a, b, ls(i));
    [~, ~, num_eval_l(i,3)] = golden_section(f3, a, b, ls(i));
end

% --- Plot results ---
figure;
hold on;
plot(ls, num_eval_l(:,1), '-or', 'MarkerFaceColor','r', 'LineWidth',1.4, 'DisplayName','f_1(x)');
plot(ls, num_eval_l(:,2), '-sg', 'MarkerFaceColor','g', 'LineWidth',1.4, 'DisplayName','f_2(x)');
plot(ls, num_eval_l(:,3), '-^b', 'MarkerFaceColor','b', 'LineWidth',1.4, 'DisplayName','f_3(x)');
xlabel('Final interval width l');
ylabel('Number of function evaluations');
title('Golden Section Method: Variation of evaluations with l');
legend('Location','northeast');
grid on;
hold off;

%% === PART 2: Interval endpoints as functions of iteration index ===

L = [0.005, 0.01, 0.015];

for j = 1:length(L)
    l = L(j);

    [~, ~, ~, k1, ak1, bk1] = golden_section(f1, a, b, l);
    [~, ~, ~, k2, ak2, bk2] = golden_section(f2, a, b, l);
    [~, ~, ~, k3, ak3, bk3] = golden_section(f3, a, b, l);

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
