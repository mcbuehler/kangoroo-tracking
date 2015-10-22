function [Features,Labels] = get_training_set()
%% Returns training set for SVM
scale = @(m)ones(1,m)*0.7;

file = '../training/zcup_move_1&rgb&r-3467165-69.png+zcup_move_1&rgb&r-3533842-70.png.csv';
I1 = imread('../datasets/zcup_move_1/rgb/r-3467165-69.png');
I2 = imread('../datasets/zcup_move_1/rgb/r-3533842-70.png');
I1 = im2single(rgb2gray(I1));
I2 = im2single(rgb2gray(I2));

content = load(file);

% m is number of training examples
m = size(content,1);
X1 = content(:,1);
X2 = content(:,2);
Y1 = content(:,3);
Y2 = content(:,4);
L = content(:,5);


fc1 = [ X1' ; Y1'; scale(m) ; zeros(1,m) ] ;
[~,d1] = vl_sift(I1,'frames',fc1);
fc2 = [ X2' ; Y2'; scale(m) ; zeros(1,m) ] ;
[f2,d2] = vl_sift(I2,'frames',fc2);

Features = [double(d1'),double(d2')];
Labels = L;

% SECOND DATASET 
file = '../training/zcup_move_1&rgb&r-433396-10.png+zcup_move_1&rgb&r-500072-11.png.csv';
I1 = imread('../datasets/zcup_move_1/rgb/r-433396-10.png');
I2 = imread('../datasets/zcup_move_1/rgb/r-500072-11.png');
I1 = im2single(rgb2gray(I1));
I2 = im2single(rgb2gray(I2));

content = load(file);

% m is number of training examples
m = size(content,1);
X1 = content(:,1);
X2 = content(:,2);
Y1 = content(:,3);
Y2 = content(:,4);
L = content(:,5);

fc1 = [ X1' ; Y1';scale(m) ; zeros(1,m) ] ;
[~,d1] = vl_sift(I1,'frames',fc1);
fc2 = [ X2' ; Y2'; scale(m) ; zeros(1,m) ] ;
[f2,d2] = vl_sift(I2,'frames',fc2);

Features = [Features;[ double(d1'),double(d2')]];
Labels = [Labels ; L];

return