function [X,Y,descriptors] = find_keypoints(I,x,y,width,height)
%%% finds key points withing the rectangle defined by (x,y,width,height) in image I
% 
% TODO: find our or ev. ask Massimo: how many keypoints needed -> n=?
%
% Alex
%
% ------ INPUT ------
% I : frame of image
% x,y : coordinates of top left point of rectange
% width,height : width and height of rectangle
%
% ------ OUTPUT ------
% X,Y : column vectors with n most significant key points withing rectangle
% descriptors : matrix (dimensions 128xn) containing the sift descriptors
% for the n key points in (X,Y)
% 
%%
n = 50;
bounds = [x y x+width y+height ]
[f,d] = vl_dsift(I,'bounds',[x y x+width y+height ],'norm');

while size(f,2) < 50
    disp('not enough key points found. making window bigger n')
    x = x-width; y = y-height; width = 2*width; height = 2*height;
    [f,d] = vl_dsift(I,'bounds',[x y x+width y+height],'norm');
end

% extract the n keypoints with highest contrast
% [f_sorted,sorted_i] = sort(f(3,:),'descend');

% biggest = sorted_i(1:50);

% assign result vars
% X = f(1,biggest)';
% Y = f(2,biggest)';
% descriptors = d(:,biggest);

perm = randperm(size(f,2));
sel = perm(1:n);
X = f(1,sel);
Y = f(2,sel);
descriptors = d(:,sel);

% subplot(1,2,1);
% plot_tmp(I,X,Y);

% points = [X';Y']
% h1 = vl_plotframe(points) ;
% h2 = vl_plotframe(points) ;
% set(h1,'color','k','linewidth',3) ;
% set(h2,'color','y','linewidth',2) ;


return
