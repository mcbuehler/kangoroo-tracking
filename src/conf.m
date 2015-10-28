global neighbourhood_size
neighbourhood_size = 15;


global file2Training_set_mode
% 1: using sift as features
% 2: using pixel values in a neighbourhood
% 3: using sift vector norm
% 4: using difference of sift descriptors
file2Training_set_mode = 4;

setenv('DEBUG','1')

% threshold for alignment scores from svm. 0.6 has shown to be a good
% value. value has to be between 0 and 1.
global ALIGN_SVM_SCORE_THRESHOLD
ALIGN_SVM_SCORE_THRESHOLD = 0.6;