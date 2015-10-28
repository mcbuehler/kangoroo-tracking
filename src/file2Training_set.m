function [X Y] = file2Training_set(file,image1,image2)
%% prepares training data in order to train SVM
% mode options:
% 1: using sift as features
% 2: using pixel values in a neighbourhood
% 3: using sift vector norm
% 4: using difference of sift descriptors
global file2Training_set_mode;
mode = file2Training_set_mode;

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

if mode == 1
    % way1: features using sift
    fc1 = [ X1' ; Y1';scale(m) ; zeros(1,m) ] ;
    [~,d1] = vl_sift(I1,'frames',fc1);
    fc2 = [ X2' ; Y2'; scale(m) ; zeros(1,m) ] ;
    [f2,d2] = vl_sift(I2,'frames',fc2);
    X = [ double(d1'),double(d2')];


elseif mode == 2
    % way2: features using pixel values
    % get neighbourhood pixels
    global neighbourhood_size
    nbs_size = neighbourhood_size;
    X = [];
    for i = 1 : m
        nbs1 = get_neighbourhood(X1(i),Y1(i),nbs_size);
        nbs2 = get_neighbourhood(X2(i),Y2(i),nbs_size);
        vals1 = [];
        vals2 = [];
        for k = 1 : size(nbs1,2)
            vals1 = [vals1 I1(nbs1(2,k),nbs1(1,k))];
            vals2 = [vals2 I2(nbs2(2,k),nbs2(1,k))];
        end
        vals = [vals1 , vals2];
        X = [X; vals];
    end
elseif mode == 3
    fc1 = [ X1' ; Y1';scale(m) ; zeros(1,m) ] ;
    [~,d1] = vl_sift(I1,'frames',fc1);
    fc2 = [ X2' ; Y2'; scale(m) ; zeros(1,m) ] ;
    [~,d2] = vl_sift(I2,'frames',fc2);
    X = [];
    for i = 1 : m
        dis = norm(double(d1(:,i)-d2(:,i)));
        X = [X; dis];
    end
elseif mode == 4
    fc1 = [ X1' ; Y1';scale(m) ; zeros(1,m) ] ;
    [~,d1] = vl_sift(I1,'frames',fc1);
    fc2 = [ X2' ; Y2'; scale(m) ; zeros(1,m) ] ;
    [~,d2] = vl_sift(I2,'frames',fc2);
    feat = d1' - d2';
    X = double(feat);
else
   disp('invalid mode @file2Training_set'); 
end

Y = L;
end