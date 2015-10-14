function [x,y,height,width] = compute_rectangle(I,x,y,width,height)
%%% computes rectangle that fits key points best
%  Leroy
%
% ------ INPUT ------
% I : frame of image
% X,Y : column vectors containing coordinates of key points
%
% ------ OUTPUT ------
% x,y : coordinate of top left corner of rectangle that fits key points best
% width,height: width and height of rectangle
% 