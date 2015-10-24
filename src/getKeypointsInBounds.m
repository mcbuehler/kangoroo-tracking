 function value = getKeypointsInBounds(I,bounds,maxKeypoints)
%imgOrigin = imread('E:\ippr\sample.jpg');
%%initial image

imgOrigin = I(bounds(1):bounds(3),bounds(2):bounds(4));


row=256; 
colum=256; 

scaleX = size(imgOrigin,1) / colum;
scaleY = size(imgOrigin,2) / row;

img=imresize(imgOrigin,[row,colum]);
% img=rgb2gray(img);
% img=histeq(img);
img=im2double(img);
origin=img; % used for plotting
% img=medfilt2(img);

%% Scale-Space Extrema Detection

% original sigma and the number of actave can be modified. the larger
% sigma0, the more quickly-smooth images
sigma0=sqrt(2);
octave=3;%6*sigma*k^(octave*level)<=min(m,n)/(2^(octave-2))
level=3;
D=cell(1,octave);
for i=1:octave
D(i)=mat2cell(zeros(row*2^(2-i)+2,colum*2^(2-i)+2,level),row*2^(2-i)+2,colum*2^(2-i)+2,level);
end
% first image in first octave is created by interpolating the original one.
temp_img=kron(img,ones(2));
temp_img=padarray(temp_img,[1,1],'replicate');
%create the DoG pyramid.
for i=1:octave
    temp_D=D{i};
    for j=1:level
        scale=sigma0*sqrt(2)^(1/level)^((i-1)*level+j);
        f=fspecial('gaussian',[1,floor(6*scale)],scale);
        L1=temp_img;
        if(i==1&&j==1)
        L2=conv2(temp_img,f,'same');
        L2=conv2(L2,f','same');
        temp_D(:,:,j)=L2-L1;
        else
        L2=conv2(temp_img,f,'same');
        L2=conv2(L2,f','same');
        temp_D(:,:,j)=L2-L1;
        L1=L2;
        if(j==level)
            temp_img=L1(2:end-1,2:end-1);
        end
        end
    end
    D{i}=temp_D;
    temp_img=temp_img(1:2:end,1:2:end);
    temp_img=padarray(temp_img,[1,1],'both','replicate');
end

%% Keypoint Localistaion
% search each pixel in the DoG map to find the extreme point

interval=level-1; % was ist das Interval?
number=0;
for i=2:octave+1
    number=number+(2^(i-octave)*colum)*(2*row)*interval;
end
extrema=zeros(1,4*number);
flag=1;
for i=1:octave
    [m,n,~]=size(D{i});
    m=m-2;
    n=n-2;
    volume=m*n/(4^(i-1));
    for k=2:interval      
        for j=1:volume
            % starter=D{i}(x+1,y+1,k);
            x=ceil(j/n);
            y=mod(j-1,m)+1;
            sub=D{i}(x:x+2,y:y+2,k-1:k+1);
            large=max(max(max(sub)));
            little=min(min(min(sub)));
            if(large==D{i}(x+1,y+1,k))
                temp=[i,k,j,1];
                extrema(flag:(flag+3))=temp;
                flag=flag+4;
            end
            if(little==D{i}(x+1,y+1,k))
                temp=[i,k,j,-1];
                extrema(flag:(flag+3))=temp;
                flag=flag+4;
            end
        end
    end
end
idx= extrema==0;
extrema(idx)=[];


%% accurate keypoint localization 
%eliminate the point with low contrast or poorly localised on an edge
% x:|,y:-- x is for vertial and y is for horizontal
% value comes from the paper.

threshold=0.1;
r=10;
extr_volume=length(extrema)/4;
[m,n]=size(img);
secondorder_y=conv2([-1,-1;1,1],[-1,-1;1,1]);
for i=1:octave
    for j=1:level
        test=D{i}(:,:,j);
        temp=-1./conv2(test,secondorder_y,'same').*conv2(test,[-1,-1;1,1],'same');
        D{i}(:,:,j)=temp.*conv2(test',[-1,-1;1,1],'same')*0.5+test;
    end
end


%array that contains z value for each key point
zValues = [];

for i=1:extr_volume
    x=floor((extrema(4*(i-1)+3)-1)/(n/(2^(extrema(4*(i-1)+1)-2))))+1;
    y=mod((extrema(4*(i-1)+3)-1),m/(2^(extrema(4*(i-1)+1)-2)))+1;
    rx=x+1;
    ry=y+1;
    rz=extrema(4*(i-1)+2);
    z=D{extrema(4*(i-1)+1)}(rx,ry,rz);
    zValues = [zValues;i abs(z)];
    if(abs(z)<threshold)
        extrema(4*(i-1)+4)=0;
    end
end

%discard surplus key points
disp(int2str(size(zValues,1)));
if size(zValues,1) > maxKeypoints
 zValues =   sortrows(zValues, -2);
    
    %all surplus keypoints
   for k = (maxKeypoints +1):size(zValues,1)
       %discard
        extrema(4*(zValues(k,1)-1)+4)=0;
   end
end




idx=find(extrema==0);
idx=[idx,idx-1,idx-2,idx-3];
extrema(idx)=[];
extr_volume=length(extrema)/4;

for i=1:extr_volume
    x=floor((extrema(4*(i-1)+3)-1)/(n/(2^(extrema(4*(i-1)+1)-2))))+1;
    y=mod((extrema(4*(i-1)+3)-1),m/(2^(extrema(4*(i-1)+1)-2)))+1;
    rx=x+1;
    ry=y+1;
    rz=extrema(4*(i-1)+2);
        Dxx=D{extrema(4*(i-1)+1)}(rx-1,ry,rz)+D{extrema(4*(i-1)+1)}(rx+1,ry,rz)-2*D{extrema(4*(i-1)+1)}(rx,ry,rz);
        Dyy=D{extrema(4*(i-1)+1)}(rx,ry-1,rz)+D{extrema(4*(i-1)+1)}(rx,ry+1,rz)-2*D{extrema(4*(i-1)+1)}(rx,ry,rz);
        Dxy=D{extrema(4*(i-1)+1)}(rx-1,ry-1,rz)+D{extrema(4*(i-1)+1)}(rx+1,ry+1,rz)-D{extrema(4*(i-1)+1)}(rx-1,ry+1,rz)-D{extrema(4*(i-1)+1)}(rx+1,ry-1,rz);
        deter=Dxx*Dyy-Dxy*Dxy;
        R=(Dxx+Dyy)/deter;
        R_threshold=(r+1)^2/r;
        if(deter<0||R>R_threshold)
            extrema(4*(i-1)+4)=0;
        end
        
end
idx=find(extrema==0);
idx=[idx,idx-1,idx-2,idx-3];
extrema(idx)=[];
x=floor((extrema(3:4:end)-1)./(n./(2.^(extrema(1:4:end)-2))))+1;
y=mod((extrema(3:4:end)-1),m./(2.^(extrema(1:4:end)-2)))+1;
ry=floor(y./2.^(octave-1-extrema(1:4:end)));
rx=floor(x./2.^(octave-1-extrema(1:4:end)));

%plot original img with keypoints

rx = scaleX*rx;
ry = scaleY*ry;
value = [rx;ry];

% figure ;
% imshow(imgOrigin)
% hold on
% plot(ry,rx, 'r+');
% hold off

value(1,:) = ones(1,size(value,2))*bounds(1) + value(1,:);
value(2,:) = ones(1,size(value,2))*bounds(2) + value(2,:);

