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

balance = 0.05;

width = max(X) - min(X) + 1 
height = max(Y) - min(Y) + 1 
x = min(X) - balance*width;
y = min(Y) - balance*height;

width = width + 2*balance*width;

height = height + 2*balance*height;

area = width*height
return