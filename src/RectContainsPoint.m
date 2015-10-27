function value = RectContainsPoint(rect,x,y)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

value = (x >= rect(1) & x <= rect(1) + rect(3) & y >= rect(2) & y <= rect(2) + rect(4));

end
