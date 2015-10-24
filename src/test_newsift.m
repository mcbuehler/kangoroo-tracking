
 clear all;
I = imread('training_set/r-0-1.png');
imshow(I)
bounds = [238 182 324 279];
% 
% sift = getKeypointsInBounds(I,bounds,100)
% % plot_tmp(I,sift(1,:),sift(2,:))
% hold on
% waitforbuttonpress
% plot(sift(1,:),sift(2,:),'*r-')
% hold off

rect = [bounds(1), bounds(2), bounds(3)-bounds(1), bounds(4)-bounds(2)];
I_tmp = preprocess_image(I);
I_tmp = smoothen_image(I_tmp);
[sift,d] = get_dsift_in_bound(I_tmp,rect,10);
imshow(I)
hold on
waitforbuttonpress
plot(sift(1,:),sift(2,:),'*r')