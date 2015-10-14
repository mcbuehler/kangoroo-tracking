function descriptor = compute_sift(I,x,y)
%%% compute sift descriptor for keypoint located at pixel (x,y)
% check out
% au.mathworks.com/matlabcentral/fileexchange/50319-sift-feature-extreaction
% for computing sift descriptor
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
% You have to return this variable:
descriptor = zeros(128,1);

return