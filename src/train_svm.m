function svm = train_svm()
%% Creates and trains a Support Vector Machine using the training set. 
% The training set should contain two SIFT descriptors as features and a
% binary output value (1 corresponds to "match" and 0 means "no match")
% Marcel
%
%
%
%

[sift_I1,sift_I2,Y] = get_training_set();
features = preprocess_svm_input(sift_I1,sift_I2);

svm = fitcsvm(features,Y,'KernelFunction','rbf','Standardize',true,'ClassNames',[0,1]);

return