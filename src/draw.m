function I = draw(I,X,Y,Width,Height)
%% Draws image and rectanges that contain the tracked objects
%
% Leroy
% ------ INPUT ------
% I : frame of image
% X,Y : column vectors containing coordinates of rectangles' top left
% corner
% Width,Height : column vectors with widths and heights of rectangles
%
% 
for i = 1 : length(X)
    x = X(i);
    y = Y(i);
    width = Width(i);
    height = Height(i);
    I = insertShape(I,'Rectangle', [x y width height], 'Color', 'r', 'LineWidth', 1); 
end
imshow(I)
% waitforbuttonpress

hold on




return
