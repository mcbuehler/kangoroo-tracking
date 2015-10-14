function [X,Y] = find_keypoints(I,x,y,width,height)
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
% 
%%
n = 50;

% You have to return these variables:
X = zeros(n,1);
Y = zeros(n,1);


return
