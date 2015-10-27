function [X2,Y2] = align_keypoints_euclid(I2,f1,d1,bounds)
%% Finds matching key points in new_frame
% Not all key points are aligned. if the matching value is below a
% threshold, it is discarded and the new coordinates are (0,0).
% in a second step implement the alignment for n old_frames (e.g. 4 frames)
% in order to improve matching in case of occlusion
% ------ INPUT ------
% I_o : previous frame
% I_n : subsequent frame
% X_o,Y_o : column vectors containing the n most significant key points for
% a certain object in I_o
%
% ------ OUTPUT ------
% X_n,Y_n : coordinates of new key points in I_n or -1,-1 for not aligned
% key points
m = size(f1,2);

X1 = f1(1,:)';
X2 = zeros(m,1);
Y1 = f1(2,:)';
Y2 = zeros(m,1);
%compute corresponding key point for each key point
for i = 1 : m
    debug('> processing neighbour %d\n',i);
    nbs = get_neighbourhood(X1(i),Y1(i),3);
    nbs_c = size(nbs,2)
    % compute sift for all neighbours
    fc = [ nbs(1,:) ; nbs(2,:); scale(nbs_c) ; zeros(1,nbs_c) ] ;
    [nbs_f,nbs_d] = vl_sift(I2,'frames',fc,'orientations') ;
    norms = ones(size(nbs_d,2),1) * -1;
    for k = 1 : size(nbs_d,2)
%         debug('> processing vector %d\n',k);
        norms(k) = norm(double(nbs_d(:,k) - d1(:,i)));
    end
    
    [dis,m_i] = min(norms);
    if getenv('DEBUG')
       fprintf('> minimal distance is %f\n',dis); 
    end
    X2(i) = nbs_f(1,m_i);
    Y2(i) = nbs_f(2,m_i);
    
end


end