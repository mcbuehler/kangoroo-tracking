function [ I_n ] = preprocess_image( I_o )
%% preprocess for frames in video
%   Detailed explanation goes here
%
I_tmp = rgb2gray(I_o);
I_tmp = single(I_tmp);
% because we use vl_dsift smooth image:
binSize = 8; magnif=3;
I_n = vl_imsmooth(I_tmp,sqrt((binSize/magnif)^2 - .25));
end

