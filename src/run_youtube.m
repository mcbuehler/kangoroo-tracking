% ------------------------------
clear all;
setenv('DEBUG','1')
% --- mode options:
% 1: match key points using svm
% 2: use ubcmatch
% 3: match key points using euclidean distance
mode = 3;
startFrameId = 1;

% number of key points per frame considered for matching
m = 10;

% Code from http://tracking.cs.princeton.edu/dataset.html
setName = 'face_occ5';
setName = 'child_no1';
% setName = 'zcup_move_1';
setName = 'new_ex_occ4';
directory = ['../evaluation/ptb/', setName, '/'];
load([directory 'frames']);  

%K is [fx 0 cx; 0 fy cy; 0 0 1];  
K = frames.K;  
cx = K(1,3); cy = K(2,3);  
fx = K(1,1); fy = K(2,2);  

numOfFrames = frames.length;  
imageNames = cell(1,numOfFrames*2);  
XYZcam = zeros(480,640,4,numOfFrames);

% Start Code kangoroo-tracking group
svm = train_svm();
result = zeros(numOfFrames,4);
% format: x y w h
bounds = load([directory 'init.txt']);
bounds(1) = 234; bounds(2) = 249; bounds(3) = 33; bounds(4) = 24;
% starting at frame 7
% bounds(1) = bounds(1)+47;


% imageName = fullfile(directory,sprintf('rgb/r-%d-%d.png', frames.imageTimestamp(startFrameId), frames.imageFrameID(startFrameId)));  
% rgb = imread(imageName);
% I_o = preprocess_image(rgb);
% End code kangoroo-tracking group


mov=VideoReader('../evaluation/own/pendulum.mp4');
% vidFrames=read(mov,[1350 1360]);
% nFrames=mov.NumberOfFrames;
% frames = [];
% for i = 1 : 11
%     tmp = vidFrames(:,:,:,i);
%     frames = [ frames; preprocess_image(tmp)];
% end
% size(frames)
startFrame = 1350;

I_o = read(mov,startFrame);
I_o = preprocess_image(I_o(:,:,:,1));

[f,d] = vl_sift(I_o);
perm = randperm(size(f,2)) ;
sel = perm(1:10) ;
h1 = vl_plotframe(f(:,sel)) ;
h2 = vl_plotframe(f(:,sel)) ;
set(h1,'color','k','linewidth',3) ;
set(h2,'color','y','linewidth',2) ;
I_o(155:165,325:335)
h3 = vl_plotsiftdescriptor(d(:,sel),f(:,sel)) ;
set(h3,'color','g') ;
return 
for frameId = 2:numOfFrames  
    frame = read(mov,startFrame+frameId);
    frame = preprocess_image(frame(:,:,:));
    I_n = frame;
    
%     imageName = fullfile(directory,sprintf('rgb/r-%d-%d.png', frames.imageTimestamp(frameId), frames.imageFrameID(frameId)));  
%     rgb = imread(imageName);
    % ------------------------------
    % Start Code kangoroo-tracking group
    fprintf('> processing frame %d\n',frameId)
%     I_n = preprocess_image(frames(frameId));
%     I_n = frames(frameId);
    % get new key points
    [f1,d1] = get_dsift_in_bound(I_o,bounds,m);

    if mode == 1
        [X_n,Y_n] = align_keypoints_svm(svm,I_n,f1,d1,bounds);
    elseif mode == 2
        [X_n,Y_n] = align_keypoints_ubcmatch(I_n,f1,d1,bounds);
    elseif mode == 3
        [X_n,Y_n] = align_keypoints_euclid(I_n,f1,d1,bounds);
    end
    
    [x_vec,y_vec] = get_avg_movement(f1(1,:)',X_n,f1(2,:)',Y_n);
    if getenv('DEBUG') == '1'
        fprintf('> moving rectangle x %f and y %f\n',x_vec,y_vec)
    end
    x2 = bounds(1)+x_vec;
    y2 = bounds(2)+y_vec;
    w2 = bounds(3);
    h2 = bounds(4);
    % compute new bounding box
%     [x2,y2,w2,h2] = compute_rectangle(X_n,Y_n);
    X = [bounds(1), x2]'; Y = [bounds(2), y2]'; W = [bounds(3), w2]'; H = [bounds(4), h2]';
%     waitforbuttonpress
    draw(I_n,X,Y,W,H);
    % save result needed for ptb evaluation
    result(frameId,:) = [x2, y2, w2, h2];
    % reassign variables
    I_o = I_n;
    bounds = [x2, y2, w2, h2];

end  
disp('> writing data')
WritePrinceton(setName,result(:,1),result(:,2),result(:,3),result(:,4));