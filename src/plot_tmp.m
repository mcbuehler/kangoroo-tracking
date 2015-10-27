function p = plot_tmp(I,X1,Y1,X2,Y2,rect1,rect2)
%% plots key points and rectangles on top of image

for i = 1 : size(rect1,1)
    I = insertShape(I,'Rectangle', rect1(i,:), 'Color', 'r', 'LineWidth', 1);
end
for i = 1 : size(rect2,1)
    I = insertShape(I,'Rectangle', rect2(i,:), 'Color', 'g', 'LineWidth', 1);
end
imshow(I);
hold on;


plot(X1,Y1,'r*')
plot(X2,Y2,'g*')

for i = 1 : length(X2)
    p = plot([X1(i) X2(i)], [Y1(i), Y2(i)],'-b')   ; 
end

xlabel('x'); ylabel('y');
title('Aligning key points')
legend('old key points','new (matching) points','alignment');
hold off
end

    % only used for debugging:
%     xlabel('x'); ylabel('y');
%     title('Aligning key points')
%     legend('aligned points','previous key points','new new points');
%     [x,y,w,h] = enlarge_rectangle(bounds(1),bounds(2),bounds(3),bounds(4),0.2);
%     bounds = [x,y,w,h]; 
%     window = [x x+w y y+h]
%     axis(window)
%     axis equal
%     disp('done. press button')
%     waitforbuttonpress
%     hold off
% imshow(I2(int8(y):int8(y+h),int8(x):int8(x+w))); hold off;