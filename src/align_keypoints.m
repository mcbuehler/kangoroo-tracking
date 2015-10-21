function [X_n,Y_n] = align_keypoints(I_o,I_n,X_o,Y_o,descriptors)
%% Finds matching key points in new_frame
% Not all key points are aligned. if the matching value is below a
% threshold, it is discarded and the new coordinates are (0,0).
% in a second step implement the alignment for n old_frames (e.g. 4 frames)
% in order to improve matching in case of occlusion
% ------ INPUT ------
% I_o : previous frame
% I_n : subsequent frame
% X_o,Y_o : column vectors containing the n most significant key points for
% a certain object in I_o
%
% ------ OUTPUT ------
% X_n,Y_n : coordinates of new key points in I_n or -1,-1 for not aligned
% key points
m = length(X_o);
X_n = zeros(m,1);
Y_n = zeros(m,1);

% for all key points
for i = 1 : m
    [x_new, y_new] = find_best_match(I_o,I_n,X_o(i),Y_o(i),descriptors);
    X_n(i) = x_new;
    Y_n(i) = y_new;
end

return