function varargout = classficationGUI_v3(varargin)
% CLASSFICATIONGUI_V3 MATLAB code for classficationGUI_v3.fig
%      CLASSFICATIONGUI_V3, by itself, creates a new CLASSFICATIONGUI_V3 or raises the existing
%      singleton*.
%
%      H = CLASSFICATIONGUI_V3 returns the handle to a new CLASSFICATIONGUI_V3 or the handle to
%      the existing singleton*.
%
%      CLASSFICATIONGUI_V3('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CLASSFICATIONGUI_V3.M with the given input arguments.
%
%      CLASSFICATIONGUI_V3('Property','Value',...) creates a new CLASSFICATIONGUI_V3 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before classficationGUI_v3_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to classficationGUI_v3_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @classficationGUI_v3_OpeningFcn, ...
                   'gui_OutputFcn',  @classficationGUI_v3_OutputFcn, ...
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

% --- Executes just before classficationGUI_v3 is made visible.
function classficationGUI_v3_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to classficationGUI_v3 (see VARARGIN)
% Choose default command line output for classficationGUI_v3
handles.output = hObject;

% Update handles structure
tblRandomized = readtable('randomTable.xlsx'); % Read the random table spreadsheet
handles.name = tblRandomized.newName;
handles.annotation = tblRandomized.annotation;
handles.buffer.data = {};
handles.buffer.active = {};
guidata(hObject, handles); %Update the GUI handles

% Create the activeX server and make it visible
handles.e = actxserver('Excel.Application');
handles.eWorkbook = handles.e.Workbooks.Open([pwd filesep 'randomTable.xlsx']);
handles.e.Visible = 1;

% Start a new video session
startNewSession(hObject, handles);

% --- Outputs from this function are returned to the command line.
function varargout = classficationGUI_v3_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% --- Save a classification to the spreadsheet
function saveClassification(data, hObject, handles)
global previousIndex %Index used in the case of a misclick
handles.annotation{handles.active} = data;
previousIndex = handles.active+1;


%Update the excel sheet
range = ['F' num2str(handles.active + 1) ':' 'F' num2str(handles.active + 1)];
saveFigureRange = ['G' num2str(handles.active + 1) ':' 'G' num2str(handles.active + 1)];
% disp(range);

if (handles.wantAsFigure.Value == 1)
    eActivesheetRange = get(handles.e.Activesheet,'Range',saveFigureRange);
    eActivesheetRange.Value = {'TRUE'};
end

eActivesheetRange = get(handles.e.Activesheet,'Range',range);
eActivesheetRange.Value = {data};
handles.eWorkbook.Save;
handles.eWorkbook.Saved = 1;

handles.buffer.data{end+1} = data;
handles.buffer.active{end+1} = handles.active;
guidata(hObject, handles);
startNewSession(hObject, handles)

% --- Undo the previous classification in the event of a misclickButton
function undoClassifcation(data, hObject, handles)
global previousIndex
handles.annotation{handles.active} = data;

% xlswrite('randomTable.xlsx',{data},['F' num2str(previousIndex) ':' 'F' num2str(previousIndex)]);
%Update the excel sheet
range = ['F' num2str(previousIndex) ':' 'F' num2str(previousIndex)];
eActivesheetRange = get(handles.e.Activesheet,'Range',range);
eActivesheetRange.Value = {data};
handles.eWorkbook.Save;
handles.eWorkbook.Saved = 1;

guidata(hObject, handles);
startNewSession(hObject, handles)

% --- Executes on button press in unusableButton.
% --- Button for the classification: unusable
function unusableButton_Callback(hObject, eventdata, handles)
saveClassification('unusable1', hObject, handles);

% --- Executes on button press in noActivityButton.
% --- Button for the classification: none
function noActivityButton_Callback(hObject, eventdata, handles)
saveClassification('none', hObject, handles);

% --- Executes on button press in largeWavesButton.
% --- Button for the classification: spikes
function largeWavesButton_Callback(hObject, eventdata, handles)
saveClassification('waves', hObject, handles);

% --- Executes on button press in smallLocalWavesButton.
% --- Button for the classification: transient
function smallLocalWavesButton_Callback(hObject, eventdata, handles)
saveClassification('transient', hObject, handles);

% --- Executes on button press in spikesButton.
% --- Button for the classification: waves
function spikesButton_Callback(hObject, eventdata, handles)
saveClassification('spikes', hObject, handles);

% --- Executes on button press in flutteringButton.
% --- Button for the classification: fluttering
function flutteringButton_Callback(hObject, eventdata, handles)
saveClassification('fluttering', hObject, handles)

% --- Executes on button press in misclickButton.
% --- Button in the event that a misclickButton/misclassification occurs
function misclickButton_Callback(hObject, eventdata, handles)
undoClassifcation('empty', hObject, handles)

% --- Executes on button press in unknownActivity.
function unknownActivity_Callback(hObject, eventdata, handles)
% hObject    handle to unknownActivity (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
saveClassification('unknown', hObject, handles)

% --- Executes on button press in finishedButton.
function finishedButton_Callback(hObject, eventdata, handles)
% SaveAs(handles.eWorkbook,'randomTable.xlsx')
handles.eWorkbook.Save;
handles.eWorkbook.Saved = 1;
handles.eWorkbook.Close;
handles.e.Quit;
handles.e.delete;
handles.figure1.delete;
error('Finish button was clicked, program terminated');

% --- Executes on button press in wantAsFigure.
function wantAsFigure_Callback(hObject, eventdata, handles)
% hObject    handle to wantAsFigure (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of wantAsFigure

% --- Function that creates a new video session to be played on the GUI
function startNewSession(hObject, handles)
annotation = handles.annotation;
name = handles.name;
% [sortedNames,idx] = sort(name);
% sortedAnnotations = annotation(idx);
handles.wantAsFigure.Value = 0;
emptyIdx = find(strcmp(annotation, 'waves'));
%emptyIdx = find(strcmp(annotation, 'unknown'));
disp(['Percent Completion: ' num2str(1 - length(emptyIdx)/length(annotation))]);
disp(['Remaining Classifications: ' num2str(length(emptyIdx))]);
fprintf('\n');
emptyIdx = emptyIdx(randperm(length(emptyIdx)));
for i = 1:length(emptyIdx)
    filename = ['randomized' filesep name{emptyIdx(i)} '.mat'];
    if exist(filename, 'file')
        emptyIdx = emptyIdx(i);
        break
    end
end
handles.active = emptyIdx;
axes(handles.axes1)
video = load(filename);
handles.video = video.video;
guidata(hObject, handles);
% --- Turn off the pushbuttons until the video is played through at least
% once
set(handles.unusableButton,'Enable','off'); 
set(handles.noActivityButton,'Enable','off'); 
set(handles.largeWavesButton,'Enable','off'); 
set(handles.smallLocalWavesButton,'Enable','off'); 
set(handles.spikesButton,'Enable','off');
set(handles.flutteringButton,'Enable','off');
set(handles.unknownActivity,'Enable','off');
playvideo(hObject, handles)

% --- function that plays the video and adjusts the brightness/contrast
function playvideo(hObject, handles)
tmp = 1;
% handles.brightness.Value = 0;
% handles.contrast.Value = 1;
histdouble = double(handles.video(:));
handles.brightness.Value = (prctile(histdouble,0.4)-min(histdouble)) / (max(histdouble)-min(histdouble));
handles.contrast.Value = (prctile(histdouble,99.98)-min(histdouble)) / (max(histdouble)-min(histdouble));
while true
    for i = 1:size(handles.video, 3)
        % imshow(handles.video(:,:,i), [min(handles.video(:)) (max(handles.video(:)))]);
        displayMin = round((max(handles.video(:)) - min(handles.video(:)))*handles.brightness.Value + min(handles.video(:)));
        displayMax = round(max(handles.video(:)) - ((max(handles.video(:))-min(handles.video(:)))*(1-handles.contrast.Value)));
        imshow(handles.video(:,:,i), [displayMin displayMax]);
        drawnow
        pause(0.1)
    end
    % --- Turn on the pushbuttons until the video is played through at least
    % once
    if tmp
        set(handles.unusableButton,'Enable','on'); 
        set(handles.noActivityButton,'Enable','on'); 
        set(handles.largeWavesButton,'Enable','on'); 
        set(handles.smallLocalWavesButton,'Enable','on'); 
        set(handles.spikesButton,'Enable','on'); 
        set(handles.flutteringButton,'Enable','on'); 
        set(handles.unknownActivity,'Enable','on');
    tmp = 0;
    end
end

% --- Executes on slider movement.
% --- First slider to change the brighntess of the displayed image
function brightness_Callback(hObject, eventdata, handles)
% hObject    handle to brightness (see GCBO)
% handles    structure with handles and user data (see GUIDATA)
% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

% --- Executes during object creation, after setting all properties.
function brightness_CreateFcn(hObject, eventdata, handles)
% hObject    handle to brightness (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% --- Executes on slider movement.
% --- Second slider to change the contrast of the displayed image
function contrast_Callback(hObject, eventdata, handles)
% hObject    handle to contrast (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

% --- Executes during object creation, after setting all properties.
function contrast_CreateFcn(hObject, eventdata, handles)
% hObject    handle to contrast (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% --- Executes during object creation, after setting all properties.
function figure1_CreateFcn(hObject, eventdata, handles)
