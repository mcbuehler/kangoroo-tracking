function [scores] = calculate_similarity_score(I1,I2,X,Y,descriptor_I1)
%% Finds point in X,Y that matches descriptor_I1 best
% Score between 0 and 1
% ------ INPUT ------
% I1,I2 : images
% X,Y : coordinates of points. These points should exist in both Images 1 and 2. (may be column vectors)
%
% ------ OUTPUT ------
% scores = column vector containing similarity scores (0 for not matching, a value between 0 and 1 for matching). if input was a
% single point, score only contains 1 value

if size(I1) ~= size(I2)
    disp('@calculate_similarity_score: Images are of different size:')
    size(I1)
    size(I2)
    return
end
if size(X) ~= size(Y) | size(X,2) ~= 1
    disp('@calculate_similarity_score: invalid input vectors:')
    size(X)
    size(Y)
end
    
% only take 200 out of the 400 points -> speedup
 m = size(X,1);
% 
% % randomly pick 50
% perm = randperm(size(X,1));
% sel = perm(1,1:m);
% X = X(sel);
% Y = Y(sel);
% ---- old approach ----
% compute sift for all points (use vectorized method)
% placeholder
% already done for I1

% use same scale as in find_keypoints (8/3)
% fc = [X';Y';ones(1,m) * 1; zeros(1,m) ] ;
fc = [ X' ; Y'; ones(1,m) ; zeros(1,m) ] ;


[~,descriptors_I2] = vl_sift(I2,'frames',fc) ;

% features = preprocess_svm_input(descriptors_I1,descriptors_I2);
% TODO: create and train svm and use svm to calculate scores. maybe create
% svm only once when starting script (more efficient)
% [label,soft_scores] = predict(svm,features);

% scores = label & ones(m,1)
% have to check what soft_scores look like
% scores = scores * soft_scores;
% 

% ---- euclidian distance approach ----

% for all key points
distances = zeros(m,1);
for i = 1 : m
    dis = descriptor_I1 - descriptors_I2(:,i);
    dis = double(dis);
    distances(i) = norm(dis);
end

% max_dis = max(distances);

% normalize: convert to score between 0 and 1 (1 highest)
% make sure that distance 0 is considered
% waitforbuttonpress
% scores = distances.^(-1) / max_dis;

% normalize
scores = distances / max(distances);
return