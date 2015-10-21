function descriptors = compute_sift_for_keypoints(I,X,Y)
%%% compute most signi
%
% Alex
%
% ------ INPUT ------
% I : frame of image
% x,y : coordinates of keypoint
%
% ------ OUTPUT ------
% descriptor : column vector of size (128,1) containing the sift descriptor
% for key point
%%

binSize = 8 ;
magnif = 3 ;
[f,d] = vl_dsift(vl_imsmooth(I,sqrt((binSize/magnif)^2 - .25)),'bounds',[x y x+width y+height ],'norm');

% extract the n keypoints with highest contrast
[f_sorted,sorted_i] = sort(f(3,:),'descend');
biggest = sorted_i(1:50);

% assign result vars
X = f_sorted(1,biggest)';
Y = f_sorted(2,biggest)';
descriptors = d(:,biggest);
return