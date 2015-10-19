function [scores] = calculate_similarity_score(I1,I2,X,Y)
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
    disp('@calculate_similarity_score: Images are of different size')
end
if size(X) ~= size(Y) | size(X,1) ~= 1
    disp('@calculate_similarity_score: invalid input vectors')
end
    
m = size(X,1);   


% compute sift for all points (use vectorized method)
% placeholder
descriptors_I1 = ones(m,128);
descriptors_I2 = ones(m,128);

features = preprocess_svm_input(descriptors_I1,descriptors_I2);
% TODO: create and train svm and use svm to calculate scores. maybe create
% svm only once when starting script (more efficient)
[label,soft_scores] = predict(svm,features);

scores = label & ones(m,1)
% have to check what soft_scores look like
scores = scores * soft_scores;



return