
clear all;
% load global conf variables
conf

% plotting level
% 0: do not plot (used for writing output file)
% 1: plot old and new recangles
% 2: plot rectangles and key points
plot_level = 2;

% stop after n frames
stopFrame = 2;

% --- mode options:
% 4: compute key points for both frames and match them using euclid
% 5: compute key points for both frames and match them using SVM
mode = 4;

% parameters used for both methods (euclid and svm matching)
startFrameId = 1;
ptbPath = '../evaluation/ptb/';
% ptbPath = 'C:\Users\12400952\Downloads\EvaluationSet/'

% Datasets from Princeton Tracking Benchmark: http://tracking.cs.princeton.edu/dataset.html
setName = 'face_occ5';
setName = 'child_no1';
%setName = 'new_ex_occ4';
%setName = 'basketball1';
%setName = 'child_no2';
%setName = 'computerbar1';
%setName = 'toy_yellow_no';%-
%setName = 'toy_no_occ';
% setName = 'toy_no';%- fast
%setName = 'wdog_no1';%-
%setName = 'wr_no';
%setName = 'two_book';
%setName = 'walking_no_occ'; %-


% parameter 
mode = matching_mode;
m = maxKeypoints;

directory = [ptbPath, setName, '/'];
load([directory 'frames']);

%K is [fx 0 cx; 0 fy cy; 0 0 1];  
K = frames.K;  
cx = K(1,3); cy = K(2,3);  
fx = K(1,1); fy = K(2,2);  

numOfFrames = frames.length;
imageNames = cell(1,numOfFrames*2);

counter = 0;

%prepare result array
result = zeros(numOfFrames,4);

if mode == 4
    % setting parameters for euclidean matching
    boundExpander = 20;
    discardNonMovingPoints = 0;
    moveThreshold = 5;
    discardWrongMovements = 1;
    stopEveryXImage = 0;
    euclidThreshold = 100;
    useGUI = 0; %not implemented
    plotKeypoints =0;
    m = 1000;%number of keypoints chosen - set high due to bad selection
    
    % format: x y w h
    objRect = load([directory 'init.txt']);
    
    %prepare img
    imageName = fullfile(directory,sprintf('rgb/r-%d-%d.png', frames.imageTimestamp(1), frames.imageFrameID(1)));
    rgb = imread(imageName);
    img = preprocess_image(rgb);
    
    %get first keypoints
    [fLast,dLast] = get_dsift_in_bound(img,objRect,m,3);
    
    for frameId = 2:numOfFrames
        
        % load and prepare next frame
        imageName = fullfile(directory,sprintf('rgb/r-%d-%d.png', frames.imageTimestamp(frameId), frames.imageFrameID(frameId))) ;
        rgb = imread(imageName);
        fprintf('> processing frame %d\n',frameId)
        img = preprocess_image(rgb);
        
        % we will compute all the key points in the expanded rectangle in
        % the new frame
        expRect = enlarge_rectangle_pixel(objRect(1), objRect(2), objRect(3),objRect(4), boundExpander);
        expRect = fitToImage(expRect,img);
        [fCurrent,dCurrent] =  get_dsift_in_bound(img,expRect,m,3);
        
        %define array of matching keypoints[xo, xn, yo,yn]
        matches = [];
        
        %iterate through all keypoints from the last img and try to find
        %new matching key points
        for kpLastID = 1:size(fLast,2)
            
            %get coordinates of keypoint
            x = fLast(1,kpLastID);
            y = fLast(2,kpLastID);
            
            %get rect that defines the current keypoint's neighborhood
            neighbourhoodRect = enlarge_rectangle_pixel(x,y,0,0, boundExpander);
            neighbourhood = fitToImage(neighbourhoodRect,img);
            
            %find best match within neighbourhood
            bestMatchKeypoint =[];
            bestMatchEuclid = inf;
            bestMatchSVM = -1;
            
            %find best match in neighbourhood
            %iterate through all keypoints from the current img
            for kpCurrentID = 1:size(fCurrent,2)
                %if keypoint is in neighbourhood of x and y
                if (RectContainsPoint(neighbourhoodRect,fCurrent(1,kpCurrentID), fCurrent(2,kpCurrentID)))
                    
                    %calculate euclidian distance
                    euclid = norm(double(dLast(:,kpLastID) - dCurrent(:,kpCurrentID)));
                    
                    %new best match?
                    if euclid < bestMatchEuclid
                        bestMatchEuclid = euclid;
                        bestMatchKeypoint = fCurrent(:,kpCurrentID);
                    end
                end
            end
            
            %check if best match is good enough
            %add to matches [xo, xn, yo,yn]
            if numel(bestMatchKeypoint) > 0 && bestMatchEuclid < euclidThreshold
                % one row per match, format: xOld xNew yOld yNew
                matches = [matches; fLast(1,kpLastID) bestMatchKeypoint(1) fLast(2,kpLastID) bestMatchKeypoint(2)];
            end
        end
        
        %clear in case no matches were found
        x_move = [];
        y_move =[];
        
        if numel(matches )> 0
            X_n = matches(:,2);
            X_o = matches(:,1);
            Y_n = matches(:,4);
            Y_o = matches(:,3);
            
            %get movement vectors
            x_move = (X_n - X_o);
            y_move = (Y_n - Y_o);
            [x_mean,y_mean] = get_avg_movement(X_o,X_n,Y_o,Y_n);
            
            %discard non moving key points
            if discardNonMovingPoints == 1
                c = 0;
                for i = size(x_move):-1:1
                    if abs(x_move(i)) < moveThreshold && abs(y_move(i)) < moveThreshold
                        x_move(i) = [];
                        y_move(i) = [];
                        
                        %just for correct plotting
                        X_n(i) = [];
                        Y_n(i) = [];
                        
                        
                        c=c+1;
                        
                    end
                end
                
                fprintf('> non-moving key points discarded %i\n',c);
            end
            
            %discard all movements in the wrong direction
            if discardWrongMovements == 1
                if x_mean > 0
                    x_move(x_move <0) = [];
                elseif x_mean < 0
                    x_move(x_move >0) = [];
                end
                if y_mean > 0
                    y_move(y_move <0) = [];
                elseif y_mean < 0
                    y_move(y_move >0) = [];
                end
            end
        end
        %skip if no movement(otherwise errors)
        if numel(x_move) > 0 && numel(y_move) > 0
            
            %get mean movement (after deleting movements in wrong
            %direction)
            x_mean = mean(x_move);
            y_mean = mean(y_move);
            debug('> %i key points matched \n moving rectangle x %f and y %f\n',[numel(x_move),x_mean,y_mean]);
            %move objRect
            x2 = objRect(1)+x_mean;
            y2 = objRect(2)+y_mean;
            w2 = objRect(3);
            h2 = objRect(4);
            
            % compute new bounding box for display
            X = [objRect(1), x2]'; Y = [objRect(2), y2]'; W = [objRect(3), w2]'; H = [objRect(4), h2]';
            
            if plotKeypoints == 1
                plot_tmp(img,X_n,Y_n);
            end
            
            
            if plot_level == 1
                draw(rgb,X,Y,W,H);
                drawnow
                pause(0.1);
            elseif plot_level == 2
                plot_tmp(rgb,X_o,Y_o,X_n,Y_n,objRect,[x2, y2, w2, h2]);
                drawnow
                pause(0.1);
            end
            
            if mod(frameId,stopFrame) == 0
                input(['> Stopped at frame ',num2str(frameId),'. Press enter to continue']);
                fprintf('> Continuing...\n');
            end
            
            counter = counter + 1;
            
            % save result needed for ptb evaluation
            result(frameId,:) = [x2, y2, w2, h2];
            
            %build new objRect
            objRect = [x2, y2, w2, h2];
            
            %find keypoints of new img that are within the border of the
            %new objRect
            %(use array with all kp again, not only those that match with
            %old kp)
            fLast = [];
            dLast = [];
            for kpCurrentID = 1:size(fCurrent,2)
                if RectContainsPoint(objRect,fCurrent(1,kpCurrentID), fCurrent(2,kpCurrentID))
                    %add to fLast and dLast
                    fLast = [fLast fCurrent(:,kpCurrentID)];
                    dLast = [dLast dCurrent(:,kpCurrentID)];
                end
            end
        end
    end
elseif mode == 5
    svm = train_svm();
    % key points considered (per frame). the actual number will be lower as
    % low quality key points and false alignment are discarded later
    m = 100;
    
    % storing results (only needed for writing output file)
    result = zeros(numOfFrames,4);
    
    % format: x y w h
    bounds = load([directory 'init.txt']);
    
    % load and prepare first image
    imageName = fullfile(directory,sprintf('rgb/r-%d-%d.png', frames.imageTimestamp(startFrameId), frames.imageFrameID(startFrameId)));
    rgb = imread(imageName);
    I_o = preprocess_image(rgb);
    
    for frameId = startFrameId+1:numOfFrames
        imageName = fullfile(directory,sprintf('rgb/r-%d-%d.png', frames.imageTimestamp(frameId), frames.imageFrameID(frameId)));
        rgb = imread(imageName);
        fprintf('> processing frame %d\n',frameId)
        I_n = preprocess_image(rgb);
    
        % get new key points
        [f1,d1] = get_dsift_in_bound(I_o,bounds,m,4);
    
        X_o = f1(1,:);
        Y_o = f1(2,:);
        
        [X_n,Y_n] = align_keypoints_svm(svm,I_n,f1,d1,bounds);
        
        % Only extract aligned points. some points may have been discarded
        % by align_keypoints_svm (e.g. if key point was not relevant
        % enough)
        accepted = find(X_n);
        X_n = X_n(accepted);
        Y_n = Y_n(accepted);
        X_o_accepted = X_o(accepted)';
        Y_o_accepted = Y_o(accepted)';
        if length(X_n) < 1
            disp('target lost. Using old coordinates.');
            X_n = X_o;
            Y_n = Y_o;
        end
     
        % filter aligned points by eliminating supposedly false alignments
        [X_o_accepted,X_n,Y_o_accepted,Y_n] = discard_fp(X_o_accepted,X_n,Y_o_accepted,Y_n);
        [x_vec,y_vec] = get_avg_movement(X_o_accepted,X_n,Y_o_accepted,Y_n);
    
        debug('> moving rectangle x %f and y %f\n',[x_vec,y_vec]);
    
        % defining new rectangle
        x2 = bounds(1)+x_vec;
        y2 = bounds(2)+y_vec;
        w2 = bounds(3);
        h2 = bounds(4);
        rect2 = [x2, y2, w2, h2];

        if plot_level == 1
            draw(rgb,[bounds(1);x2],[bounds(2);y2],[bounds(3);w2],[bounds(4);h2]);
            drawnow
        elseif plot_level == 2
            plot_tmp(rgb,X_o_accepted,Y_o_accepted,X_n,Y_n,bounds,rect2);
            drawnow
        end
        
        if mod(frameId,stopFrame) == 0
            input(['> Stopped at frame ',num2str(frameId),'. Press enter to continue']);
            fprintf('> Continuing...\n');
        end
        
        result(frameId,:) = rect2;
        % reassign variables
        I_o = I_n;
        bounds = rect2;
    end
end

disp('> writing data')
WritePrinceton(setName,result(:,1),result(:,2),result(:,3),result(:,4));