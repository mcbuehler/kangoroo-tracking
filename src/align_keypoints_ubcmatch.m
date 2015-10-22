function [ X_o Y_o X_n Y_n ] = align_keypoints_ubcmatch( I1,I2,r_o)
%ALIGN_KEYPOINTS_UBCMATCH Summary of this function goes here
%   Detailed explanation goes here
x1 = r_o(1);
y1 = r_o(2);
w1 = r_o(3);
h1 = r_o(4);
bounds = [x1 y1 x1+w1 y1+h1];
[f1,d1] = vl_dsift(I1,'bounds',bounds,'norm');

factor = 0.5;
% make window bigger
[x2, y2, w2, h2] = enlarge_rectangle(x1, y1, w1, h1, factor);

draw(I2,[x1 x2],[y1 y2],[w1 w2],[h1 h2]);
% waitforbuttonpress

bounds = [x2 y2 x2+w2 y2+h2];
[f2,d2] = vl_dsift(I2,'bounds',bounds,'norm');

[match,score] = vl_ubcmatch(d1,d2);
perm = randperm(size(match,2));

if length(perm)<50
    disp('object lost')
    perm = randperm(size(f1,2));
    sel = perm(1:50);
    X_o = f1(1,sel);
    Y_o = f1(2,sel);
    X_n = f2(1,sel);
    Y_n = f2(2,sel);
else
    sel = perm(1:50)

    match = match(:,sel);

    X_o = f1(1,match(1,:));
    Y_o = f1(2,match(1,:));
    X_n = f2(1,match(2,:));
    Y_n = f2(2,match(2,:));
end


end