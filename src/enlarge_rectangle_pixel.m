function value = enlarge_rectangle_pixel(x,y,w,h,pixels)
% function [x,y,width,height] = enlarge_rectangle_pixel(x,y,w,h,pixels)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
x = x - pixels;
y = y - pixels;

width = w + 2*pixels;

height = h + 2*pixels;

value = [x y width height];

end
