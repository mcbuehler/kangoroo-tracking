function [X_n,Y_n] = align_keypoints(I_o,I_n,X_o,Y_o)
%% Finds matching key points in new_frame
% Not all key points are aligned. if the matching value is below a
% threshold, it is discarded and the new coordinates are (0,0).
% in a second step implement the alignment for n old_frames (e.g. 4 frames)
% in order to improve matching in case of occlusion
% output mapping: the point at%
% ------ INPUT ------
% I_o : previous frame
% I_n : subsequent frame
% X_o,Y_o : column vectors containing the n most significant key points for
% a certain object in I_o
%
% ------ OUTPUT ------
% X_n,Y_n : coordinates of new key points in I_n
m = len(X_o);
X_n = zeros(m,1);
Y_n = zeros(m,1);
return