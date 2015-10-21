function [scores] = calculate_similarity_score(I1,I2,X,Y,descriptors_I1)
%% Uses SVM to calculate similarity score between two points in two images
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
    
m = size(X,1);   

% ---- old approach ----
% compute sift for all points (use vectorized method)
% placeholder
% already done for I1

% use same scale as in find_keypoints (8/3)
fc = [X';Y';ones(1,m) *8/3;ones(1,m) * 0] ;

[f,descriptors_I2] = vl_sift(I2,'frames',fc,'orientations') ;
% features = preprocess_svm_input(descriptors_I1,descriptors_I2);
% TODO: create and train svm and use svm to calculate scores. maybe create
% svm only once when starting script (more efficient)
% [label,soft_scores] = predict(svm,features);

% scores = label & ones(m,1)
% have to check what soft_scores look like
% scores = scores * soft_scores;
% 
% size(descriptors_I2)
% size(descriptors_I1)
descriptors_I2 = descriptors_I2';
descriptors_I1 = descriptors_I1';

% ---- euclidian distance approach ----

% for all key points
distances = zeros(1,m);
for i = 1 : m
    dis = descriptors_I1(i,:) - descriptors_I2(i,:);
    dis = double(dis);
    distances(i) = norm(dis);
end
max_dis = max(distances);

% normalize: convert to score between 0 and 1 (1 highest)
% make sure that distance 0 is considered
scores = distances.^(-1) / max_dis;

return