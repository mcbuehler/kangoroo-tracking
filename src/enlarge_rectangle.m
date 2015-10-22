function [x,y,width,height] = enlarge_rectangle(x,y,w,h,factor)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
x = x - factor*w;
y = y - factor*h;

width = w + 2*factor*w;

height = h + 2*factor*h;

end

