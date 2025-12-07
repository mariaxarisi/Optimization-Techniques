[x, y] = meshgrid(linspace(-12, 12, 400), linspace(-12, 12, 400));
f = (1/3) * x.^2 + 3 * y.^2;

x_min = 0;
y_min = 0;
f_min = 0;

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
contourf(x, y, f, 30);
colormap jet;
colorbar;
hold on;
plot(x_min, y_min, 'rx', 'MarkerSize', 10, 'LineWidth', 2);
title('Contour Plot of f(x,y)');
xlabel('x'); ylabel('y');
