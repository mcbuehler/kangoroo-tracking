function [ I_n ] = preprocess_image( I_o )
%% preprocessing: vl_sift wants image as class 'single'
%
I_tmp = rgb2gray(I_o);
I_n = im2single(I_tmp);
end

