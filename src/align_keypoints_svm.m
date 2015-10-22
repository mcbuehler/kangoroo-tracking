function [ X_o, Y_o, X_n, Y_n ] = align_keypoints_svm(svm, I1,I2,r_o)

% calculate old keypoints
x1 = r_o(1);
y1 = r_o(2);
w1 = r_o(3);
h1 = r_o(4);
bounds = [x1 y1 x1+w1 y1+h1];
[f1,d1] = vl_dsift(I1,'bounds',bounds,'norm');
X_o = f1(1,:);
Y_o = f1(2,:);

% pick random 50
m = size(X_o,2)
random = randperm(m);
sel = random(1:50);
X_o = X_o(sel);
Y_o = Y_o(sel);
f1 = f1(1:2,sel);
X_n = ones(50,1);
Y_n = ones(50,1);



d1 = d1(:,sel);
m = size(X_o,2);
%compute corresponding key point for each key point
for i = 1 : m
    nbs = get_neighbourhood(X_o(i),Y_o(i),6);
    nbs_c = size(nbs,1);
    % compute sift for all neighbours
    fc = [ nbs(:,1)' ; nbs(:,2)'; ones(1,nbs_c) ; zeros(1,nbs_c) ] ;
    [~,nbs_d] = vl_sift(I2,'frames',fc) ;
    % svm demands conversion to double
    feat_vec = [ones(nbs_c,1)*double(d1(:,i)'), double(nbs_d)'];
    [L,scores] = predict(svm,feat_vec);
    [mx,m_i] = max(scores(:,2));
    X_n(i) = nbs(m_i,1);
    Y_n(i) = nbs(m_i,2);
    
end

end