function svm = train_svm()
%% Creates and trains a Support Vector Machine using the training set. 
% The training set should contain two SIFT descriptors as features and a
% binary output value (1 corresponds to "match" and 0 means "no match")
% Marcel
%
%
%
%

[X,Y] = get_training_set();
svm = fitcsvm(X,Y,'KernelFunction','linear','Standardize',true,'Kernelscale','auto');

cvsvmmodel = crossval(svm);
classloss = kfoldLoss(cvsvmmodel);


% -- only for evaluation
% l = size(Y,1);
% r = []
% steps = 1 : 4 : l;
% for i = steps
%     i
%     svm = fitcsvm(X,Y,'KernelFunction','linear','Standardize',true,'Kernelscale','auto');
% 
%     cvsvmmodel = crossval(svm);
%     classloss = kfoldLoss(cvsvmmodel);
%     r = [r classloss];
% end
% 
% plot(steps,r,'-r')
% title('SVM training')
% xlabel('# of training examples')
% ylabel('classloss')
end
