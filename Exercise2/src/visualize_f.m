[x, y] = meshgrid(linspace(-3, 3, 300), linspace(-3, 3, 300));
f = x.^3 .* exp(-x.^2 - y.^4);

% Minimum point
x_min = -1.224570;
y_min = -0.08876589;
f_min = -0.4098908;

% --- 3D Surface Plot ---
figure;
surf(x, y, f);
shading interp;
colormap jet;
colorbar;
hold on;
plot3(x_min, y_min, f_min, 'rx', 'MarkerSize', 10, 'LineWidth', 2);
title('3D Surface Plot of f(x,y)');
xlabel('x'); ylabel('y'); zlabel('f(x,y)');

% --- Contour Plot ---
figure;
contourf(x, y, f, 40);
colormap jet;
colorbar;
hold on;
plot(x_min, y_min, 'rx', 'MarkerSize', 10, 'LineWidth', 2);
title('Contour Plot of f(x,y)');
xlabel('x'); ylabel('y');
