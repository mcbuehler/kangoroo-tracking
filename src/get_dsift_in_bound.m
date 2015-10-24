function [ f,d ] = get_dsift_in_bound( I, bounds, m )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
% mode options:
% 1: get points with highest contrast
% 2: get random points
% 3: get points with highest contrast in segments of image
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
%     [~,index] = sortrows(f',3);
%     index = index(length(index)-m:end)';
%     tmp = [];
%     f = sortrows(f',2)';
%     numClusters = 10;
%     part = linspace(1,numKeypointsFound,numClusters);
%     for i = 1 : numClusters-1
%         start = round(part(i)); ending = round(part(i+1)-1);
%         [sorted,index] = sortrows(f(:,start:ending)',3);
%         sorted
%         waitforbuttonpress
%         index = index(length(index)-round(m/10):end)';
%         tmp = [tmp index];
%     end
%     index = tmp;
%     f = f(:,index);
%     d = d(:,index);
%     
    
elseif mode == 2
% pick random key points
    perm = randperm(size(f,2));
    index = perm(1:m);
    f = f(:,index);
    d = d(:,index);
elseif mode == 3
    numWindows = 5;
    not_enough_found = 1;
    while not_enough_found
        seq_w = bounds(3)/numWindows;
        seq_h = bounds(4)/numWindows;
        tmp =  [];
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
    %             fprintf('size of index: %d',size(index,1));
                if length(index)-round(length(index)/3) > 0
                    index = index(length(index)-round(length(index)/3):end)';
                else
                    debug('not enough indeces found. using all that we have (%d).\n',length(index));
                end
                f_tmp = [f_tmp, f(:,index)];
                d_tmp = [d_tmp, d(:,index)];
            end
        end
        if size(f_tmp,2) >= 100
            not_enough_found = 0
        else
            debug('not enough found (%d). repeating loop',size(f_tmp,2));
            numWindows = numWindows-2;
        end
    end
    
    
    perm = randperm(size(f_tmp,2));
    debug('end index length is: ',length(index));
    index = perm(1:m);
    f = f_tmp(:,index);
    d = d_tmp(:,index);
else
    disp('youre wrong');
end



% plot_tmp(I,f(1,:),f(2,:))
% waitforbuttonpress

end

