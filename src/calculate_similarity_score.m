function [scores] = calculate_similarity_score(I1,I2,X,Y)
%% Uses SVM to calculate similarity score between two points in two images
% Score between 0 and 1
% ------ INPUT ------
% I1,I2 : images
% X,Y : coordinates of points. These points should exist in both Images 1 and 2. (may be column vectors)
%
% ------ OUTPUT ------
% scores = column vector containing similarity scores. if input was a
% single point, score only contains 1 value

if size(I1) != size(I2):
    disp('@calculate_similarity_score: Images are of different size')
if size(X) != size(Y) || size(X,1) != 1
    disp('@calcualte_similarity_score: invalid input vectors')
    
m = len(X);   

% TODO: create and train svm and use svm to calculate scores
scores = ones(m,1);

return