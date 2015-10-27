function [ f,d ] = get_dsift_in_bound( I, bounds, m )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
% mode options:
% 1: get points with highest contrast
% 2: get random points
% 3: order by contrast, split array in multiple arrays, use highest
% contrast points of each of the resulting arrays
mode = 3;

rect = [bounds(1) bounds(2) bounds(1)+bounds(3) bounds(2)+bounds(4)];
I = smoothen_image(I);
[f,d] = vl_dsift(I,'bounds',rect,'norm');

numKeypointsFound = size(f,2);
if numKeypointsFound < m
    fprintf('> Not enough key points found: only %d key points found.',numKeypointsFound)
end

% plot_tmp(I1,f1(1,:),f1(2,:));

if mode == 1
% get 50 points with most contrast. Approach failed because only a small
% part of image was chosen because contrast was highest there
    [~,index] = sortrows(f',3);
    index = index(length(index)-m:end)';
elseif mode ==2
% pick random key points
    perm = randperm(size(f,2));
    index = perm(1:m);
    
elseif mode == 3
    index = [];
     [~,locIndex] = sortrows(f',3); 
    blockNumber =3;
    blockSize = numel(locIndex)/blockNumber;
    kpProBlock = m/blockNumber;
    for i = 1: blockNumber
        index = [index; locIndex(round((i-1)*blockSize+1) : round((i-1)*blockSize+1 + kpProBlock))]; 
        
    end
    
%   
%         [~,index] = sortrows(f',[1 2]);
%     index = index(1:length(index)/m:end)';
end


f = f(:,index);
d = d(:,index);

end

