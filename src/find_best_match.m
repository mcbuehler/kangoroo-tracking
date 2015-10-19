function [x_n,y_n] = find_best_match(I_o,I_n,x_o,y_o)
%% Finds best match for key point in new_frame
% Not all key points are aligned. if the matching value is below a
% threshold, it is discarded and the new coordinates are (0,0).
% ------ INPUT ------
% I_o : previous frame
% I_n : subsequent frame
% x_o,y_o : x and y coordinates of key point in old frame (I_o)
%
% ------ OUTPUT ------
% x_n,y_n : coordinates of new key point in I_n or -1 for both if no
% suitable match could be found.

x_n = -1;
y_n = -1;

% for now set threshold to certain value. will probably have to be adjusted
threshold = 0.8;

% for now chosing windows size of 2
neighbours = get_neighbourhood(x_o,y_o,2);

scores = calculate_similarity_score(I_o,I_n,neighbours(:,1),neighbours(:,2));

[max_score,index] = max(scores)

if max_score >= threshold
    x_n = neighbours(index,1);
    y_n = neighbours(index,2);
end

return