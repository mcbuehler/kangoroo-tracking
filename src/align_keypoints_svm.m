function [ X_n, Y_n ] = align_keypoints_svm(svm,I2,f1,d1,bounds)

m = size(f1,2);

X_o = f1(1,:)';
X_n = zeros(m,1);
Y_o = f1(2,:)';
Y_n = zeros(m,1);
%compute corresponding key point for each key point
for i = 1 : m
    nbs = get_neighbourhood(X_o(i),Y_o(i),5);
    nbs_c = size(nbs,2);
    % compute sift for all neighbours
    fc = [ nbs(1,:) ; nbs(2,:); scale(nbs_c) ; zeros(1,nbs_c) ] ;
    [nbs_f,nbs_d] = vl_sift(I2,'frames',fc,'orientations') ;
    feat_vec = [ones(size(nbs_d,2),1)*double(d1(:,i)'), double(nbs_d)'];
    [~,scores] = predict(svm,feat_vec);
% get index where score for y=1 is max
    [~,m_i] = max(scores(:,2));
    X_n(i) = nbs_f(1,m_i);
    Y_n(i) = nbs_f(2,m_i);
%   
    if getenv('DEBUG') == '1'
        plot([X_o(i) X_n(i)], [Y_o(i) Y_n(i)],'-b'); hold on;
        plot(X_o(i), Y_o(i),'r*'); 
        plot(X_n(i), Y_n(i),'g*');
        
    end
end

if getenv('DEBUG') == '1'
    % only used for debugging:
    xlabel('x'); ylabel('y');
    title('Aligning key points')
    legend('aligned points','previous key points','new new points');
    [x,y,w,h] = enlarge_rectangle(bounds(1),bounds(2),bounds(3),bounds(4),0.2);
    bounds = [x,y,w,h]; 
    window = [x x+w y y+h]
    axis(window)
    axis equal
    disp('done. press button')
    waitforbuttonpress
    hold off
% imshow(I2(int8(y):int8(y+h),int8(x):int8(x+w))); hold off;
end
end