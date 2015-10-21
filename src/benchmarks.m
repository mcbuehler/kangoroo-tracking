function addLocationToPrinceton(videoname, rect)
fileID = fopen(strcat(videoname, '_', 'princeton.txt'));
x = rect(1,1);
y = rect(1,2);
width = rect(1,3);
height = rect(1,4);
fprintf(fileID, strcat( x, ',', y, ',', x+width,',', y+height,',0'));

function addEntryToMOT
