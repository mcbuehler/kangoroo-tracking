%% Object tracking algorithm
clear all;

% --- mode ---
% 1: matching keypoints with euclidean distance
% 2: computing key points for both frames and using ubcmatch
% 3: matching key points using svm
mode = 3;

debug_flag = 0;
debug_frames = 2;

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

% --- result:
% 1: (only MOT) frameNr
% 2: (only MOT) objectId
% 3: X column vector
% 4: Y column Vector
% 5: W column VEctor
% 6: H column vector
result = zeros(no_of_frames,6);
result(1,:) = [1, 1, objects(1).x, objects(1).y, objects(1).w, objects(1).h ];

start_image = 1;
I_o = preprocess_image(imread(strcat(img_path,files(start_image).name)));
for f_i = start_image+1 : no_of_frames
    fprintf('> processing frame %d \n',f_i)
    I_n = preprocess_image(imread(strcat(img_path,files(f_i).name)));
%     waitforbuttonpress
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
        result(f_i,:) = [f_i, o_i, x2, y2, w2, h2];
        
%         I = draw(I_n,[x x2],[y y2], [w w2], [h h2]);
        
%         plot_tmp(I,X_n,Y_n);
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
disp('> writing data')
WritePrinceton('testset1',result(:,3),result(:,4),result(:,5),result(:,6));
WriteMOT('testset1',result(:,1),result(:,2),result(:,3),result(:,4),result(:,5),result(:,6));