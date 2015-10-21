% function start
% videoname = 'test';
%  tic
% % X = randi(100,10000,1);
% % Y = randi(100,10000,1);
% % Width =randi(100,10000,1);
% % Height = randi(100,10000,1);
% % ObjIDs = randi(10,10000,1);
% % Frames = randi(30,10000,1);
% toc
% 
% X = randi(100,10000,1);
% Y = randi(100,10000,1);
% Width =randi(100,10000,1);
% Height = randi(100,10000,1);
% ObjIDs = randi(10,10000,1);
% 
% WritePrinceton(videoname,X,Y,Width, Height);
% WriteMOT(videoname,Frames, ObjIDs, X,Y,Width, Height);

function WritePrinceton(videoname, X,Y,Width, Height)
mkdir('princeton');
fileID = fopen(strcat('princeton/',videoname,'.txt'), 'wt');
for i = 1:size(X)

    x = int2str(X(i));
    y = int2str(Y(i));
    x2 = int2str(X(i) + Width(i));
    y2= int2str(Y(i) + Height(i));
    fprintf(fileID,strcat( x, ',', y, ',', x2,',', y2,',0', '\n'));

end

function WriteMOT(videoname, FrameNr,ObjID,X,Y,Width, Height)

mkdir('MOT');
fileID = fopen(strcat('MOT/',videoname,'.txt'), 'wt');

%put everything together
data  = [FrameNr, ObjID, X,Y,Width,Height];

%bring in order for MOT format
data = sortrows(data, [1 2]);
for i = 1:size(data)

    frame = int2str(data(i,1));
    objID = int2str(data(i,2));
    x = int2str(data(i,3));
    y = int2str(data(i,4));
    width = int2str(data(i,5));
    height = int2str(data(i,6));
    fprintf(fileID,strcat(frame,',',objID,',' ,x, ',',y, ',', width,',', height,',-1,-1,-1,-1','\n'));

end

