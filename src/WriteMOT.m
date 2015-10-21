
function WriteMOT(videoname, FrameNr,ObjID,X,Y,Width, Height)

mkdir('MOT');
fileID = fopen(strcat('MOT/',videoname,'.txt'), 'wt');

%put everything together
data  = [FrameNr, ObjID, X,Y,Width,Height];

%bring in order for MOT format
data = sortrows(data, [1 2]);

%Write data
for i = 1:size(data)

    frame = int2str(data(i,1));
    objID = int2str(data(i,2));
    x = int2str(data(i,3));
    y = int2str(data(i,4));
    width = int2str(data(i,5));
    height = int2str(data(i,6));
    fprintf(fileID,strcat(frame,',',objID,',' ,x, ',',y, ',', width,',', height,',-1,-1,-1,-1','\n'));

end

