function [X_n,Y_n] = align_keypoints_euclid(I1,I2,bounds)
%% Finds matching key points in new_frame
% Not all key points are aligned. if the matching value is below a
% threshold, it is discarded and the new coordinates are (0,0).
% in a second step implement the alignment for n old_frames (e.g. 4 frames)
% in order to improve matching in case of occlusion
% ------ INPUT ------
% I_o : previous frame
% I_n : subsequent frame
% X_o,Y_o : column vectors containing the n most significant key points for
% a certain object in I_o
%
% ------ OUTPUT ------
% X_n,Y_n : coordinates of new key points in I_n or -1,-1 for not aligned
% key points
m = 100;

rect = [bounds(1) bounds(2) bounds(1)+bounds(3) bounds(2)+bounds(4)];
I1 = smoothen_image(I1);
[f1,d1] = vl_dsift(I1,'bounds',rect);

numKeypointsFound = size(f1,2);
if numKeypointsFound < m
    fprintf('> Not enough key points found: only %d key points found.',numKeypointsFound)
end

% plot_tmp(I1,f1(1,:),f1(2,:));

% get 50 points with most contrast. Approach failed because only a small
% part of image was chosen because contrast was highest there
% [~,index] = sortrows(f1',3);
% index = index(length(index)-m:end)';

% pick random key points
perm = randperm(size(f1,2));
index = perm(1:m);


f1 = f1(:,index);
d1 = d1(:,index);

% plot_tmp(I1,f1(1,:),f1(2,:));

X_o = f1(1,:)';
X_n = zeros(m,1);
Y_o = f1(2,:)';
Y_n = zeros(m,1);
%compute corresponding key point for each key point
for i = 1 : m
    nbs = get_neighbourhood(X_o(i),Y_o(i),3);
    nbs_c = size(nbs,2);
    % compute sift for all neighbours
    fc = [ nbs(1,:) ; nbs(2,:); ones(1,nbs_c) ; zeros(1,nbs_c) ] ;
    [nbs_f,nbs_d] = vl_sift(I2,'frames',fc,'orientations') ;
    norms = ones(size(nbs_d,2),1) * -1;
    for k = 1 : size(nbs_d,2)
        norms(k) = norm(double(nbs_d(:,k) - d1(:,i)));
    end
    
    [~,m_i] = min(norms);
    X_n(i) = nbs_f(1,m_i);
    Y_n(i) = nbs_f(2,m_i);
    
end


end