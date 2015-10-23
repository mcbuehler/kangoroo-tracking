function [ I_n ] = smoothen_image( I_o )
%% smoothen image so we can use it in vl_dsift
binSize = 8; magnif=3;
I_n = vl_imsmooth(I_o,sqrt((binSize/magnif)^2 - .25));
end

