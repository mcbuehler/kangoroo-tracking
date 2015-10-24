function [x_vec, y_vec] = get_avg_movement(X_o,X_n,Y_o,Y_n)

x_vec = mean(sum(X_n - X_o));
y_vec = mean(sum(Y_n - Y_o));
end