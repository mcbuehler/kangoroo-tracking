%% Object tracking algorithm
clear all;

debug_flag = 0;
debug_frames = 20;
% organize code (NEW function to compute sift
% test
% implement main

% Load images
img_path = strcat(pwd,'/../test_images/set1/');
img_type = '*.png';
files = dir(strcat(img_path, img_type));
no_of_frames = length(files);
image_size = size(imread(strcat(img_path,files(1).name)));
frames = single(zeros(image_size(1),image_size(2),no_of_frames));
originals = zeros(image_size(1),image_size(2),3,no_of_frames);


object = struct('x','y','w','h');
% testset1:
object.x = 185; object.y = 151; object.w = 75; object.h = 47;
% testset2:
% object.x = 51; object.y = 216; object.w = 156; object.h = 184;
% testset3:
% object.x = 99; object.y = 186; object.w = 100; object.h = 133;
objects = [object];
disp('> objects initialized')

svm = train_svm;

start_image = 4;
I_o = preprocess_image(imread(strcat(img_path,files(start_image).name)));
for f_i = 5 : no_of_frames
    fprintf('> processing frame %d \n',f_i)
    I_n = preprocess_image(imread(strcat(img_path,files(f_i).name)));
    waitforbuttonpress
    files(f_i).name

    for o_i = 1 : size(objects,2)
        % for readability save variables tmp
        x = objects(o_i).x;
        y = objects(o_i).y;
        w = objects(o_i).w;
        h = objects(o_i).h;
        % ---- mode: keypoints
%         [X_o,Y_o,d_o] = find_keypoints(I_o,x,y,w,h);
%         [X_n,Y_n] = align_keypoints(I_o,I_n,X_o,Y_o,d_o);
%       % ---- mode: ubcmatch
%         r_o = [ x y w h];
%         [X_o,Y_o,X_n,Y_n] = align_keypoints_ubcmatch(I_o,I_n,r_o);
        
        % ---- mode: svm
       r_o = [ x y w h];
       [X_o,Y_o,X_n,Y_n] = align_keypoints_svm(svm,I_o,I_n,r_o);
        
        [x2,y2,w2,h2] = compute_rectangle(X_n,Y_n);
        I = draw(I_n,[x x2],[y y2], [w w2], [h h2]);
        
        plot_tmp(I,X_n,Y_n);
        
        
        objects(o_i).x = x2;
        objects(o_i).y = y2;
        objects(o_i).w = w2;
        objects(o_i).h = h2;
    end
%     [x,y,w,h] = compute_rectangle(X_n,Y_n);
%     draw(I_n,x,y,w,h)
%     waitforbuttonpress

    if debug_flag
        if f_i > debug_frames
            break
        end
    end
    I_o = I_n;

end

