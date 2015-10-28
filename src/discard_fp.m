function [ X1, X2, Y1, Y2 ] = discard_fp( X1,X2,Y1,Y2 )
%% Identifies motion vectors that are likeli to be incorrect alignments and discards those points
%   Take avg motion vector and discard points whose vector points into
%   the other direction
[x_vec,y_vec] = get_avg_movement(X1,X2,Y1,Y2);

count1 = length(X2);

% flags indicating movement
moving_right = x_vec > 0
moving_down = y_vec > 0


% get indeces for all vectors that go right
if moving_right
    indeces_horizontal = find((X2 - X1) > zeros(count1,1));
else
    indeces_horizontal = find((X2 - X1) < zeros(count1,1));
end
if moving_down
    indeces_vertical = find((Y2 - Y1) > zeros(count1,1));
else
    indeces_vertical = find((Y2 - Y1) < zeros(count1,1));
end
indeces = intersect(indeces_horizontal,indeces_vertical);
X1 = X1(indeces);
X2 = X2(indeces);
Y1 = Y1(indeces);
Y2 = Y2(indeces);
count2 = length(X2);

debug('> %d from %d points assumed to be false positives.\n',[count1 - count2,count1]);

end

