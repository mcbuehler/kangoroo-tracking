function svm = train_svm()
%% Creates and trains a Support Vector Machine
% The training set should contain the difference between two SIFT descriptors as features and a
% binary output value (1 corresponds to "match" and 0 means "no match")
% Marcel

% mode options:
% 1: train svm once (do not show plot)
% 2: train svm with 1 : m training examples and plot performance
mode = 1;


[X,Y] = get_training_set();
svm = fitcsvm(X,Y,'KernelFunction','rbf','Standardize',true,'Kernelscale','auto');

cvsvmmodel = crossval(svm);
classloss = kfoldLoss(cvsvmmodel);
debug('> SVM successfully trained. Classloss = %f\n',classloss);

if mode == 2
    % -- only for evaluation
    l = size(Y,1);
    r_nonlinear = [];
    r_linear = [];
    steps = 1 : 1 : l;
    for i = steps
        svm = fitcsvm(X,Y,'KernelFunction','linear','Standardize',true,'Kernelscale','auto');
        cvsvmmodel = crossval(svm);
        classloss = kfoldLoss(cvsvmmodel);
        r_linear = [r_linear classloss];

        svm = fitcsvm(X,Y,'KernelFunction','rbf','Standardize',true,'Kernelscale','auto');
        cvsvmmodel = crossval(svm);
        classloss = kfoldLoss(cvsvmmodel);
        r_nonlinear = [r_nonlinear classloss];
    end

    plot(steps,r_linear,'-b',steps,r_nonlinear,'-r')
    legend('classloss with linear kernel','classloss with non-linear kernel');
    title('SVM performance evaluation')
    xlabel('# of training examples')
    ylabel('classloss')
end
end
