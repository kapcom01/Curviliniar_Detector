function varargout = curvilinear_gui(varargin)
% CURVILINEAR MATLAB code for CURVILINEAR.fig
%      CURVILINEAR, by itself, creates a new CURVILINEAR or raises the existing
%      singleton*.

% Edit the above text to modify the response to help CURVILINEAR

% Last Modified by GUIDE v2.5 13-Jul-2015 18:42:36

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @curvilinear_OpeningFcn, ...
                   'gui_OutputFcn',  @curvilinear_OutputFcn, ...
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


% --- Executes just before CURVILINEAR is made visible.
function curvilinear_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to CURVILINEAR (see VARARGIN)

% Choose default command line output for CURVILINEAR
handles.output = hObject;

addpath('include/');
addpath('include/imoverlay/');
addpath('include/gaussgradient/');
addpath('include/hysterisis/');

% setup global vars
refresh_gaussian_graph(handles, [80 80], 8);
handles.overlay_color=[0 1 0];
handles.line_type = -1;

% Update handles structure
guidata(hObject, handles);


% --- Outputs from this function are returned to the command line.
function varargout = curvilinear_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pb_open.
function pb_open_Callback(hObject, eventdata, handles)
% hObject    handle to pb_open (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename, pathname] = uigetfile( ...
{'*.jpg;*.png;*.bmp;*.tif',...
'Images (*.jpg,*.png,*.bmp,*.tif)';
'*.*',  'All Files (*.*)'}, ...
'Select Image');
if filename == 0
    return;
end
axes(handles.axes1);
imshow(imread([pathname filename]));

update_output_image(handles);


% --- Executes on button press in pb_save.
function pb_save_Callback(hObject, eventdata, handles)
% hObject    handle to pb_save (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename, pathname] = uiputfile( ...
{'*.jpg;*.png;*.bmp;*.tif',...
'Images (*.jpg,*.png,*.bmp,*.tif)';
'*.*',  'All Files (*.*)'}, ...
'Select Folder');
if filename == 0
    return;
end
A = getimage(handles.axes2);
B = getimage(handles.axes3);
imwrite(A,[pathname 'binary_' filename]);
imwrite(B,[pathname 'overlay_' filename]);


function edit_lower_Callback(hObject, eventdata, handles)
% hObject    handle to edit_lower (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_lower as text
%        str2double(get(hObject,'String')) returns contents of edit_lower as a double
if strcmp(eventdata.Key, 'return')
    set(handles.slider2, 'Value', str2num(get(hObject,'String')));
    update_output_image(handles);
end


% --- Executes during object creation, after setting all properties.
function edit_lower_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_lower (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in checkbox3.
function checkbox3_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox3


% --- Executes on slider movement.
function slider1_Callback(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
set(handles.edit_upper, 'String', get(hObject, 'Value'));
update_output_image(handles);

% --- Executes during object creation, after setting all properties.
function slider1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% --- Executes during object creation, after setting all properties.
function slider2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider2_Callback(hObject, eventdata, handles)
% hObject    handle to slider2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
set(handles.edit_lower, 'String', get(hObject, 'Value'));
update_output_image(handles);


function edit_upper_Callback(hObject, eventdata, handles)
% hObject    handle to edit_upper (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_upper as text
%        str2double(get(hObject,'String')) returns contents of edit_upper as a double
if strcmp(eventdata.Key, 'return')
    set(handles.slider1, 'Value', str2num(get(hObject,'String')));
    update_output_image(handles);
end


% --- Executes during object creation, after setting all properties.
function edit_upper_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_upper (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit_sigma_Callback(hObject, eventdata, handles)
% hObject    handle to edit_sigma (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_sigma as text
%        str2double(get(hObject,'String')) returns contents of edit_sigma as a double


% --- Executes during object creation, after setting all properties.
function edit_sigma_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_sigma (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function slider_sigma_Callback(hObject, eventdata, handles)
% hObject    handle to slider_sigma (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
set(handles.edit_sigma, 'String', get(hObject, 'Value'));
update_output_image(handles);

% --- Executes during object creation, after setting all properties.
function slider_sigma_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider_sigma (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on key press with focus on edit_sigma and none of its controls.
function edit_sigma_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to edit_sigma (see GCBO)
% eventdata  structure with the following fields (see UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)
if strcmp(eventdata.Key, 'return')
    set(handles.slider_sigma, 'Value', str2num(get(hObject,'String')));
    update_output_image(handles);
end


% --- Executes when selected object is changed in panel_line_types.
function panel_line_types_SelectionChangeFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in panel_line_types 
% eventdata  structure with the following fields (see UIBUTTONGROUP)
%	EventName: string 'SelectionChanged' (read only)
%	OldValue: handle of the previously selected object or empty if none was selected
%	NewValue: handle of the currently selected object
% handles    structure with handles and user data (see GUIDATA)
handles.line_type=get(eventdata.NewValue, 'UserData');
guidata(hObject, handles);
update_output_image(handles);

% --- Executes when selected object is changed in panel_overlay_colors.
function panel_overlay_colors_SelectionChangeFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in panel_overlay_colors 
% eventdata  structure with the following fields (see UIBUTTONGROUP)
%	EventName: string 'SelectionChanged' (read only)
%	OldValue: handle of the previously selected object or empty if none was selected
%	NewValue: handle of the currently selected object
% handles    structure with handles and user data (see GUIDATA)
handles.overlay_color=get(eventdata.NewValue, 'BackgroundColor');
guidata(hObject, handles);
update_output_image(handles);

function refresh_sliders(handles,min,max)
if get(handles.slider1,  'Max')>max
    set(handles.slider1, 'Value', max);
end
if get(handles.slider2,  'Max')>max
    set(handles.slider2, 'Value', max);
end
if get(handles.slider1,  'Min')<min
    set(handles.slider1, 'Value', min);
end
if get(handles.slider2,  'Min')<min
    set(handles.slider2, 'Value', min);
end

set(handles.slider1, 'Max', max, 'Min', min);
set(handles.slider2, 'Max', max, 'Min', min);


function gfilt = refresh_gaussian_graph(handles, size, s)
gfilt = fspecial('gaussian', size, s);
axes(handles.axes_gauss_filter);
surf(gfilt);


function lamda = update_output_image(handles)

s = get(handles.slider_sigma, 'Value');
line_type = handles.line_type;

refresh_gaussian_graph(handles, [ceil(6*s) ceil(6*s)], s);

inputImage = getimage(handles.axes1);
lamda = vessel_center_line_detector(inputImage,s,line_type);

if line_type == -1
    % dark lines in light background
    % lamda must be >0
    minlamda=0;
    maxlamda=max(max(lamda));
elseif line_type == 1
    % bright lines in dark background
    % lamda must be <0
    maxlamda=0;
    minlamda=min(min(lamda));
elseif line_type == 0
    % both type of lines
end
refresh_sliders(handles,minlamda,maxlamda);

t1=get(handles.slider1,'Value');
t2=get(handles.slider2,'Value');
[tri,hys]=hysteresis3d(lamda,t1,t2,8);

axes(handles.axes2);
imshow(hys);
axes(handles.axes3);
imshow(imoverlay(inputImage, hys, handles.overlay_color));
