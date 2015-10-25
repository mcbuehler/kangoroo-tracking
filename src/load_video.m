mov=VideoReader('../evaluation/own/pendulum.mp4');
vidFrames=read(mov,[1350 1360]);
size(vidFrames)

imshow(vidFrames(:,:,:,1));
return
nFrames=mov.NumberOfFrames;
frames = [];
imshow(vidFrames(1010))
% for i = 1 : 20
%     frames = [frames vidFrames(:,:,4000)];
% end

