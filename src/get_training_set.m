function [Features,Labels] = get_training_set()
%% Returns training set for SVM
directory = './training_set/';
scale = @(m)ones(1,m)*0.7;
Features = [];
Labels = [];

% --- dataset 1 ---
file = [directory 'zcup_move_1&rgb&r-3467165-69.png+zcup_move_1&rgb&r-3533842-70.png.csv'];
image1 = [directory, 'r-3467165-69.png'];
image2 = [directory, 'r-3533842-70.png'];

[X, Y] = file2Training_set(file,image1,image2);
Features = [Features; X];
Labels = [Labels; Y];

% --- dataset 2 ---
file = [directory 'zcup_move_1&rgb&r-433396-10.png+zcup_move_1&rgb&r-500072-11.png.csv'];
image1 = [directory, 'r-433396-10.png'];
image2 = [directory, 'r-500072-11.png'];

[X, Y] = file2Training_set(file,image1,image2);
Features = [Features; X];
Labels = [Labels; Y];

% --- dataset 3 ---
file = [directory 'Child_no1__r_0_1&r_66676_2.scv.csv'];
image1 = [directory, 'r-0-1.png'];
image2 = [directory, 'r-66676-2.png'];

[X, Y] = file2Training_set(file,image1,image2);
Features = [Features; X];
Labels = [Labels; Y];


% --- dataset 4 ---
file = [directory 'face_occ_5__r_0_1&r_200029_5.scv.csv'];
image1 = [directory, 'r-0-1.png'];
image2 = [directory, 'r-200029-5.png'];

[X, Y] = file2Training_set(file,image1,image2);
Features = [Features; X];
Labels = [Labels; Y];


% --- dataset 5 ---
file = [directory 'face_occ_5__r_2933755_59&r_3533841_71.scv.csv'];
image1 = [directory, 'r-2933755-59.png'];
image2 = [directory, 'r-3533841-71.png'];

[X, Y] = file2Training_set(file,image1,image2);
Features = [Features; X];
Labels = [Labels; Y];

return