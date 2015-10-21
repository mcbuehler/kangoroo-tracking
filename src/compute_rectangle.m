function [x,y,width,height] = compute_rectangle(X,Y)
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

x = min(X);
y = min(Y);
width = max(X) - x + 1;
height = max(Y) - y + 1;
return