% ------------------------------

% --- mode options:
% 1: match key points using svm
% 2: use ubcmatch
mode = 2

% Code from http://tracking.cs.princeton.edu/dataset.html
setName = 'face_occ5';
setName = 'child_no1';
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
bounds = load([directory 'init.txt']);
imageName = fullfile(directory,sprintf('rgb/r-%d-%d.png', frames.imageTimestamp(frameId), frames.imageFrameID(frameId)));  
rgb = imread(imageName);
I_o = preprocess_image(rgb);
% End code kangoroo-tracking group

for frameId = 2:numOfFrames  
    imageName = fullfile(directory,sprintf('rgb/r-%d-%d.png', frames.imageTimestamp(frameId), frames.imageFrameID(frameId)));  
    rgb = imread(imageName);  
    % ------------------------------
    % Start Code kangoroo-tracking group
    fprintf('> processing frame %d\n',frameId)
    I_n = preprocess_image(rgb);
    % get new key points

    if mode == 1
        [X_n,Y_n] = align_keypoints_svm(svm,I_o,I_n,bounds);
    elseif mode == 2
        [X_n,Y_n] = align_keypoints_ubcmatch(I_o,I_n,bounds);
    end
    % compute new bounding box
    [x2,y2,w2,h2] = compute_rectangle(X_n,Y_n);
    % visualize result
    X = [bounds(1), x2]'; Y = [bounds(2), y2]'; W = [bounds(3), w2]'; H = [bounds(4), h2]';

    waitforbuttonpress
    draw(I_n,X,Y,W,H);

    % save result needed for ptb evaluation
    result(frameId,:) = [x2, y2, w2, h2];
    % reassign variables
    I_o = I_n;
    bounds = [x2, y2, w2, h2];

end  
disp('> writing data')
WritePrinceton(setName,result(:,1),result(:,2),result(:,3),result(:,4));