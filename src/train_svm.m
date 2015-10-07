function svm = train_svm(X,Y)
%% Creates and trains a Support Vector Machine using the training set. 
% The training set should contain two SIFT descriptors as features and a
% binary output value (1 corresponds to "match" and 0 means "no match")
svm = fitcsvm(X,Y,'linear','rbf','Standardize',true,'ClassNames',{'no match','match'});

return