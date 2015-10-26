function [ rect ] = center_rectangle( X, Y, w, h )
%UNTITLED2 Summary of this function goes here

x = (min(X) + max(X)) / 2;
y = (min(Y) + max(Y)) / 2;
x = x - w/2;
y = y - h/2;
rect = [x y w h];
end

