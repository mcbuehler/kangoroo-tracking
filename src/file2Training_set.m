function [X Y] = file2Training_set(file,image1,image2)
scale = @(m)ones(1,m)*0.7;
I1 = imread(image1);
I2 = imread(image2);
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

X = [ double(d1'),double(d2')];
Y = L;
end