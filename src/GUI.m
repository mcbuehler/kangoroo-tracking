%getrect(X,Y)
%drawRecht
%output as DSIFT


%TODO
%implement folder selection
%-for video files -> VideoReader(filename),while hasFrame(v) readFrame(v)
%-for image folders
%-order files alphabetisch
%-show first file
%-implement run -> calc with interface and show video
%extract first frame from video file
%show current mouse position while moving

%Not working
%folder selection


function varargout = GUI(varargin)
% GUI MATLAB code for GUI.fig
%      GUI, by itself, creates a new GUI or raises the existing
%      singleton*.
%
%      H = GUI returns the handle to a new GUI or the handle to
%      the existing singleton*.
%
%      GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI.M with the given input arguments.
%
%      GUI('Property','Value',...) creates a new GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before GUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GUI

% Last Modified by GUIDE v2.5 28-Oct-2015 20:15:51

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GUI_OpeningFcn, ...
                   'gui_OutputFcn',  @GUI_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT

%Constants
function value = rectThickness
value = 3;

function value = rectColor
value = [255 0 0];

%global variables

%X and Y value of the rectangle the user is currently drawing
function setFirstX(value)
global x;
x = value;

function value = getFirstX
global x;
value = x;

function setFirstY(value)
global y;
y = value;

function value = getFirstY
global y;
value = y;

%currently displayed image
function setCurrentImg(value)
global currentImg;
currentImg = value;

function value = getCurrentImg
global currentImg;
value = currentImg;

%rectangles that mark the objects the user has chosen
function setCurrentRects(value)
global currentRects;
currentRects = value;

function value = getCurrentRects
global currentRects;
value = currentRects;

%Preview rectangle; shown when user is drawing a rectangle
function setPreviewRect(value)
global previewRect;
previewRect = value;

function value = getPreviewRect
global previewRect;
value = previewRect;

%write folderpath to config
function writeImageFolderPath(value)
fileID = fopen('conf.txt', 'wt');
fprintf(fileID,'%',value);

%read folderpath from config
function value = readImageFolderPath
conf = fileread('conf.txt');
if size(conf) > 0
    value = conf(1);
else
    value = '';
end

% --- Executes just before GUI is made visible.
function GUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GUI (see VARARGIN)

% Choose default command line output for GUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes GUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);

%initialize rects
% setCurrentRects([]);
% setPreviewRect([]);

%load sample picture
% SetImage('image2.jpeg')%, handles.img);
% Redraw;

%populate popup boxes

handles = guidata(hObject);
handles.popMatching.String = {'SVM';'Euclidian Distance'};
handles.popDisplay.String = {'Show rectangles';'Show rectangles and key points'};

global ptbPath

%get folders
folder = dir (ptbPath);

%remove '.' and '..'
folder = folder (3:end);

handles.popVideo.String = {folder.name} ;
%set(handles.popDisplay,'String',temp_cellstr);


function Run(handles)

    videoname = handles.popVideo.UserData;
   
  
    switch handles.popMatching.value
        case 1
              matching = 5;
        case 2
              matching = 4;
    end

   stop = handles.checkStop.Value;
   plotLevel = handles.popDisplay.Value;
  
    run_ptb_function(videoname,matching, stop, plotLevel);
    

%redraws the current image and rectangles
function Redraw
%todo

%if ~(getCurrentImg == '')

    %add rectangles to image
    locImg = getCurrentImg;
    currentRects = getCurrentRects;
    if size(currentRects(),1) > 0
        for i = 1:size(currentRects,1)           
           locImg = insertShape(locImg,'Rectangle', currentRects(i,:), 'Color', rectColor, 'LineWidth', rectThickness); 
        end
    end
    
    %draw preview rect
    tempRect = getPreviewRect;
    if size(tempRect,1) > 0           
        locImg = insertShape(locImg,'Rectangle', tempRect(1,:), 'Color', rectColor, 'LineWidth', rectThickness); 
    end
    
    %draw image
    imageHandle = imshow(locImg);

    %install eventhandler for btndown
    imageHandle.ButtonDownFcn = @ImageBtnDown;
    
%end


%shows image and installs eventhandlers for it
function SetImage(path)%, image)

%read image file
%axes(image); why is this done in the excample?
imageObj = imread(path);

%set current image
setCurrentImg(imageObj)

%draw


%adds a rectangle
function AddRect(posX, posY, width, height)
newM = [getCurrentRects; [posX, posY, width, height]];
setCurrentRects(newM);



%deletes all rectangles
function ClearRects()
setCurrentRects([]);

% 
% %returns rectangle as [x y width height) from any given to points
% function value = CreateRect(x1,y1,x2,y2)
% if x2 > x1
%     leftX = x1;
%     rightX = x2;
% else
%     leftX = x2;
%     rightX = x1;
% end
% 
% if y2 < y1
%     upperY = y2;
%     lowerY = y1;
% else
%     upperY = y1;
%     lowerY = y2;
% end
% 
% value = [leftX upperY (rightX - leftX) (lowerY - upperY)];

%displays first image of imagefolder ore video file 
function ShowFirstImage

%getFiles
files = dir(readImageFolderPath);
if size(files,1) > 0
   SetImage(files(1,1));
end
Redraw;

%TODO

%executed when Mousebutton is released anywhere(there is no ButtonUpFcn for
%the Image)
function ImageBtnUp(objecthandle, eventdata)

%get UI handles
handles = guidata(objecthandle);

%Get get cursor location
cursorLocation = handles.img.CurrentPoint;
x = round(cursorLocation(1,1));
y =  round(cursorLocation(1,2));

%delete preview rectangle
setPreviewRect([]);

%write cursor location
%todo delete
txtSelection = handles.txtSelection;
locationStr = strcat( num2str(x) , ', ' ,num2str(y));
txtSelection.String = strcat( txtSelection.String, '---', locationStr);

%create and add rectangle to list
newRect = compute_rectangle([x;getFirstX], [y; getFirstY]);
AddRect(newRect(1),newRect(2),newRect(3),newRect(4));
Redraw;

%remove eventhandler for btnUp and mouse move
fig = gcf;
fig.WindowButtonUpFcn = '';
fig.WindowButtonMotionFcn = '';



%executed when Mousebutton is pressed on the image
function ImageBtnDown(objecthandle, eventdata)

%get UI handles
handles = guidata(objecthandle);

%Get get cursor location
cursorLocation = handles.img.CurrentPoint;
x = round(cursorLocation(1,1));
y =  round(cursorLocation(1,2));

%write location to global variables
setFirstX(x);
setFirstY(y);

%write cursor location
%todo delete
txtSelection = handles.txtSelection;
txtSelection.String = strcat( num2str(x) , ', ' ,num2str(y));

%create preview rectangle
setPreviewRect([x y 0 0]);

%install eventhandler for btnUp and mouse moving
fig = gcf;
fig.WindowButtonUpFcn = @ImageBtnUp;
fig.WindowButtonMotionFcn = @MouseMoving;

function MouseMoving(objecthandle, eventdata)

previewRect = getPreviewRect;
%if user is drawing a rectangle
if size(previewRect,1) > 0
    
    %get UI handles
    handles = guidata(objecthandle);

    %Get cursor location
    cursorLocation = handles.img.CurrentPoint;
    x = round(cursorLocation(1,1));
    y =  round(cursorLocation(1,2));
    
    %Update preview rect
    newPreviewRect = CreateRect([x; getFirstX],[y getFirstY]);
    setPreviewRect(newPreviewRect);
    
    %redraw
    Redraw;
end
    
% --- Outputs from this function are returned to the command line.
function varargout = GUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in btnSelect.
function btnSelect_Callback(hObject, eventdata, handles)
% hObject    handle to btnSelect (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%if ~strcmp(computer, 'PCWIN')
 %   errordlg('This function only works on a Windows PC. Please use the conf.txt instead.', 'error', 'modal');
%else
    folder = uigetfolder('Select folder','');
    writeImageFolderPath(folder);
    ShowFirstImage;
%end



% --- Executes on button press in btnClear.
function btnClear_Callback(hObject, eventdata, handles)
% hObject    handle to btnClear (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
ClearRects;
Redraw;

% --- Executes on button press in btnStart.
function btnStart_Callback(hObject, eventdata, handles)
% hObject    handle to btnStart (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Run(guidata(hObject));


% --- Executes on selection change in popVideo.
function popVideo_Callback(hObject, eventdata, handles)
% hObject    handle to popVideo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popVideo contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popVideo


% --- Executes during object creation, after setting all properties.
function popVideo_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popVideo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popMatching.
function popMatching_Callback(hObject, eventdata, handles)
% hObject    handle to popMatching (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popMatching contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popMatching


% --- Executes during object creation, after setting all properties.
function popMatching_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popMatching (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popDisplay.
function popDisplay_Callback(hObject, eventdata, handles)
% hObject    handle to popDisplay (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popDisplay contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popDisplay


% --- Executes during object creation, after setting all properties.
function popDisplay_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popDisplay (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in checkStop.
function checkStop_Callback(hObject, eventdata, handles)
% hObject    handle to checkStop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkStop
