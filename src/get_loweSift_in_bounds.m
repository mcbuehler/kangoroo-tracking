function [ f,d ] = get_loweSift_in_bounds( I, bounds, m ) 

%cut out rect
img = I(bounds(1):bounds(1) + bounds(3),bounds(2):bounds(2) + bounds(4));

%find keypoints
[X,Y] = detector(img, m);

%retranslate keypoints
X = X + bounds(1);
Y = Y + bounds(2);

%compute descriptors

    fc = [ X ; Y; scale(size(X,2)) ; zeros(1,size(X,2)) ] ;
    [qf,qd] = vl_sift(I,'frames',fc,'orientations');
    

    f = qf;
    d = qd;
    
    