function I = draw(I,X,Y,W,H)
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
% for i = 1 : length(X)
%     x = X(i);
%     y = Y(i);
%     width = Width(i);
%     height = Height(i);
%     I = insertShape(I,'Rectangle', [x y width height], 'Color', 'r', 'LineWidth', 1); 
% end

    I = insertShape(I,'Rectangle', [X(1) Y(1) W(1) H(1)], 'Color', 'r', 'LineWidth', 1);
    
    I = insertShape(I,'Rectangle', [X(2) Y(2) W(2) H(2)], 'Color', 'g', 'LineWidth', 1);


imshow(I)
% waitforbuttonpress

hold off




return
