
global ptbPath 
%path to the directory containing the video folders

global setName
%name of the folder containing the video's image files

global neighbourhood_size

global file2Training_set_mode
% 1: using sift as features
% 2: using pixel values in a neighbourhood
% 3: using sift vector norm
% 4: using difference of sift descriptors

global matching_mode
% 1: match key points using svm
% 2: use ubcmatch
% 3: match key points using euclidean distance - use whole neighbourhood
% 4: match key points using euclidean distance - use keypoints in
% neighbourhood

global keypoint_selection_mode
%configures how to select maxKeypoint keypoints out of the array vl_sift
%returns
% 1: get points with highest contrast
% 2: get random points
% 3: order by contrast, split array in multiple arrays, use highest
% contrast points of each of the resulting arrays
% 4: get points with highest contrast in segments of image

global maxKeypoints
%number of keypoints chosen in get_dsift_in_bound - set high due to bad selection



global boundExpander
%defines the size of the considered neighbourhood for a keypoint while
%looking for matches
%notes:
%best results between 10 and 50(20 works most of the times)
%higher values often reduce accuracy and give unexpected results.
%low value results in loosing the ability to track fast moving objects.

global euclidThreshold
%defines the maximum euchlidian distance for matches
%every match above the threshold will get discarded
%notes:
%Best results with value between 100 and 300
%Low value increases the quality of matches, but reduces the number of
%matches


global discardNonMovingPoints
%discard keypoints matches that do not(or only slightly) move
%notes:
%Improves the accuracy in some videos, but often gives very unexpected
%results


global moveThreshold
%ignored if discardNonMovingPoints == 0
%defines how many pixels a keypoint has to move to be considered as
%"moving"

 
 global discardWrongMovements
 %if set to 1 all movement vectors that do not match the main movement
 %direction of the object are considered as wrong and will be discarded
 %notes:
 %if discardWrongMovements is turned off, the rectangle moves to slowly for
 %most videos. However there are some videos, where this option makes the
 %rectangle moves to fast

 
  global startFrameId
 %defines the start frame

  
 global useGUI 
 %not implemented
 %use GUI for selecting video and initial rectangle
 
 
 global stopEveryXImage
 %used for debugging
 %if set to a value x > 0, the video stops every x image
 
 
 global plotKeypoints
  %used for debugging
  %plots all matched keypoints in each image and waits for user

  
%parameters - modes
neighbourhood_size = 15;
file2Training_set_mode = 4;
keypoint_selection_mode = 4;
matching_mode = 4;

%parameters - accuracy
%make sure that enough keypoints remain!
maxKeypoints = 500;
boundExpander = 20;
discardWrongMovements = 1;
discardNonMovingPoints = 0;
euclidThreshold = 200;
moveThreshold = 5;

%parameter - other
startFrameId = 1;
useGUI = 0; 
stopEveryXImage = 0;
plotKeypoints =1;

setenv('DEBUG','1')
 

ptbPath = '../evaluation/ptb/';
% ptbPath = 'C:\Users\12400952\Downloads\EvaluationSet/'

setName = 'face_occ5';
setName = 'child_no1';
setName = 'new_ex_occ4';
setName = 'basketball1';
%setName = 'child_no2';
%setName = 'computerbar1';
%setName = 'toy_yellow_no';%-
%setName = 'toy_no_occ';
%setName = 'toy_no';%- fast
%setName = 'wdog_no1';%-
%setName = 'wr_no';
%setName = 'two_book';
%setName = 'walking_no_occ'; %-

  