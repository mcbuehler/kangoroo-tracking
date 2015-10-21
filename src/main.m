%% Object tracking algorithm
clear all;

debug_flag = 0;
debug_frames = 10;
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
for i = 1 : no_of_frames
    image = imread(strcat(img_path,files(i).name));
    image = preprocess_image(image);
    frames(:,:,i) = image;
    if debug_flag
        if i>debug_frames
            no_of_frames = i;
            break
        end
    end
end


disp('> images loaded')

% initialize objects

object = struct('x','y','w','h');
object.x = 172; object.y = 200; object.w = 100; object.h = 50;
objects = [object];

%stores all objects
results = zeros(0,50,no_of_frames);
% for all frames:
%   for all objects:
%       find_keypoints
%       align_keypoints
%   draw

disp('> objects initialized')
imshow(frames(:,:,1))
% waitforbuttonpress

for frame_i = 5 : no_of_frames
    fprintf('> processing frame %d \n',frame_i)
    I_o = frames(:,:,frame_i-1);
    I_n = frames(:,:,frame_i);
    for object_i = 1 : size(objects,2)
        % for readability save variables tmp
        x = objects(object_i).x;
        y = objects(object_i).y;
        w = objects(object_i).w;
        h = objects(object_i).h;
        [X_o,Y_o,descriptors] = find_keypoints(I_o,x,y,w,h);
        
        [X_n,Y_n] = align_keypoints(I_o,I_n,X_o,Y_o,descriptors);
                
        [x2,y2,w2,h2] = compute_rectangle(X_n,Y_n);
        I_n = draw(I_n,[x x2],[y y2], [w w2], [h h2]);
        plot_tmp(I_n,X_n,Y_n);
        
        
        objects(object_i).x = x2;
        objects(object_i).y = y2;
        objects(object_i).w = w2;
        objects(object_i).h = h2;
    end
%     [x,y,w,h] = compute_rectangle(X_n,Y_n);
%     draw(I_n,x,y,w,h)
%     waitforbuttonpress

    if debug_flag
        if frame_i > debug_frames
            break
        end
    end

end

