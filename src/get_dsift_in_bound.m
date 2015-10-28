function [ f,d ] = get_dsift_in_bound( I, bounds, m ,mode)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
% mode options:
% 1: get points with highest contrast
% 2: get random points
% 3: order by contrast, split array in multiple arrays, use highest
% contrast points of each of the resulting arrays
% 4: get points with highest contrast in segments of image



rect = [bounds(1) bounds(2) bounds(1)+bounds(3) bounds(2)+bounds(4)];
% [x,y,w,h] = enlarge_rectangle(bounds(1),bounds(2), bounds(1)+bounds(3), bounds(2)+bounds(4),-0.1);
% rect = [x,y,w,h];
I = smoothen_image(I);
[f,d] = vl_dsift(I,'bounds',rect,'norm');

numKeypointsFound = size(f,2);
if numKeypointsFound < m
    debug('> Not enough key points found: only %d key points found.',numKeypointsFound);
end

% plot_tmp(I1,f1(1,:),f1(2,:));

if mode == 1
% get 50 points with most contrast. Approach failed because only a small
% part of image was chosen because contrast was highest there
    [~,index] = sortrows(f',3);
    index = index(length(index)-m:end)';
    f = f(:,index);
    d = d(:,index);
elseif mode == 2
% pick random key points
    perm = randperm(size(f,2));
    index = perm(1:m);
    f = f(:,index);
    d = d(:,index);
elseif mode == 3
     index = [];
     [~,locIndex] = sortrows(f',3); 
    blockNumber =3;
    blockSize = numel(locIndex)/blockNumber;
    kpProBlock = m/blockNumber;
    for i = 1: blockNumber
        index = [index; locIndex(round((i-1)*blockSize+1) : round((i-1)*blockSize+1 + kpProBlock))];        
    end
    f = f(:,index);
    d = d(:,index);
    
elseif mode == 4
    % splitting windows up into several sub windows and computing points
    % with highest contrast within sub windows
    numWindows = 5;
    not_enough_found = 1;
    while not_enough_found
        seq_w = bounds(3)/numWindows;
        seq_h = bounds(4)/numWindows;
        f_tmp = [];
        d_tmp = [];
        for i = 1 : numWindows-1
            for k = 1 : numWindows-1
                xStart = (k-1)*seq_w+bounds(1);
                yStart = (i-1)*seq_h+bounds(2);
                window = [ xStart yStart xStart+seq_w yStart+seq_h];
    %             draw(I,xStart,yStart,seq_w,seq_h);
                [f,d] = vl_dsift(I,'bounds',window,'norm');
                [~,index] = sortrows(f',3);
                if length(index)-round(length(index)/3) > 0
                    index = index(length(index)-round(length(index)/3):end)';
                else
                    debug('not enough indeces found. using all that we have (%d).\n',length(index));
                end
                f_tmp = [f_tmp, f(:,index)];
                d_tmp = [d_tmp, d(:,index)];
            end
        end
        if size(f_tmp,2) >= m
            not_enough_found = 0;
            debug('> enough found with %d sub windows\n',numWindows);
        else
            debug('> not enough found (%d). repeating loop\n',size(f_tmp,2));
            numWindows = numWindows-2;
        end
    end
    
    
    perm = randperm(size(f_tmp,2));
    debug('> end index length is: %d\n',length(index));
    index = perm(1:m);
    f = f_tmp(:,index);
    d = d_tmp(:,index);

end


end

