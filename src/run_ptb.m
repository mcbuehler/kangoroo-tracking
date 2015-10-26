% ------------------------------
clear all;
conf
hold off
% --- mode options:
% 1: match key points using svm
% 2: use ubcmatch
% 3: match key points using euclidean distance
mode = 1;
startFrameId = 1;

% max number of key points per frame considered for matching
m = 10;

% Dataset from Princeton Tracking Benchmark: http://tracking.cs.princeton.edu/dataset.html
setName = 'face_occ5';
setName = 'child_no1';
setName = 'zcup_move_1';
setName = 'bear_front';
% setName = 'new_ex_occ4';
directory = ['../evaluation/ptb/', setName, '/'];
load([directory 'frames']);  

%K is [fx 0 cx; 0 fy cy; 0 0 1];  
K = frames.K;  
cx = K(1,3); cy = K(2,3);  
fx = K(1,1); fy = K(2,2);  

numOfFrames = frames.length;  
imageNames = cell(1,numOfFrames*2);  
% XYZcam = zeros(480,640,4,numOfFrames);
% 
svm = train_svm();
result = zeros(numOfFrames,4);
% format: x y w h
bounds = load([directory 'init.txt']);

imageName = fullfile(directory,sprintf('rgb/r-%d-%d.png', frames.imageTimestamp(startFrameId), frames.imageFrameID(startFrameId)));  
rgb = imread(imageName);
I_o = preprocess_image(rgb);
% End code kangoroo-tracking group

for frameId = startFrameId:numOfFrames  
    imageName = fullfile(directory,sprintf('rgb/r-%d-%d.png', frames.imageTimestamp(frameId), frames.imageFrameID(frameId)));  
    rgb = imread(imageName);
    % ------------------------------
    % Start Code kangoroo-tracking group
    fprintf('> processing frame %d\n',frameId)
    I_n = preprocess_image(rgb);

    % get new key points
    [f1,d1] = get_dsift_in_bound(I_o,bounds,m);

    X_o = f1(1,:);
    Y_o = f1(2,:);
    
    if mode == 1
        [X_n,Y_n] = align_keypoints_svm(svm,I_n,f1,d1,bounds);
    elseif mode == 2
        [X_n,Y_n] = align_keypoints_ubcmatch(I_n,f1,d1,bounds);
    elseif mode == 3
        [X_n,Y_n] = align_keypoints_euclid(I_n,f1,d1,bounds);
    end
    ;
    % Only extract aligned points
    accepted = find(X_n)
    X_n = X_n(accepted);
    Y_n = Y_n(accepted);
    X_o_accepted = X_o(accepted)';
    Y_o_accepted = Y_o(accepted)';
    if length(X_n) < 1
        disp('target lost. Aborting');
        return
    end
    [x_vec,y_vec] = get_avg_movement(X_o_accepted,X_n,Y_o_accepted,Y_n);
    
    debug('> moving rectangle x %f and y %f\n',[x_vec,y_vec]);
    
    x2 = bounds(1)+x_vec;
    y2 = bounds(2)+y_vec;
    w2 = bounds(3);
    h2 = bounds(4);
    rect2 = [x2, y2, w2, h2];
    
    if getenv('DEBUG') == '1'
        plot_tmp(I_n,X_o_accepted,Y_o_accepted,X_n,Y_n,bounds,rect2);
        input('> Press enter to continue')
    end
    p = plot_tmp(I_n,X_o_accepted,Y_o_accepted,X_n,Y_n,bounds,rect2);
    drawnow
    result(frameId,:) = rect2;
    % reassign variables
    I_o = I_n;
    bounds = rect2;

end  
disp('> writing data')
WritePrinceton(setName,result(:,1),result(:,2),result(:,3),result(:,4));