function draw(I,X,Y,Width,Height)
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

I_new = I;
for i = 1 : length(X)
    x = X(i);
    y = Y(i);
    width = Width(i);
    height = Height(i);
    I_new = insertShape(I_new,'Rectangle', [x y width height], 'Color', 'r', 'LineWidth', 1); 
end
imshow(I_new)






return
