function [x_vec, y_vec] = get_avg_movement(X_o,X_n,Y_o,Y_n)

numPoints = length(X_o);
x_vec = mean(X_n - X_o);
y_vec = mean(Y_n - Y_o);
end