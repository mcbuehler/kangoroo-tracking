function [sift_I1,sift_I2,Y] = get_training_set()
%% Returns training set for SVM
% Loads training set from matlab file. this file yet has to be created.


% maybe preprocess (take difference of vectors instead of full vectors)

% just for debugging. replace with correct ones.
% number of training examples
m = 100;

sift_I1 = ones(m,10);

sift_I2 = zeros(m,10);

Y = [1; 0];
return