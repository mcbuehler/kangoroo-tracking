function features = preprocess_svm_input(sift_I1, sift_I2)
%% Preprocesses sift vectors in X such that they can be used as input for SVM
% ------ INPUT ------
% Sift_I1, Sift_I2 : matrix containing sift descriptors for Images 1 and 2.
% Each row contains a sift descriptor for a point.
%
% ------ OUTPUT ------
% features : feature matrix for X. Every row represents one observation

% idea: take square difference
features = [sum((sift_I1 - sift_I2).^2,2)];

% idea2: take square difference of vector norms
features = ones(size(sift_I1,1),1);
for i = 1 : size(sift_I1,1);
    features(i) = norm(sift_I1(i,:)) - norm(sift_I2(i,:));
end

return