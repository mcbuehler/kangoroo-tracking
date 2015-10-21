function [X,Y,descriptors] = find_keypoints(I,x,y,width,height)
%%% finds key points withing the rectangle defined by (x,y,width,height) in image I
% 
% TODO: find our or ev. ask Massimo: how many keypoints needed -> n=?
%
% Alex
%
% ------ INPUT ------
% I : frame of image
% x,y : coordinates of top left point of rectange
% width,height : width and height of rectangle
%
% ------ OUTPUT ------
% X,Y : column vectors with n most significant key points withing rectangle
% descriptors : matrix (dimensions 128xn) containing the sift descriptors
% for the n key points in (X,Y)
% 
%%
n = 50;

% You have to return these variables:
X = zeros(n,1);
Y = zeros(n,1);

% compute sift descriptors for image area using Gaussian variance s^2 - .25
% (s is scale)
binSize = 8 ;
magnif = 3 ;
[f,d] = vl_dsift(vl_imsmooth(I,sqrt((binSize/magnif)^2 - .25)),'bounds',[x y x+width y+height ],'norm');

% extract the n keypoints with highest contrast
[f_sorted,sorted_i] = sort(f(3,:),'descend');
biggest = sorted_i(1:50);

% assign result vars
X = f_sorted(1,biggest)';
Y = f_sorted(2,biggest)';
descriptors = d(:,biggest)

return
