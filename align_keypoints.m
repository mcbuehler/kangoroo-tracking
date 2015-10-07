function [x_old,y_old,x_new,x_new] = align_keypoints(old_frame,new_frame,x,y)
%% Finds matching key points in new_frame
% x and y are column vectors, e.g. x = [ 1 2 3 4]', y = [2 4 3 5]'
% e.g. The first key point is (x(1),y(1))
% Not all key points are aligned. if the matching value is below a
% threshold, it is discarded.
% in a second step implement the alignment for n old_frames (e.g. 4 frames)
% in order to improve matching in case of occlusion
% output mapping: the point at
x_old = x;
y_old = y;
return