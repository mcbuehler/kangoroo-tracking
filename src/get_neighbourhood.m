function [neighbouring_points] = get_neighbourhood(x,y,window_size)
%% Returns neighbouring points of x,y
% Returns a window of points around (x,y). If the windows exceeds Image
% borders, no points for those neighbours are returnd.
% ------ INPUT ------
% 
% x,y : x and y coordinates of center point
% window_size : size of window
%       0 -> returns (x,y) only
%       1 -> returns up to 9 points
%       2 -> returns up to 25 points
%       3 -> returns up to 49 points
%
% ------ OUTPUT ------
% neighouring_points : nx2 matrix. first column: x values, second column: y
% values of neighbouring points (including original point)

X = [];
Y = [];

for i = x - window_size : x + window_size
    for j = y - window_size : y + window_size
        if i > 0 && j > 0
            X = [X; i];
            Y = [Y; j];
        end
    end
end

neighbouring_points = [X, Y];

return