function [ rect ] = fitToImage( rect, I )
% Makes sure rectangle fits into image I. If rectangle is located out of
% image, returns
w = size(I,2);
h = size(I,1);
% check start x and y value
if rect(1) < 0
    rect(1) = 0;
end
if rect(2) < 0
    rect(2) = 0;
end
if rect(1) > w || rect(2) > h
    disp('> object has left image.');
    return
end

if rect(1) + rect(3) > size(I,2)
    rect(3) = w - rect(1);
end
if rect(2) + rect(4) > size(I,1)
    rect(4) = h - rect(2);
end
    

end

