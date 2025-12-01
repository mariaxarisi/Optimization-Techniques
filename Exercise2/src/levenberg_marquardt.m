clear; clc; close all;

syms x y

f_sym  = x^3*exp(-x^2 - y^4);
gf_sym = gradient(f_sym, [x, y]);
hf_sym = hessian(f_sym, [x, y]);

f  = matlabFunction(f_sym,  'Vars', {x, y});
gf = matlabFunction(gf_sym, 'Vars', {x, y});
hf = matlabFunction(hf_sym, 'Vars', {x, y});

f_wr  = @(v) f(v(1), v(2));
gf_wr = @(v) gf(v(1), v(2));
hf_wr = @(v) hf(v(1), v(2));

% True minimum value of f(x,y)
fmin_true = -0.4098908;

% Starting points
starts = {[0;0], [-1;-1], [1;1]};
names = {'init=[0 0]', 'init=[-1 -1]', 'init=[1 1]'};

epsilon = 1e-2;
maxiter = 50000;

gamma_fixed = 0.1;

% Create big figure
figure('Position',[100 100 1200 900])
tiledlayout(3,3, 'Padding', 'compact', 'TileSpacing', 'compact')

for s = 1:3
    x0 = starts{s};
    fprintf("\n-----------Starting point: (%d, %d)-----------\n", x0(1), x0(2))

    % ---- 1) Fixed Step ----
    [xs_fix, fs_fix, k_fix] = levenberg_marquardt_fixedstep( f_wr, gf_wr, hf_wr, x0, gamma_fixed, 0.1, epsilon, maxiter);
    fprintf("-----------Fixed Step-----------\n")
    fprintf("Iterations: %d\n", k_fix);
    fprintf("Mininum f(%.6f, %.6f) = %.6f\n", xs_fix(1, end), xs_fix(2, end), fs_fix(end))

    % ---- 2) Optimal Step ----
    [xs_opt, fs_opt, k_opt] = levenberg_marquardt_optimal( f_wr, gf_wr, hf_wr, x0, 0.1, epsilon, maxiter);
    fprintf("-----------Optimal Step-----------\n")
    fprintf("Iterations: %d\n", k_opt);
    fprintf("Mininum f(%.6f, %.6f) = %.6f\n", xs_opt(1, end), xs_opt(2, end), fs_opt(end))

    % ---- 3) Armijo Step ----
    [xs_arm, fs_arm, k_arm] = levenberg_marquardt_armijo(f_wr, gf_wr, hf_wr, x0, gamma_fixed, 0.01, 0.3, 0.1, epsilon, maxiter);
    fprintf("-----------Armijo Step-----------\n")
    fprintf("Iterations: %d\n", k_arm);
    fprintf("Mininum f(%.6f, %.6f) = %.6f\n", xs_arm(1, end), xs_arm(2, end), fs_arm(end));


    % ---------- PLOTTING ----------
    nexttile
    plot(0:length(fs_fix)-1, fs_fix, 'LineWidth', 1.5); hold on;
    yline(fmin_true, 'r--', 'LineWidth', 1.8);
    grid on
    title([names{s} ' | fixed'])
    xlabel('Iteration k'); ylabel('f_k')
    hold off
    
    nexttile
    plot(0:length(fs_opt)-1, fs_opt, 'LineWidth', 1.5); hold on;
    yline(fmin_true, 'r--', 'LineWidth', 1.8);
    grid on
    title([names{s} ' | optimal'])
    xlabel('Iteration k'); ylabel('f_k')
    hold off
    
    nexttile
    plot(0:length(fs_arm)-1, fs_arm, 'LineWidth', 1.5); hold on;
    yline(fmin_true, 'r--', 'LineWidth', 1.8);
    grid on
    title([names{s} ' | armijo'])
    xlabel('Iteration k'); ylabel('f_k')
    hold off

end

sgtitle('Levenberg - Marquardt: Convergence of objective function','FontSize',16)


function [xs, fs, k] = levenberg_marquardt_fixedstep( f, gf, hf, x0, gamma, mk, epsilon, maxiter)

    xs = x0;
    fs = f(x0);

    for k = 1:maxiter
        xk = xs(:,end);
        gk = gf(xk);
        hk = hf(xk);
        [hk_lm, mk] = ensure_positive_definite(hk, mk);
        dk = - hk_lm \ gk; 
        x_new = xk + gamma * dk;

        xs(:,end+1) = x_new;
        fs(end+1) = f(x_new);

        if norm(gk) < epsilon
            return;
        end
    end
end

function [xs, fs, k] = levenberg_marquardt_optimal(f, gf, hf, x0, mk, epsilon, maxiter)

    xs = x0;
    fs = f(x0);

    for k = 1:maxiter
        xk = xs(:,end);
        gk = gf(xk);
        hk = hf(xk);
        [hk_lm, mk] = ensure_positive_definite(hk, mk);
        dk = - hk_lm \ gk; 

        phi = @(gamma) f(xk + gamma * dk);
        gamma_opt = fminbnd(phi, 0, 2);

        x_new = xk + gamma_opt * dk;

        xs(:,end+1) = x_new;
        fs(end+1) = f(x_new);

        if norm(gk) < epsilon
            return;
        end
    end
end

function [xs, fs, k] = levenberg_marquardt_armijo(f, gf, hf, x0, sigma, alpha, beta, mk, epsilon, maxiter)

    xs = x0;
    fs = f(x0);

    for k = 1:maxiter
        xk = xs(:,end);
        gk = gf(xk);
        hk = hf(xk);
        [hk_lm, mk] = ensure_positive_definite(hk, mk);
        dk = - hk_lm \ gk;  
        
        prod = gk'*dk;
        m_arm = 0;

        while true
            gamma_cand = sigma * beta^mk;

            % Armijo condition
            if f(xk + gamma_cand * dk) <= f(xk) + alpha * gamma_cand * prod
                gamma = gamma_cand;
                break;
            end

            m_arm = m_arm + 1;
            if m_arm > 2000
                gamma = gamma_cand;
                break;
            end
        end

        x_new = xk + gamma * dk;

        xs(:,end+1) = x_new;
        fs(end+1) = f(x_new);

        if norm(gk) < epsilon
            return;
        end
    end
end

function [hfx_lm, mk] = ensure_positive_definite(hfx, mk)
    n = size(hfx, 1);
    hfx = 0.5*(hfx + hfx.');
    hfx_lm = hfx + mk*eye(n);
    
    while true
        [~, p] = chol(hfx_lm);
        if p == 0
            break;
        end
        mk = mk * 1.5;
        if mk > 1e20
            error('ensure_positive_definite: damping grew too large');
        end
        hfx_lm = hfx + mk*eye(n);
    end
end
