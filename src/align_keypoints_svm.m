function [ X_n, Y_n ] = align_keypoints_svm(svm,I2,f1,d1,bounds)
global neighbourhood_size;
m = size(f1,2);

X_o = f1(1,:)';
X_n = zeros(m,1);
Y_o = f1(2,:)';
Y_n = zeros(m,1);

s = [];
%compute corresponding key point for each key point
for i = 1 : m
    nbs = get_neighbourhood(X_o(i),Y_o(i),neighbourhood_size);
    nbs_c = size(nbs,2);
    % compute sift for all neighbours
    fc = [ nbs(1,:) ; nbs(2,:); scale(nbs_c) ; zeros(1,nbs_c) ] ;
    [nbs_f,nbs_d] = vl_sift(I2,'frames',fc,'orientations') ;
    
    feat_vec = ones(size(nbs_d,2),1)*double(d1(:,i)') - double(nbs_d)';
    [~,scores] = predict(svm,feat_vec);
% get index where score for y=1 is max
    [~,m_i] = max(scores(:,2));
   
    if scores(m_i) > 0.6
        X_n(i) = nbs_f(1,m_i);
        Y_n(i) = nbs_f(2,m_i);
    end

end
end