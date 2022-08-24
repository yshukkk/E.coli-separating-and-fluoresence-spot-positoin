function varargout = sora_spot(varargin)
% THREECOLORCONC MAXPTVAL-file for threecolorconc.fig
%      THREECOLORCONC, by itself, creates areaval new THREECOLORCONC or raises the existing
%      singleton*.
%
%      H = THREECOLORCONC returns the handle to areaval new THREECOLORCONC or the handle to
%      the existing singleton*.
%
%      THREECOLORCONC('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in THREECOLORCONC.MAXPTVAL with the given
%      input arguments.
%
%      THREECOLORCONC('Property','Value',...) creates areaval new
%      THREECOLORCONC or raises the
%      existing singleton*.  Starting from the left, property value pairs
%      are
%      applied to the GUI before viewstk3conc_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to threecolorconc_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".im
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help threecolorconc

% Last Modified by GUIDE v2.5 04-Oct-2018 18:05:28


% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @threecolorconc_OpeningFcn, ...
                   'gui_OutputFcn',  @threecolorconc_OutputFcn, ...
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


% --- Executes just before threecolorconc is made visible.
function threecolorconc_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in areaval future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to threecolorconc (see VARARGIN)

string1=mat2str(cell2mat(varargin(1)));
string2=mat2str(cell2mat(varargin(2)));
string3=mat2str(cell2mat(varargin(3)));
%imfilename1=[string1 '\' string2 'dic.stk'];
%imfilename2=[string1 '\' string2 'gfp.stk'];

imfilename1=[string1(2:end-1) '\' string2(2:end-1) 'BF.tif'];
imfilename2=[string1(2:end-1) '\' string2(2:end-1) string3(2:end-1) '.tif'];

%imfilename1=[string1 '\dic' string2 '.stk'];
%imfilename2=[string1 '\gfp' string2 '.stk'];

%string1=mat2str(cell2mat(varargin(1)));
%imfilename1=[string1 'dic.stk' ];
%imfilename2=[string1 'gfp.stk' ];
handles.ph = tiffreadnew2(imfilename1);
handles.fl = tiffreadnew2(imfilename2);
handles.phframe=1;
handles.flframe=1;
handles.phmax=2000;
handles.phmin=0;
handles.flmax=2000;
handles.flmin=200;
axes(handles.flaxes);
handles.flim=imshow(handles.fl(handles.flframe).data,[handles.flmin,handles.flmax]);
set(handles.flim, 'HitTest', 'off');
axes(handles.phaxes);
handles.phim=imshow(handles.ph(handles.phframe).data,[handles.phmin,handles.phmax]);
set(handles.phim, 'HitTest', 'off');
set(handles.figure1, 'HitTest', 'off');

handles.boxtype=1;
handles.thr_size=8;
handles.thr_SNR=2;
handles.sd=1.3;

handles.savefile='data';

handles.celldatas=[];
handles.spotdatas=[];


% Choose default command line output for viewstk3conc
handles.output = hObject;

% Update handles structureb
guidata(hObject, handles);

% UIWAIT makes viewstk3conc wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = threecolorconc_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in areaval future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton21. 'save'
function pushbutton21_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton21 (see GCBO)
% eventdata  reserved - to be defined in areaval future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%mcdots=handles.mcdots;

celldata=handles.celldatas;
spotdata=handles.spotdatas;
save([handles.savefile '-cell'], 'celldata');
save([handles.savefile '-spot'], 'spotdata'); 

guidata(hObject,handles);



% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in areaval future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1

str = get(hObject, 'String');
val = get(hObject,'Value');
% Set current data to the selected data set.
switch str{val};
case '9 pt box'
   handles.boxtype = 1;
case 'user-defined box'
   handles.boxtype = 3;
end
% Save the handles structure.
guidata(hObject,handles)



% --- Executes during object creation, after setting all properties.
function popupmenu1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in areaval future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have areaval white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in areaval future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
cframe=handles.flframe;
if(cframe~=1)
    handles.flframe=cframe-1;
end
axes(handles.flaxes);
handles.flim=imshow(handles.fl(handles.flframe).data,[handles.flmin,handles.flmax]);
set(handles.flim, 'HitTest', 'off');
set(handles.frval1,'String',num2str(handles.flframe));
%{
if(handles.row~=0)
    
    csize=size(handles.fl(handles.flframe).data);
    row=handles.row;
    col=handles.col;
    val=handles.fl(handles.flframe).data(row,col);

    sumval=0;
    for i=(row-1):(row+1),
        for j=(col-1):(col+1),
            if((1<=i)&(i<=csize(1)))
                if((1<=j)&(j<=csize(2)))
                    sumval=sumval+handles.fl(handles.flframe).data(i,j);
                end
            end
        end
    end

    set(handles.ptvalsum, 'String',num2str(sumval/9));
    set(handles.ptval, 'String',num2str(val));
    set(handles.xyval,'String',[num2str(col) ', ' num2str(row)]);

    row0=row;
    col0=col;
    maxsumval=0;

    for row=(row0-3):(row0+3),
        for col=(col0-3):(col0+3),
            sumval=0;
            for i=(row-1):(row+1),
                for j=(col-1):(col+1),
                    if((1<=i)&(i<=csize(1)))
                        if((1<=j)&(j<=csize(2)))
                            sumval=sumval+handles.fl(handles.flframe).data(i,j);
                        end
                    end
                end
            end
            if(sumval>maxsumval)
                maxsumval=sumval;
            end
        end
    end

    set(handles.maxvalsum, 'String',num2str(maxsumval/9));
    
    handles.flcursor=rectangle('Position',[col0 row0 1 1],'EdgeColor','g');
    set(handles.flcursor,'HitTest', 'off');
    handles.flcursor=rectangle('Position',[col0-3 row0-3 6 6],'EdgeColor','r');
    set(handles.flcursor,'HitTest', 'off');
end
%}
guidata(hObject,handles);

% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in areaval future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
cframe=handles.flframe;
if(cframe~=size(handles.fl,2))
    handles.flframe=cframe+1;
end
axes(handles.flaxes);
handles.flim=imshow(handles.fl(handles.flframe).data,[handles.flmin,handles.flmax]);
set(handles.flim, 'HitTest', 'off');
set(handles.frval1,'String',num2str(handles.flframe));
%{
if(handles.row~=0)
    
    csize=size(handles.fl(handles.flframe).data);
    row=handles.row;
    col=handles.col;
    val=handles.fl(handles.flframe).data(row,col);

    sumval=0;
    for i=(row-1):(row+1),
        for j=(col-1):(col+1),
            if((1<=i)&(i<=csize(1)))
                if((1<=j)&(j<=csize(2)))
                    sumval=sumval+handles.fl(handles.flframe).data(i,j);
                end
            end
        end
    end

    set(handles.ptvalsum, 'String',num2str(sumval/9));
    set(handles.ptval, 'String',num2str(val));
    set(handles.xyval,'String',[num2str(col) ', ' num2str(row)]);

    row0=row;
    col0=col;
    maxsumval=0;

    for row=(row0-3):(row0+3),
        for col=(col0-3):(col0+3),
            sumval=0;
            for i=(row-1):(row+1),
                for j=(col-1):(col+1),
                    if((1<=i)&(i<=csize(1)))
                        if((1<=j)&(j<=csize(2)))
                            sumval=sumval+handles.fl(handles.flframe).data(i,j);
                        end
                    end
                end
            end
            if(sumval>maxsumval)
                maxsumval=sumval;
            end
        end
    end

    set(handles.maxvalsum, 'String',num2str(maxsumval/9));
    
    handles.flcursor=rectangle('Position',[col0 row0 1 1],'EdgeColor','g');
    set(handles.flcursor,'HitTest', 'off');
    handles.flcursor=rectangle('Position',[col0-3 row0-3 6 6],'EdgeColor','r');
    set(handles.flcursor,'HitTest', 'off');
end
%}
guidata(hObject,handles);


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in areaval future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
cframe=handles.phframe;
if(cframe~=1)
    handles.phframe=cframe-1;
end
axes(handles.phaxes);
handles.phim=imshow(handles.ph(handles.phframe).data,[handles.phmin,handles.phmax]);
set(handles.phim, 'HitTest', 'off');
set(handles.frval2,'String',num2str(handles.phframe));

handles.flframe=handles.phframe;
handles.flframe2=handles.phframe;
axes(handles.flaxes);
handles.flim=imshow(handles.fl(handles.flframe).data,[handles.flmin,handles.flmax]);
set(handles.flim, 'HitTest', 'off');
set(handles.frval1,'String',num2str(handles.flframe));

guidata(hObject,handles);


% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in areaval future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
cframe=handles.phframe;
if(cframe~=size(handles.ph,2))
    handles.phframe=cframe+1;
end
axes(handles.phaxes);
handles.phim=imshow(handles.ph(handles.phframe).data,[handles.phmin,handles.phmax]);
set(handles.phim, 'HitTest', 'off');
set(handles.frval2,'String',num2str(handles.phframe));

handles.flframe=handles.phframe;
handles.flframe2=handles.phframe;
handles.flframe3=handles.phframe;
axes(handles.flaxes);
handles.flim=imshow(handles.fl(handles.flframe).data,[handles.flmin,handles.flmax]);
set(handles.flim, 'HitTest', 'off');
set(handles.frval1,'String',num2str(handles.flframe));



guidata(hObject,handles);

% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in areaval future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
cframe=handles.flframe-10;
if(cframe>=1)
    handles.flframe=cframe;
else
    handles.flframe=1;
end
axes(handles.flaxes);
handles.flim=imshow(handles.fl(handles.flframe).data,[handles.flmin,handles.flmax]);
set(handles.flim, 'HitTest', 'off');
set(handles.frval1,'String',num2str(handles.flframe));
guidata(hObject,handles);

% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in areaval future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
cframe=handles.flframe+10;
if(cframe<=size(handles.fl,2))
    handles.flframe=cframe;
else
    handles.flframe=size(handles.fl,2);
end
axes(handles.flaxes);
handles.flim=imshow(handles.fl(handles.flframe).data,[handles.flmin,handles.flmax]);
set(handles.flim, 'HitTest', 'off');
set(handles.frval1,'String',num2str(handles.flframe));
guidata(hObject,handles);



function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in areaval future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as areaval double
user_num = str2num(get(hObject,'String'));
if isnan(user_num)
    errordlg('You must enter a numeric value','Bad Input','modal')
    return
end
if (user_num>=handles.flmax)
    errordlg('You must enter a value less than the max','Bad Input','modal')
    return
end
handles.flmin=user_num;
axes(handles.flaxes);
handles.flim=imshow(handles.fl(handles.flframe).data,[handles.flmin,handles.flmax]);
set(handles.flim, 'HitTest', 'off');
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in areaval future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have areaval white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in areaval future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as areaval double
user_num = str2num(get(hObject,'String'));
if isnan(user_num)
    errordlg('You must enter a numeric value','Bad Input','modal')
    return
end
if (user_num<=handles.flmin)
    errordlg('You must enter a value greater than the min','Bad Input','modal')
    return
end
handles.flmax=user_num;
axes(handles.flaxes);
handles.flim=imshow(handles.fl(handles.flframe).data,[handles.flmin,handles.flmax]);
set(handles.flim, 'HitTest', 'off');
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in areaval future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have areaval white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit3_Callback(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in areaval future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit3 as text
%        str2double(get(hObject,'String')) returns contents of edit3 as areaval double
user_num = str2num(get(hObject,'String'));
if isnan(user_num)
    errordlg('You must enter a numeric value','Bad Input','modal')
    return
end
if (user_num>=handles.phmax)
    errordlg('You must enter a value less than the min','Bad Input','modal')
    return
end
handles.phmin=user_num;
axes(handles.phaxes);
handles.phim=imshow(handles.ph(handles.phframe).data,[handles.phmin,handles.phmax]);
set(handles.phim, 'HitTest', 'off');
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function edit3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in areaval future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have areaval white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit4_Callback(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in areaval future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit4 as text
%        str2double(get(hObject,'String')) returns contents of edit4 as areaval double
user_num = str2num(get(hObject,'String'));
if isnan(user_num)
    errordlg('You must enter a numeric value','Bad Input','modal')
    return
end
if (user_num<=handles.phmin)
    errordlg('You must enter a value greater than the min','Bad Input','modal')
    return
end
handles.phmax=user_num;
axes(handles.phaxes);
handles.phim=imshow(handles.ph(handles.phframe).data,[handles.phmin,handles.phmax]);
set(handles.phim, 'HitTest', 'off');
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function edit4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in areaval future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have areaval white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




% --- Executes on mouse press over axes background.
function flaxes_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to flaxes (see GCBO)
% eventdata  reserved - to be defined in areaval future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 

% --- Executes on mouse press over axes background.
function phaxes_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to phaxes (see GCBO)
% eventdata  reserved - to be defined in areaval future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on mouse press over axes background. '514nm'
function axes5_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to axes5 (see GCBO)
% eventdata  reserved - to be defined in areaval future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
pt = get(gcf, 'CurrentPoint');
refcoords=get(handles.axes5,'Position');
csize=size(handles.fl(handles.flframe).data);
col=round(csize(2)*(double((pt(1)-refcoords(1)))/double(refcoords(3))))+1;
row=csize(1)-round(csize(1)*(double((pt(2)-refcoords(2)))/double(refcoords(4))))-1;
if(row>csize(1))
    row=csize(1)
elseif(row<1)
    row=1;
end
if(col>csize(2))
    col=csize(2)
elseif(col<1)
    col=1;
end
val=handles.fl(handles.flframe).data(row,col);


sumval=0;
for i=(row-handles.boxtype):(row+handles.boxtype),
    for j=(col-handles.boxtype):(col+handles.boxtype),
        if((1<=i)&(i<=csize(1)))
            if((1<=j)&(j<=csize(2)))
                sumval=sumval+double(handles.fl(handles.flframe).data(i,j)/(2*handles.boxtype+1)^2);
            end
        end
    end
end
set(handles.ptvalsum, 'String',num2str(sumval));%/((2*handles.boxtype+1)^2)));
set(handles.ptval, 'String',num2str(val));
set(handles.xyval,'String',[num2str(col) ', ' num2str(row)]);

handles.col=col;
handles.row=row;

row0=row;
col0=col;
maxsumval=0;

for row=(row0-3):(row0+3),
    for col=(col0-3):(col0+3),
        sumval=0;
        for i=(row-1):(row+1),
            for j=(col-1):(col+1),
                if((1<=i)&(i<=csize(1)))
                    if((1<=j)&(j<=csize(2)))
                        sumval=sumval+handles.fl(handles.flframe).data(i,j);
                    end
                end
            end
        end
        if(sumval>maxsumval)
            maxsumval=sumval;
        end
    end
end

set(handles.maxvalsum, 'String',num2str(maxsumval/9));


axes(handles.flaxes);
handles.flim=imshow(handles.fl(handles.flframe).data,[handles.flmin,handles.flmax]);
set(handles.flim, 'HitTest', 'off');
handles.flcursor=rectangle('Position',[col0 row0 1 1],'EdgeColor','g');
set(handles.flcursor,'HitTest', 'off');
handles.flcursor=rectangle('Position',[col0-3 row0-3 6 6],'EdgeColor','r');
set(handles.flcursor,'HitTest', 'off');

set(handles.xyval2,'String',[num2str(col0) ', ' num2str(row0)]);
axes(handles.phaxes);
handles.phim=imshow(handles.ph(handles.phframe).data,[handles.phmin,handles.phmax]);
set(handles.phim, 'HitTest', 'off');
handles.phcursor=rectangle('Position',[col0 row0 1 1],'EdgeColor','b');
set(handles.phcursor,'HitTest', 'off');
guidata(hObject,handles);


guidata(hObject,handles);



% --- Executes on mouse press over axes background. 'bf'
function axes6_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to axes6 (see GCBO)
% eventdata  reserved - to be defined in areaval future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
pt = get(gcf, 'CurrentPoint');
refcoords=get(handles.axes6,'Position');
csize=size(handles.ph(handles.phframe).data);
col=round(csize(2)*(double((pt(1)-refcoords(1)))/double(refcoords(3))))+1;
row=csize(1)-round(csize(1)*(double((pt(2)-refcoords(2)))/double(refcoords(4))))-1;
if(row>csize(1))
    row=csize(1)
elseif(row<1)
    row=1;
end
if(col>csize(2))
    col=csize(2)
elseif(col<1)
    col=1;
end

axes(handles.phaxes);

%rectangle('Position',[col row 10 10],'EdgeColor','g');


%{
mcdots=handles.mcdots{handles.phframe};
vendots=handles.mcdots{handles.phframe};

axes(handles.flaxes);
handles.flim=imshow(handles.fl(handles.flframe).data,[handles.flmin,handles.flmax]);
set(handles.flim, 'HitTest', 'off');

for i=1:size(mcdots,1),
    if(bw(mcdots(i,1),mcdots(i,2))==1)
        rectangle('Position',[mcdots(i,2) mcdots(i,1) 5 5],'EdgeColor','r');
    end
end

axes(handles.flaxes2);
handles.flim2=imshow(handles.fl2(handles.flframe2).data,[handles.flmin2,handles.flmax2]);
set(handles.flim2, 'HitTest', 'off');

for i=1:size(vendots,1),
    if(bw(vendots(i,1),vendots(i,2))==1)
        rectangle('Position',[vendots(i,2) vendots(i,1) 3 3],'EdgeColor','g');
    end
end
%}


guidata(hObject,handles);



% --- Executes on button press in crop.
function crop_Callback(hObject, eventdata, handles)
% hObject    handle to crop (see GCBO)
% eventdata  reserved - to be defined in areaval future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
axes(handles.phaxes);
handles.phim=imshow(handles.ph(handles.phframe).data,[handles.phmin,handles.phmax]);
set(handles.phim, 'HitTest', 'off');
rect=getrect;
handles.myrect=rect;
rect=handles.myrect;
axes(handles.phaxes);
handles.phrect=rectangle('Position',rect,'EdgeColor','r');
set(handles.phrect,'HitTest','off');
I=imcrop(handles.ph(handles.phframe).data,rect);
%axes(handles.cropaxes2);
%imshow(I,[handles.phmin,handles.phmax]);

axes(handles.flaxes);
handles.flrect=rectangle('Position',rect,'EdgeColor','r');
set(handles.flrect,'HitTest','off');

% 2013-9-22 SR
axes(handles.axes12);
IF=imcrop(handles.fl(handles.flframe).data,rect);
IFim=imshow(IF,[handles.flmin,handles.flmax]);
set(IFim, 'HitTest', 'off'); 

axes(handles.cropaxes);
I=max(max(I))-I;

%original %%%%%%%%%%%%%%
%level = graythresh(I);
%BW = im2bw(I,level);
%%%%%%%%%%%%%%%%%%%%%%%%%%
% k-means version %%%%%%%%%%%%
%IDX = kmeans(I(:),2,'Distance','cityblock','emptyaction', 'drop','onlinephase', 'off', 'start', 'cluster','replicates',20);
%bw = reshape(IDX,size(I));
%if mean(I(bw==1)) > mean(I(bw==2))
%    bw = bw==1;
%else
%    bw = bw==2;
%end
% GMM version %%%%%%%%%%%%%%%%%%%%%%%%%%%%
obj = gmdistribution.fit(double(I(:)),2);
IDX = cluster(obj, double(I(:)));
bw = reshape(IDX,size(I));
if mean(I(bw==1)) > mean(I(bw==2))
    bw = bw==1;
else
    bw = bw==2;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for i=1:size(bw,1)
   bw(i,1)=0;
   bw(i,size(bw,2))=0;
end
for j=1:size(bw,2)
   bw(1,j)=0;
   bw(size(bw,1),j)=0;
end

imshow(bw);

[labeled,numObjects] = bwlabel(bw,8);
objs=zeros(1,numObjects);
for j = 1:numObjects,
    [r,c] = find(bwlabel(labeled,8)==j);
    objs(j)=length(r);
end
cellindex=find(objs==max(objs));
notcellindex=find(objs~=max(objs));
bw(notcellindex)=0;
[r,c] = find(bwlabel(labeled,8)==cellindex);
handles.r=r;
handles.c=c;
%background=imopen(IF2,strel('disk',15));
%IF2=imsubtract(IF2,background);

area=length(r);

I2=double(IF);
bg=mode(mode(I2)); % image background
handles.bg=bg;

fsum=0;

for j = 1:area
    fsum=double(IF(r(j),c(j)))+fsum;
end

fsum=fsum/area;
vensum=fsum-bg;

%% 2018-10-02 SR spot recognition
sdsum=0;
for j = 1:area
    sdsum=(double(IF(r(j),c(j)))-fsum)^2+sdsum;
end
sdsum=sqrt(sdsum/area);
IF2=IF-fsum-handles.sd*sdsum;
IF2=im2bw(IF2,.1/65536);
IF2=imopen(IF2,strel('disk',1));

% pixel size threshold = diffraction limited spot size (FWHM)  
[labeled,numObjects] = bwlabel(IF2,8);
objs=zeros(1,numObjects);
notspotindex=[];
for j = 1:numObjects,
    [r2,~] = find(bwlabel(labeled,8)==j);
    objs(j)=length(r2);
    if objs(j)<handles.thr_size %% deletion 
        notspotindex=find(bwlabel(labeled,8)==j);
    end    
end
IF2(notspotindex)=0;

%% SNR calculation
% signal
[labeled,numSignals] = bwlabel(IF2,8);
objs=zeros(1,numSignals);
signal=zeros(1,numSignals);
signalsqureSum=zeros(1,numSignals);
SIGNAL=zeros(1,numSignals);
for j = 1:numSignals,
    [r2,c2] = find(bwlabel(labeled,8)==j);
    objs(j)=length(r2);
    signalSum=0;
    signalsqSum=0;
    for k = 1:objs(j)
        signalSum=double(IF(r2(k),c2(k)))+signalSum;
        signalsqSum=double(IF(r2(k),c2(k)))^2+signalsqSum;
    end
    signal(j)=signalSum;
    signalsqureSum(j)=signalsqSum;
    SIGNAL(j)=signalSum/objs(j);
end
% noise

squresum=0;
totalSum=0;
for j = 1:area
    squresum=double(IF(r(j),c(j)))^2+squresum;
    totalSum=double(IF(r(j),c(j)))+totalSum;
end

bg_squresum=squresum-sum(signalsqureSum);
bg_squresum=bg_squresum/(area-sum(objs));
bgSum=totalSum-sum(signal);
bgSum=bgSum/(area-sum(objs));

noise=sqrt(bg_squresum-bgSum^2);

SNR=zeros(numSignals);
for j=1:numSignals;
    SNR(j)=(SIGNAL(j)-bgSum)/noise;
    if SNR(j)<handles.thr_SNR %% deletion
        notspotindex=find(bwlabel(labeled,8)==j);
    end
end
IF2(notspotindex)=0;

axes(handles.axes14);
imshow(IF2,[0,1]);

%% 2D gaussian fitting
% 2015-02-17, 2D gaussian fitting to determine spot position
axes(handles.cropaxes2);
imshow(IF,[handles.flmin,handles.flmax]);

[labeled,numSpots] = bwlabel(IF2,8);

if numSpots~=0
    
    % signal
    objs=zeros(1,numSpots);
    signal=zeros(1,numSpots);
    signalsqureSum=zeros(1,numSpots);
    SIGNAL=zeros(1,numSpots);
    
    MaxInt=zeros(1,numSpots);
    maxrow=zeros(1,numSpots);
    maxcol=zeros(1,numSpots);
    
    for j = 1:numSpots,
        [r2,c2] = find(bwlabel(labeled,8)==j);
        objs(j)=length(r2);
        spot_area=objs(j);
        
        signalSum=0;
        signalsqSum=0;
        for k = 1:spot_area
            signalSum=double(IF(r2(k),c2(k)))+signalSum;
            signalsqSum=double(IF(r2(k),c2(k)))^2+signalsqSum;
        end
        signal(j)=signalSum;
        signalsqureSum(j)=signalsqSum;
        SIGNAL(j)=signalSum/objs(j);
        
        ptmax=0;
        
        for k = 1:spot_area
            pt25=sum(sum(double(IF((r2(k)-2):(r2(k)+2),(c2(k)-2):(c2(k)+2)))));
            pt25=pt25/25;
            if (pt25>ptmax)
                ptmax=pt25;
                maxk=k;
                maxpt=ptmax-bgSum;
            end
        end
        MaxInt(j)=maxpt;
        maxrow(j)=r2(maxk); % 3 by 3 center row (dot y)
        maxcol(j)=c2(maxk); % 3 by 3 center col (dot x)
    end
    
    % noise
    bg_squresum=squresum-sum(signalsqureSum);
    bg_squresum=bg_squresum/(area-sum(objs));
    bgSum=totalSum-sum(signal);
    bgSum=bgSum/(area-sum(objs));
    
    noise=sqrt(bg_squresum-bgSum^2);
    
    SNR=zeros(numSpots);
    for j=1:numSpots;
        SNR(j)=(SIGNAL(j)-bgSum)/noise;
    end
    
    gaucentx=[];
    gaucenty=[];
    sx=[];
    sy=[];
    peakOD=[];
    maxptgau=[];
    
    for i=1:numSpots
        
        %text(maxcol(i),maxrow(i),['    ' num2str(MaxInt(i))],'color','g');
        text(maxcol(i),maxrow(i),'x','color','g');
        
        maxcent_r=maxrow(i);
        maxcent_c=maxcol(i);
        image25=double(IF(maxcent_r-3:maxcent_r+3,maxcent_c-3:maxcent_c+3));
        image25=image25-bgSum;
        [gaucentx(i),gaucenty(i),sx(i),sy(i),peakOD(i)]=Gaussian2D(image25,10^-6,0);
        gaucentx(i)=maxcent_c-(4-gaucentx(i));
        gaucenty(i)=maxcent_r-(4-gaucenty(i));
        
        % 5by5 region around gaussian center
        gx=round(gaucentx(i));
        gy=round(gaucenty(i));
        
        ptgau=sum(sum(double(IF(gy-2:gy+2,gx-2:gx+2))));
        ptmaxgau(i)=ptgau/25;
        maxptgau(i) = ptmaxgau(i)-bgSum;
        
        text(gaucentx(i),gaucenty(i),['    ' num2str(maxptgau(i))],'color','r');
        text(gaucentx(i),gaucenty(i),'X','color','r');
    end
else
end


%% 2015-02-16 SR, Fitting 2D elliptical function to determin the short and
%% long axis
bb=bwboundaries(bw,8,'noholes');
b=bb{1};
params=fitellipse(b(:,2),b(:,1));

xcenter=params(1);
ycenter=params(2);

rx=params(3);
ry=params(4);
thetarad=params(5);

% find pol position (0,longaxis)
if rx > ry %rx=longaxis
    pol=[rx,0];
    pol=[pol(1)*cos(thetarad)-pol(2)*sin(thetarad) + xcenter, pol(1)*sin(thetarad)+pol(2)*cos(thetarad) + ycenter];
    pol2=[-rx,0];
    pol2=[pol2(1)*cos(thetarad)-pol2(2)*sin(thetarad) + xcenter, pol2(1)*sin(thetarad)+pol2(2)*cos(thetarad) + ycenter];
else %ry=longaxis
    pol=[0,ry];
    pol=[pol(1)*cos(thetarad)-pol(2)*sin(thetarad) + xcenter, pol(1)*sin(thetarad)+pol(2)*cos(thetarad) + ycenter];
    pol2=[0,-ry];
    pol2=[pol2(1)*cos(thetarad)-pol2(2)*sin(thetarad) + xcenter, pol2(1)*sin(thetarad)+pol2(2)*cos(thetarad) + ycenter];
end

pol=[pol; pol2];
%a=randi(2);
far=pol(1,:);%far=pol(a,:);

% plot ellipse fitting results
axes(handles.cropaxes);
IF=imcrop(handles.fl(handles.flframe).data,rect);
I=max(max(I))-I;

t = linspace(0,pi*2);
x = rx * cos(t);
y = ry * sin(t);
nx = x*cos(thetarad)-y*sin(thetarad) + xcenter; 
ny = x*sin(thetarad)+y*cos(thetarad) + ycenter;
hold on
plot(nx,ny,'r');
text(pol(1,1),pol(1,2),'X','color','r');
text(pol(2,1),pol(2,2),'X','color','r');
text(xcenter,ycenter,'X','color','r');
hold off
%% end, 2015-02-16 SR

%% save
% cell 
celldata=zeros(1,17);

celldata(1,1)=r(1);
celldata(1,2)=c(1);
celldata(1,3)=vensum;
celldata(1,4)=area;
celldata(1,5)=handles.phframe;
celldata(1,6)=numSpots;
celldata(1,7)=xcenter;
celldata(1,8)=ycenter;
celldata(1,9)=far(1);
celldata(1,10)=far(2);
celldata(1,11)=rx;
celldata(1,12)=ry;
celldata(1,13)=thetarad;

if numSpots==0
    celldata(1,14)=0;
    celldata(1,15)=0;
    celldata(1,16)=0;
    celldata(1,17)=0;
else
    if numSpots==1 && sx(1) < 3 && sy(1) < 3
        celldata(1,14)=maxptgau(1);
        celldata(1,15)=SNR(1);        
    else if numSpots>=2 
            if sx(1) < 3 && sy(1) < 3
            celldata(1,14)=maxptgau(1);
            celldata(1,15)=SNR(1);
            end
            if sx(2) < 3 && sy(2) < 3
            celldata(1,16)=maxptgau(2);
            celldata(1,17)=SNR(2);
            end
        end
    end
end

handles.celldata=celldata;

% spot
if numSpots~=0;
    spotdata=zeros(numSpots,18);
    for i=1:numSpots
        spotdata(i,1)=xcenter;
        spotdata(i,2)=ycenter;
        spotdata(i,3)=far(1);
        spotdata(i,4)=far(2);
        spotdata(i,5)=gaucentx(i);
        spotdata(i,6)=gaucenty(i);
        spotdata(i,7)=peakOD(i);
        spotdata(i,8)=sx(i);
        spotdata(i,9)=sy(i);
        spotdata(i,10)=rx;
        spotdata(i,11)=ry;
        spotdata(i,12)=thetarad;
        spotdata(i,13)=SNR(i);
        spotdata(i,14)=maxptgau(i);
        spotdata(i,15)=MaxInt(i);
        spotdata(i,16)=handles.phframe;
        spotdata(i,17)=vensum;
        spotdata(i,18)=area;
    end
    handles.spotdata=spotdata;
    
    set(handles.gaustdx,'String',num2str(sx));
    set(handles.gaustdy,'String',num2str(sy));

else
    handles.spotdata=[];
end

handles.bw=bw;

set(handles.vensumval,'String',num2str(vensum));
set(handles.areaval,'String',num2str(area));
set(handles.snr,'String',num2str(SNR));


guidata(hObject,handles);


function ss=calcpatch(bw,FL,shiftr,shiftc,r,c,j,fsum)
sum=0;
count=0;
if(FL(r(j),c(j))>(fsum+sqrt(fsum)))
    if(((1<=(j+shiftr))&((j+shiftr)<=size(bw,1)))&((1<=(j+shiftc))&((j+shiftc)<=size(bw,2))))
        sum=sum+(FL(r(j),c(j))-FL(r(j+shiftr),c(j+shiftc)))^2;
        count=count+1;
    end
    if(((1<=(j-1+shiftr))&((j-1+shiftr)<=size(bw,1)))&((1<=(j+shiftc))&((j+shiftc)<=size(bw,2))))
        if(1<=(j-1))
            sum=sum+(FL(r(j-1),c(j))-FL(r(j-1+shiftr),c(j+shiftc)))^2;
            count=count+1;
        end
    end
    if(((1<=(j+1+shiftr))&((j+1+shiftr)<=size(bw,1)))&((1<=(j+shiftc))&((j+shiftc)<=size(bw,2))))
        if((j+1)<=size(bw,1))
            sum=sum+(FL(r(j+1),c(j))-FL(r(j+1+shiftr),c(j+shiftc)))^2;
            count=count+1;
        end
    end
    if(((1<=(j+shiftr))&((j+shiftr)<=size(bw,1)))&((1<=(j-1+shiftc))&((j-1+shiftc)<=size(bw,2))))
        if(1<=(j-1))
            sum=sum+(FL(r(j),c(j-1))-FL(r(j+shiftr),c(j-1+shiftc)))^2;
            count=count+1;
        end
    end
    if(((1<=(j+shiftr))&((j+shiftr)<=size(bw,1)))&((1<=(j+1+shiftc))&((j+1+shiftc)<=size(bw,2))))
        if((j+1)<=size(bw,2))
            sum=sum+(FL(r(j),c(j+1))-FL(r(j+shiftr),c(j+1+shiftc)))^2;
            count=count+1;
        end
    end
end
if(count>0)
    sum=sum/count;
else
    sum=0;
end
ss=sqrt(double(sum));

function neighbors=getneighbors(cellr,cellc,labeled)
    neighbors=zeros(8,1);
    neighbor(1)=inbound(cellr-1,cellc-1,labeled);
    neighbor(2)=inbound(cellr-1,cellc,labeled);
    neighbor(3)=inbound(cellr-1,cellc+1,labeled);
    neighbor(4)=inbound(cellr,cellc-1,labeled);
    neighbor(5)=inbound(cellr,cellc+1,labeled);
    neighbor(6)=inbound(cellr+1,cellc-1,labeled);
    neighbor(7)=inbound(cellr+1,cellc,labeled);
    neighbor(8)=inbound(cellr+1,cellc+1,labeled);



function val=inbound(cellr,cellc,labeled)
    if((1<cellr)&(cellr<size(labeled,1))&(1<cellc)&(cellc<size(labeled,2)))
        val=labeled(cellr,cellc)
    else
        val=0;
    end


% --- Executes on button press in calcint. 'update'
function calcint_Callback(hObject, eventdata, handles)
% hObject    handle to calcint (see GCBO)
% eventdata  reserved - to be defined in areaval future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

icframe=handles.flframe;
cframe=handles.flframe;
if(cframe~=size(handles.fl,2))
    handles.flframe=cframe+1;
end



rect=handles.myrect;
axes(handles.phaxes);
handles.phrect=rectangle('Position',rect,'EdgeColor','r');
set(handles.phrect,'HitTest','off');
I=imcrop(handles.ph(handles.phframe).data,rect);
%axes(handles.cropaxes2);
%imshow(I,[handles.phmin,handles.phmax]);
axes(handles.cropaxes);
IF=imcrop(handles.fl(handles.flframe).data,rect);
I=max(max(I))-I;
level=graythresh(I);
bw=im2bw(I,level);
for i=1:size(bw,1)
   bw(i,1)=0;
   bw(i,size(bw,2))=0;
end
for j=1:size(bw,2)
   bw(1,j)=0;
   bw(size(bw,1),j)=0;
end
imshow(bw);
[labeled,numObjects] = bwlabel(bw,8);
objs=zeros(1,numObjects);
for j = 1:numObjects,
    [r,c] = find(bwlabel(labeled,8)==j);
    objs(j)=length(r);
end
cellindex=find(objs==max(objs));
notcellindex=find(objs~=max(objs));
bw(notcellindex)=0;
[r,c] = find(bwlabel(labeled,8)==cellindex);
handles.r=r;
handles.c=c;
%background=imopen(IF2,strel('disk',15));
%IF2=imsubtract(IF2,background);
area=length(r);
fsum=0;
FL=IF;
ptmax=0;
for j = 1:area
    fsum=double(IF(r(j),c(j)))+fsum;
end
fsum=fsum/area;
maxj=1;
maxpt=0;
pt25=0;
area
for j = 1:area
    if r(j)>1 && c(j)>1
        for k = r(j)-2:r(j)+2
            for l = c(j)-2:c(j)+2
                pt25=pt25+double(IF(k,l));
            end
        end          
    end
    pt25=pt25/25;
    if(pt25>ptmax)
        ptmax=pt25;
        maxj=j;
        maxpt=pt25-(fsum*area-pt25*25)/(area-25);
    end
    %dot decide
    maxcol=c(maxj);
    maxrow=r(maxj);
    
    if double(FL(maxrow,maxcol))-double(FL(maxrow-1,maxcol))>0&&double(FL(maxrow,maxcol))-double(FL(maxrow+1,maxcol))>0&&double(FL(maxrow,maxcol))-double(FL(maxrow,maxcol-1))>0&&double(FL(maxrow,maxcol))-double(FL(maxrow,maxcol+1))>0
        dotdecide=1;
    else
        dotdecide=0;
    end    
end
set(handles.maxptval,'String',num2str(fsum));
handles.bw=bw;
axes(handles.cropaxes2);
imshow(IF,[handles.flmin,handles.flmax]);
text(c(maxj),r(maxj),['    ' num2str(maxpt)],'color','r');
set(handles.maxptval,'String',num2str(maxpt));
text(c(maxj),r(maxj),'X','color','r');
text(c(maxj),r(maxj),num2str(dotdecide),'color','r');


handles.flframe=icframe;

guidata(hObject,handles);

%{
IF=imcrop(handles.fl(handles.flframe).data,handles.myrect);
r=handles.r;
c=handles.c;
%background=imopen(IF2,strel('disk',15));
%IF2=imsubtract(IF2,background);
area=length(r);
fsum=0;
for j = 1:area
    fsum=double(IF(r(j),c(j)))+fsum;
end
fsum=fsum/area;
set(handles.maxptval,'String',num2str(fsum));
guidata(hObject,handles);
%}



% --- Executes on button press in mancut.
function mancut_Callback(hObject, eventdata, handles)
% hObject    handle to mancut (see GCBO)
% eventdata  reserved - to be defined in areaval future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
axes(handles.cropaxes);
[x,y] = getline;
bw=handles.bw;
m=(y(2)-y(1))/(x(2)-x(1));
b=y(1)-m*x(1);
for i=1:100,
    xs=x(1)+i*(x(2)-x(1))/100;
    ys=m*xs+b;
    xs=round(xs);
    ys=round(ys);
    bw(ys,xs)=0;
end

IF=imcrop(handles.fl(handles.flframe).data,handles.myrect);
[labeled,numObjects] = bwlabel(bw,8);
objs=zeros(1,numObjects);
for j = 1:numObjects,
    [r,c] = find(bwlabel(labeled,8)==j);
    objs(j)=length(r);
end
cellindex=find(objs==max(objs));
[r,c] = find(bwlabel(labeled,8)==cellindex);

bw2=logical(zeros(size(bw)));
for i=1:length(r),
    bw2(r(i),c(i))=1;
end
bw=bw2;

[labeled,numObjects] = bwlabel(bw,8);
objs=zeros(1,numObjects);
for j = 1:numObjects,
    [r,c] = find(bwlabel(labeled,8)==j);
    objs(j)=length(r);
end
cellindex=find(objs==max(objs));
[r,c] = find(bwlabel(labeled,8)==cellindex);
handles.r=r;
handles.c=c;

area=length(r);
fsum=0;
for j = 1:area
    fsum=double(IF(r(j),c(j)))+fsum;
end
fsum=fsum/area;
vensum=fsum-handles.bg;

handles.bw=bw;
imshow(bw);

%% 2018-10-02 SR spot recognition
sdsum=0;
for j = 1:area
    sdsum=(double(IF(r(j),c(j)))-fsum)^2+sdsum;
end
sdsum=sqrt(sdsum/area);
IF2=IF-fsum-handles.sd*sdsum;
IF2=im2bw(IF2,.1/65536);
IF2=imopen(IF2,strel('disk',1));

% pixel size threshold = diffraction limited spot size (FWHM)  
[labeled,numObjects] = bwlabel(IF2,8);
objs=zeros(1,numObjects);
notspotindex=[];
for j = 1:numObjects,
    [r2,~] = find(bwlabel(labeled,8)==j);
    objs(j)=length(r2);
    if objs(j)<handles.thr_size %% deletion 
        notspotindex=find(bwlabel(labeled,8)==j);
    end    
end
IF2(notspotindex)=0;

%% SNR calculation
% signal
[labeled,numSignals] = bwlabel(IF2,8);
objs=zeros(1,numSignals);
signal=zeros(1,numSignals);
signalsqureSum=zeros(1,numSignals);
SIGNAL=zeros(1,numSignals);
for j = 1:numSignals,
    [r2,c2] = find(bwlabel(labeled,8)==j);
    objs(j)=length(r2);
    signalSum=0;
    signalsqSum=0;
    for k = 1:objs(j)
        signalSum=double(IF(r2(k),c2(k)))+signalSum;
        signalsqSum=double(IF(r2(k),c2(k)))^2+signalsqSum;
    end
    signal(j)=signalSum;
    signalsqureSum(j)=signalsqSum;
    SIGNAL(j)=signalSum/objs(j);
end
% noise

squresum=0;
totalSum=0;
for j = 1:area
    squresum=double(IF(r(j),c(j)))^2+squresum;
    totalSum=double(IF(r(j),c(j)))+totalSum;
end

bg_squresum=squresum-sum(signalsqureSum);
bg_squresum=bg_squresum/(area-sum(objs));
bgSum=totalSum-sum(signal);
bgSum=bgSum/(area-sum(objs));

noise=sqrt(bg_squresum-bgSum^2);

SNR=zeros(numSignals);
for j=1:numSignals;
    SNR(j)=(SIGNAL(j)-bgSum)/noise;
    if SNR(j)<handles.thr_SNR %% deletion
        notspotindex=find(bwlabel(labeled,8)==j);
    end
end
IF2(notspotindex)=0;

axes(handles.axes14);
imshow(IF2,[0,1]);

%% 2D gaussian fitting
% 2015-02-17, 2D gaussian fitting to determine spot position
axes(handles.cropaxes2);
imshow(IF,[handles.flmin,handles.flmax]);

[labeled,numSpots] = bwlabel(IF2,8);

if numSpots~=0
    
    % signal
    objs=zeros(1,numSpots);
    signal=zeros(1,numSpots);
    signalsqureSum=zeros(1,numSpots);
    SIGNAL=zeros(1,numSpots);
    
    MaxInt=zeros(1,numSpots);
    maxrow=zeros(1,numSpots);
    maxcol=zeros(1,numSpots);
    
    for j = 1:numSpots,
        [r2,c2] = find(bwlabel(labeled,8)==j);
        objs(j)=length(r2);
        spot_area=objs(j);
        
        signalSum=0;
        signalsqSum=0;
        for k = 1:spot_area
            signalSum=double(IF(r2(k),c2(k)))+signalSum;
            signalsqSum=double(IF(r2(k),c2(k)))^2+signalsqSum;
        end
        signal(j)=signalSum;
        signalsqureSum(j)=signalsqSum;
        SIGNAL(j)=signalSum/objs(j);
        
        ptmax=0;
        
        for k = 1:spot_area
            pt25=sum(sum(double(IF((r2(k)-2):(r2(k)+2),(c2(k)-2):(c2(k)+2)))));
            pt25=pt25/25;
            if (pt25>ptmax)
                ptmax=pt25;
                maxk=k;
                maxpt=ptmax-bgSum;
            end
        end
        MaxInt(j)=maxpt;
        maxrow(j)=r2(maxk); % 3 by 3 center row (dot y)
        maxcol(j)=c2(maxk); % 3 by 3 center col (dot x)
    end
    
    % noise
    bg_squresum=squresum-sum(signalsqureSum);
    bg_squresum=bg_squresum/(area-sum(objs));
    bgSum=totalSum-sum(signal);
    bgSum=bgSum/(area-sum(objs));
    
    noise=sqrt(bg_squresum-bgSum^2);
    
    SNR=zeros(numSpots);
    for j=1:numSpots;
        SNR(j)=(SIGNAL(j)-bgSum)/noise;
    end
    
    gaucentx=[];
    gaucenty=[];
    sx=[];
    sy=[];
    peakOD=[];
    maxptgau=[];
    
    for i=1:numSpots
        
        %text(maxcol(i),maxrow(i),['    ' num2str(MaxInt(i))],'color','g');
        text(maxcol(i),maxrow(i),'x','color','g');
        
        maxcent_r=maxrow(i);
        maxcent_c=maxcol(i);
        image25=double(IF(maxcent_r-3:maxcent_r+3,maxcent_c-3:maxcent_c+3));
        image25=image25-bgSum;
        [gaucentx(i),gaucenty(i),sx(i),sy(i),peakOD(i)]=Gaussian2D(image25,10^-6,0);
        gaucentx(i)=maxcent_c-(4-gaucentx(i));
        gaucenty(i)=maxcent_r-(4-gaucenty(i));
        
        % 5by5 region around gaussian center
        gx=round(gaucentx(i));
        gy=round(gaucenty(i));
        
        ptgau=sum(sum(double(IF(gy-2:gy+2,gx-2:gx+2))));
        ptmaxgau(i)=ptgau/25;
        maxptgau(i) = ptmaxgau(i)-bgSum;
        
        text(gaucentx(i),gaucenty(i),['    ' num2str(maxptgau(i))],'color','r');
        text(gaucentx(i),gaucenty(i),'X','color','r');
    end
else
end


%% 2015-02-16 SR, Fitting 2D elliptical function to determin the short and
%% long axis
bb=bwboundaries(bw,8,'noholes');
b=bb{1};
params=fitellipse(b(:,2),b(:,1));

xcenter=params(1);
ycenter=params(2);

rx=params(3);
ry=params(4);
thetarad=params(5);

% find pol position (0,longaxis)
if rx > ry %rx=longaxis
    pol=[rx,0];
    pol=[pol(1)*cos(thetarad)-pol(2)*sin(thetarad) + xcenter, pol(1)*sin(thetarad)+pol(2)*cos(thetarad) + ycenter];
    pol2=[-rx,0];
    pol2=[pol2(1)*cos(thetarad)-pol2(2)*sin(thetarad) + xcenter, pol2(1)*sin(thetarad)+pol2(2)*cos(thetarad) + ycenter];
else %ry=longaxis
    pol=[0,ry];
    pol=[pol(1)*cos(thetarad)-pol(2)*sin(thetarad) + xcenter, pol(1)*sin(thetarad)+pol(2)*cos(thetarad) + ycenter];
    pol2=[0,-ry];
    pol2=[pol2(1)*cos(thetarad)-pol2(2)*sin(thetarad) + xcenter, pol2(1)*sin(thetarad)+pol2(2)*cos(thetarad) + ycenter];
end

pol=[pol; pol2];
%a=randi(2);
far=pol(1,:);%far=pol(a,:);

% plot ellipse fitting results
axes(handles.cropaxes);
t = linspace(0,pi*2);
x = rx * cos(t);
y = ry * sin(t);
nx = x*cos(thetarad)-y*sin(thetarad) + xcenter; 
ny = x*sin(thetarad)+y*cos(thetarad) + ycenter;
hold on
plot(nx,ny,'r');
text(pol(1,1),pol(1,2),'X','color','r');
text(pol(2,1),pol(2,2),'X','color','r');
text(xcenter,ycenter,'X','color','r');
hold off
%% end, 2015-02-16 SR

%% save
% cell 
celldata=zeros(1,17);

celldata(1,1)=r(1);
celldata(1,2)=c(1);
celldata(1,3)=vensum;
celldata(1,4)=area;
celldata(1,5)=handles.phframe;
celldata(1,6)=numSpots;
celldata(1,7)=xcenter;
celldata(1,8)=ycenter;
celldata(1,9)=far(1);
celldata(1,10)=far(2);
celldata(1,11)=rx;
celldata(1,12)=ry;
celldata(1,13)=thetarad;

if numSpots==0
    celldata(1,14)=0;
    celldata(1,15)=0;
    celldata(1,16)=0;
    celldata(1,17)=0;
else
    if numSpots==1 && sx(1) < 3 && sy(1) < 3
        celldata(1,14)=maxptgau(1);
        celldata(1,15)=SNR(1);        
    else if numSpots>=2 
            if sx(1) < 3 && sy(1) < 3
            celldata(1,14)=maxptgau(1);
            celldata(1,15)=SNR(1);
            end
            if sx(2) < 3 && sy(2) < 3
            celldata(1,16)=maxptgau(2);
            celldata(1,17)=SNR(2);
            end
        end
    end
end

        
handles.celldata=celldata;

% spot
if numSpots~=0;
    spotdata=zeros(numSpots,18);
    for i=1:numSpots
        spotdata(i,1)=xcenter;
        spotdata(i,2)=ycenter;
        spotdata(i,3)=far(1);
        spotdata(i,4)=far(2);
        spotdata(i,5)=gaucentx(i);
        spotdata(i,6)=gaucenty(i);
        spotdata(i,7)=peakOD(i);
        spotdata(i,8)=sx(i);
        spotdata(i,9)=sy(i);
        spotdata(i,10)=rx;
        spotdata(i,11)=ry;
        spotdata(i,12)=thetarad;
        spotdata(i,13)=SNR(i);
        spotdata(i,14)=maxptgau(i);
        spotdata(i,15)=MaxInt(i);
        spotdata(i,16)=handles.phframe;
        spotdata(i,17)=vensum;
        spotdata(i,18)=area;
    end
    handles.spotdata=spotdata;
    
    set(handles.gaustdx,'String',num2str(sx));
    set(handles.gaustdy,'String',num2str(sy));

else
    handles.spotdata=[];
end

set(handles.vensumval,'String',num2str(vensum));
set(handles.areaval,'String',num2str(area));
set(handles.snr,'String',num2str(SNR));

handles.bw=bw;

guidata(hObject,handles);

function [ptout]=convertpt(refcoords,csize,pt)
col=round(csize(2)*(double((pt(1)-refcoords(1)))/double(refcoords(3))))+1;
row=csize(1)-round(csize(1)*(double((pt(2)-refcoords(2)))/double(refcoords(4))))-1;
if(row>csize(1))
    row=csize(1)
elseif(row<1)
    row=1;
end
if(col>csize(2))
    col=csize(2)
elseif(col<1)
    col=1;
end
ptout(1)=col;
ptout(2)=row;


% --- Executes on button press in pushbutton10.
function pushbutton10_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton10 (see GCBO)
% eventdata  reserved - to be defined in areaval future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
cframe=handles.phframe+10;
if(cframe<=size(handles.ph,2))
    handles.phframe=cframe;
else
    handles.phframe=size(handles.ph,2);
end
axes(handles.phaxes);
handles.phim=imshow(handles.ph(handles.phframe).data,[handles.phmin,handles.phmax]);
set(handles.phim, 'HitTest', 'off');
set(handles.frval2,'String',num2str(handles.phframe));

handles.flframe=handles.phframe;
handles.flframe2=handles.phframe;
axes(handles.flaxes);
handles.flim=imshow(handles.fl(handles.flframe).data,[handles.flmin,handles.flmax]);
set(handles.flim, 'HitTest', 'off');
set(handles.frval1,'String',num2str(handles.flframe));



guidata(hObject,handles);

% --- Executes on button press in pushbutton11.
function pushbutton11_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton11 (see GCBO)
% eventdata  reserved - to be defined in areaval future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
cframe=handles.phframe-10;
if(cframe>=1)
    handles.phframe=cframe;
else
    handles.phframe=1;
end
axes(handles.phaxes);
handles.phim=imshow(handles.ph(handles.phframe).data,[handles.phmin,handles.phmax]);
set(handles.phim, 'HitTest', 'off');
set(handles.frval2,'String',num2str(handles.phframe));

handles.flframe=handles.phframe;
handles.flframe2=handles.phframe;
axes(handles.flaxes);
handles.flim=imshow(handles.fl(handles.flframe).data,[handles.flmin,handles.flmax]);
set(handles.flim, 'HitTest', 'off');
set(handles.frval1,'String',num2str(handles.flframe));


guidata(hObject,handles);



% --- Executes on button press in pushbutton18. 'find cells'
function pushbutton18_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton18 (see GCBO)
% eventdata  reserved - to be defined in areaval future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

axes(handles.phaxes);
handles.phim=imshow(handles.ph(handles.phframe).data,[handles.phmin,handles.phmax]);
set(handles.phim, 'HitTest', 'off');
bw=handles.bws(:,:,handles.phframe);

[labeled,numObjects] = bwlabel(bw,4);

if(handles.showcell==0),
    I=handles.ph(handles.phframe).data;
    axes(handles.phaxes);
    boundaries=bwboundaries(bw,4,'noholes');
    hold on;
    for ii=1:numObjects,
        b=boundaries{ii};
        %for jj=1:size(b,1),
        %    I(b(jj,1),b(jj,2))=65000;
        %end
        h=plot(b(:,2),b(:,1),'y','LineWidth',1);
        set(h, 'HitTest', 'off');
    end
    hold off;
end
handles.showcell=mod(handles.showcell+1,2);

guidata(hObject,handles);



% --- Executes on button press in pushbutton19. 'find dots'
function pushbutton19_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton19 (see GCBO)
% eventdata  reserved - to be defined in areaval future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

bw=handles.bws(:,:,handles.phframe);
mcdots=handles.mcdots{handles.phframe};
vendots=handles.vendots{handles.phframe};

axes(handles.flaxes);
handles.flim=imshow(handles.fl(handles.flframe).data,[handles.flmin,handles.flmax]);
set(handles.flim, 'HitTest', 'off');

if(handles.showdot==0)
for i=1:size(mcdots,1),
    if(bw(mcdots(i,1),mcdots(i,2))==1)
        rectangle('Position',[mcdots(i,2) mcdots(i,1) 5 5],'EdgeColor','r');
    end
end
end

axes(handles.flaxes2);
handles.flim2=imshow(handles.fl2(handles.flframe2).data,[handles.flmin2,handles.flmax2]);
set(handles.flim2, 'HitTest', 'off');

if(handles.showdot==0)
for i=1:size(vendots,1),
    if(bw(mcdots(i,1),mcdots(i,2))==1)
        rectangle('Position',[vendots(i,2) vendots(i,1) 3 3],'EdgeColor','g');
    end
end
end

handles.showdot=mod(handles.showdot+1,2);



%{
I=handles.ph(handles.phframe).data;
level=graythresh(I);
bw=im2bw(I,level);
bw=1-bw;
axes(handles.cropaxes);
imshow(bw);
%}

%{
bw=handles.bws(:,:,handles.phframe);

I2=handles.fl(handles.flframe).data;
I3=handles.fl2(handles.flframe2).data;
se=strel('disk',40);
I3=imsubtract(I3,imopen(I3,se));
level=graythresh(I2);
bw2=im2bw(I2,level);
se=strel('disk',1);
bw2=imdilate(bw2,se);
axes(handles.cropaxes2);
imshow(bw2);

for i=1:size(bw,1),
    bw(i,size(bw,2))=1;
    bw(i,1)=1;
end
for i=1:size(bw,2),
    bw(size(bw,1),i)=1;
    bw(1,i)=1;
end

[labeled,numObjects] = bwlabel(bw,4);
for i = 1:numObjects,
    rc = find(bwlabel(labeled)==i);
    if ((length(rc)<120) | (length(rc)>400))
        bw(rc)=0;
    end
end
imshow(bw);

[labeled,numObjects] = bwlabel(bw,4);

axes(handles.phaxes);
boundaries=bwboundaries(bw,4,'noholes');
hold on;
for ii=1:numObjects,
    b=boundaries{ii};
    h=plot(b(:,2),b(:,1),'y','LineWidth',1);
    set(h, 'HitTest', 'off');
end
hold off;

I2=double(I2);
I3=double(I3);

for i=1:numObjects,
[r,c]=find(bwlabel(labeled)==i);

axes(handles.cropaxes2);
bwcrop=imcrop(bw,[min(c)-2 min(r)-2 max(c)-min(c)+4 max(r)-min(r)+4]);
bw2crop=imcrop(bw2,[min(c)-2 min(r)-2 max(c)-min(c)+4 max(r)-min(r)+4]);
I2crop=imcrop(I2,[min(c)-2 min(r)-2 max(c)-min(c)+4 max(r)-min(r)+4]);
I3crop=imcrop(I3,[min(c)-2 min(r)-2 max(c)-min(c)+4 max(r)-min(r)+4]);

bw2crop=bwcrop.*bw2crop;
imshow(bw2crop);
[labeled2,numObjects2] = bwlabel(bw2crop,4);
for j=1:numObjects2,
    [r2,c2]=find(bwlabel(labeled2)==j);
    sum=double(0);
    maxsum=double(0);
    maxi=0;
    I2crop=double(I2crop);
    for i=1:length(r2),
        x1=r2(i);
        y1=c2(i);
        if ((x1>1)&(y1>1)&(x1<size(I2,1))&(y1<size(I2,2))),
            sum=double((I2(x1,y1)+I2(x1-1,y1)+I2(x1+1,y1)+I2(x1,y1-1)+I2(x1,y1+1)+I2(x1-1,y1-1)+I2(x1-1,y1+1)+I2(x1+1,y1-1)+I2(x1+1,y1+1))/9);
        %sum=double((I2crop(r2(i),c2(i))+I2crop(r2(i)-1,c2(i))+I2crop(r2(i)+1,c2(i))+I2crop(r2(i),c2(i)-1)+I2crop(r2(i),c2(i)+1)+I2crop(r2(i)-1,c2(i)-1)+I2crop(r2(i)-1,c2(i)+1)+I2crop(r2(i)+1,c2(i)-1)+I2crop(r2(i)+1,c2(i)+1)))/9;
        end
        if(sum>maxsum)
            maxsum=sum;
            maxi=i;
        end
    end
    axes(handles.flaxes);
    if(maxi>0)
        handles.flcursor=rectangle('Position',[c2(maxi)+min(c)-2 r2(maxi)+min(r)-2 5 5],'EdgeColor','r');
    %handles.flcursor=rectangle('Position',[c2(maxi) r2(maxi) 2 2],'EdgeColor','r');
        maxsumven=0;
        sum=double(0);
        dotval=0;
        I3crop=double(I3crop);
        for venr=(r2(maxi)+min(r)-2-2):(r2(maxi)+min(r)-2+2),
            for venc=(c2(maxi)+min(c)-2-2):(c2(maxi)+min(c)-2+2),
                %sum=double(abs((-8)*I3crop(venr,venc)+I3crop(venr-1,venc)+I3crop(venr+1,venc)+I3crop(venr,venc-1)+I3crop(venr,venc+1)+I3crop(venr-1,venc-1)+I3crop(venr-1,venc+1)+I3crop(venr+1,venc+1)+I3crop(venr+1,venc-1)));
                sum=double(abs((-8)*I3(venr,venc)+I3(venr-1,venc)+I3(venr+1,venc)+I3(venr,venc-1)+I3(venr,venc+1)+I3(venr-1,venc-1)+I3(venr-1,venc+1)+I3(venr+1,venc+1)+I3(venr+1,venc-1)));
                if(sum>maxsumven)
                    maxsumven=sum;
                    maxvenr=venr;
                    maxvenc=venc;
                    dotval=double((I3(venr,venc)+I3(venr-1,venc)+I3(venr+1,venc)+I3(venr,venc-1)+I3(venr,venc+1)+I3(venr-1,venc-1)+I3(venr-1,venc+1)+I3(venr+1,venc+1)+I3(venr+1,venc-1))/9);
                end
            end
        end
        axes(handles.flaxes2);
        handles.flcursor=rectangle('Position',[maxvenc maxvenr 5 5],'EdgeColor','g');
        %handles.flcursor=rectangle('Position',[maxvenc+min(c)-2 maxvenr+min(r)-2 5 5],'EdgeColor','g');
    end
end
end
axes(handles.cropaxes);
imshow(I3crop,[handles.flmin2,handles.flmax2]);
handles.flcursor=rectangle('Position',[maxvenc maxvenr 2 2],'EdgeColor','g');
axes(handles.flaxes2);
se=strel('disk',40);
%imshow(I3,[handles.flmin2,handles.flmax2]);
%}


guidata(hObject,handles);



% --- Executes on mouse press over figure background, over areaval disabled or
% --- inactive control, or over an axes background.
function figure1_WindowButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in areaval future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



% --- Executes during object creation, after setting all properties.
function axes6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes6 (see GCBO)
% eventdata  reserved - to be defined in areaval future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axes6



function edit7_Callback(hObject, eventdata, handles)
% hObject    handle to edit7 (see GCBO)
% eventdata  reserved - to be defined in areaval future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit7 as text
%        str2double(get(hObject,'String')) returns contents of edit7 as areaval double
user_text = get(hObject,'String');
handles.savefile=user_text;
guidata(hObject,handles);


% --- Executes during object creation, after setting all properties.
function edit7_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit7 (see GCBO)
% eventdata  reserved - to be defined in areaval future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have areaval white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




% --- Executes on button press in pushbutton22. 'clear frame'
function pushbutton22_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton22 (see GCBO)
% eventdata  reserved - to be defined in areaval future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
bw=handles.bws(:,:,handles.phframe);
bw=zeros(size(bw));
handles.bws(:,:,handles.phframe)=bw;
guidata(hObject,handles);


function edit8_Callback(hObject, eventdata, handles)
% hObject    handle to edit8 (see GCBO)
% eventdata  reserved - to be defined in areaval future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit8 as text
%        str2double(get(hObject,'String')) returns contents of edit8 as areaval double
user_num = str2num(get(hObject,'String'));
if isnan(user_num)
    errordlg('You must enter a numeric value','Bad Input','modal')
    return
end
if (user_num>=handles.flmax3)
    errordlg('You must enter a value less than the max','Bad Input','modal')
    return
end
handles.flmin3=user_num;
axes(handles.flaxes3);
handles.flim3=imshow(handles.fl3(handles.flframe3).data,[handles.flmin3,handles.flmax3]);
set(handles.flim3, 'HitTest', 'off');
guidata(hObject,handles);


% --- Executes during object creation, after setting all properties.
function edit8_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit8 (see GCBO)
% eventdata  reserved - to be defined in areaval future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have areaval white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit9_Callback(hObject, eventdata, handles)
% hObject    handle to edit9 (see GCBO)
% eventdata  reserved - to be defined in areaval future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit9 as text
%        str2double(get(hObject,'String')) returns contents of edit9 as areaval double
user_num = str2num(get(hObject,'String'));
if isnan(user_num)
    errordlg('You must enter a numeric value','Bad Input','modal')
    return
end
if (user_num<=handles.flmin3)
    errordlg('You must enter a value greater than the min','Bad Input','modal')
    return
end
handles.flmax3=user_num;
axes(handles.flaxes3);
handles.flim3=imshow(handles.fl3(handles.flframe3).data,[handles.flmin3,handles.flmax3]);
set(handles.flim3, 'HitTest', 'off');
guidata(hObject,handles);


% --- Executes during object creation, after setting all properties.
function edit9_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit9 (see GCBO)
% eventdata  reserved - to be defined in areaval future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have areaval white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Executes on button press in intssave.
function intssave_Callback(hObject, eventdata, handles)
% hObject    handle to intssave (see GCBO)
% eventdata  reserved - to be defined in areaval future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

celldatas=handles.celldatas;
celldata=handles.celldata;
celldatas=[celldatas; celldata];
handles.celldatas=celldatas;
celldatas=handles.celldatas;

csize=size(celldatas);
flusize=csize(1);
set(handles.datanum, 'String',num2str(flusize));

spotdatas=handles.spotdatas;
spotdata=handles.spotdata;
spotdatas=[spotdatas; spotdata];
handles.spotdatas=spotdatas;

guidata(hObject,handles);



function thrsize_Callback(hObject, eventdata, handles)
% hObject    handle to thrsize (see GCBO)
% eventdata  reserved - to be defined in areaval future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of thrsize as text
%        str2double(get(hObject,'String')) returns contents of thrsize as areaval double

user_num = str2num(get(hObject,'String'));
handles.thr_size=user_num;

guidata(hObject,handles);


% --- Executes during object creation, after setting all properties.
function thrsize_CreateFcn(hObject, eventdata, handles)
% hObject    handle to thrsize (see GCBO)
% eventdata  reserved - to be defined in areaval future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have areaval white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Executes on mouse press over axes background. 
function axes13_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to axes13 (see GCBO)
% eventdata  reserved - to be defined in areaval future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% pt = get(gcf, 'CurrentPoint');
% refcoords=get(handles.axes13,'Position');
% rect=handles.myrect;
% I=imcrop(handles.ph(handles.phframe).data,rect);
% csize=size(I);
% if csize(1)>csize(2)
%     row=csize(1)-round(csize(1)*(double((pt(2)-refcoords(2)))/double(refcoords(4)))-0.5);
%     col=round(csize(1)*(double((pt(1)-refcoords(1)))/double(refcoords(3)))+0.5)-round(((csize(1)-csize(2))/2));
% else col=round(csize(2)*(double((pt(1)-refcoords(1)))/double(refcoords(3)))+0.5);
%     row=csize(1)-round(csize(2)*(double((pt(2)-refcoords(2)))/double(refcoords(4)))-0.5)+round(((csize(2)-csize(1))/2));
% end
% if(row>csize(1))
%     row=csize(1);
% elseif(row<1)
%     row=1;
% end
% if(col>csize(2))
%     col=csize(2);
% elseif(col<1)
%     col=1;
% end
% 
% IF=imcrop(handles.fl(handles.flframe).data,rect);
% 
% axes(handles.axes12);
% handles.mccursor=rectangle('Position',[col-1 row-1 2 2],'EdgeColor','r');
% set(handles.mccursor,'HitTest', 'off');
% 
% colref1=col;
% rowref1=row;
% 
% handles.spix=2;
% 
% %seaching maximum region - 25
% dmatrix2=zeros(2*handles.spix+1,2*handles.spix+1);
% for row=(rowref1-handles.spix):(rowref1+handles.spix),
%     for col=(colref1-handles.spix):(colref1+handles.spix),
%         sumval=int32(0);
%         for i=(row-2):(row+2),
%             for j=(col-2):(col+2),
%                 if(1<=i) && (i<=csize(1))
%                     if(1<=j) && (j<=csize(2))
%                         sumval=sumval+double(IF(i,j));
%                     end
%                 end
%             end
%         end
%         dmatrix2(row-rowref1+handles.spix+1,col-colref1+handles.spix+1)=sumval;
%     end
% end
% 
% mx2=max(max(dmatrix2));
% 
% vensum=handles.vensum;
% area=handles.area;
% ptmax=mx2/25;
% maxpt=ptmax-(vensum*area-ptmax*25)/(area-25);
% handles.maxpt=maxpt;
% handles.ptmax=ptmax;
% %end -- seaching maximum region in Venus - 25
% 
% %seaching maximum region - 9
% dmatrix9=zeros(2*handles.spix+1,2*handles.spix+1);
% for row=(rowref1-handles.spix):(rowref1+handles.spix),
%     for col=(colref1-handles.spix):(colref1+handles.spix),
%         sumval=int32(0);
%         for i=(row-1):(row+1),
%             for j=(col-1):(col+1),
%                 if((1<=i)&(i<=csize(1)))
%                     if((1<=j)&(j<=csize(2)))
%                         sumval=sumval+double(IF(i,j));
%                     end
%                 end
%             end
%         end
%         dmatrix9(row-rowref1+handles.spix+1,col-colref1+handles.spix+1)=sumval;
%     end
% end
% 
% mx9=max(max(dmatrix9));
% 
% for i=1:2*handles.spix+1,
%     for j=1:2*handles.spix+1,
%         if dmatrix9(i,j)==mx9
%             mcmaxx9=i;
%             mcmaxy9=j;
%         end
%     end
% end
% colref3=colref1-handles.spix+mcmaxx9-1;
% rowref3=rowref1-handles.spix+mcmaxy9-1;
% 
% handles.maxcol=colref3;
% handles.maxrow=rowref3;
% 
% axes(handles.axes14);
% text(colref3,rowref3,'X','color','r');
% 
% mx9=mx9/9;
% handles.maxpt9=mx9-(vensum*area-mx9*9)/(area-9);
% handles.ptmax9=mx9;
% %end -- seaching maximum region in Venus - 9
% 
% % 2015-02-17, 2D gaussian fitting to determine spot position
% maxcent_c=colref3;
% maxcent_r=rowref3;
% 
% image25=zeros(5,5);
% m=1;
% n=1;
% for k = maxcent_r-2:maxcent_r+2
%     for l = maxcent_c-2:maxcent_c+2
%         image25(m,n)=double(IF(k,l));
%         n=n+1;
%     end
%     n=1;
%     m=m+1;
% end
% 
% [gaucentx,gaucenty,sx,sy,peakOD]=Gaussian2D(image25,10^-6,0);
% 
% % conversion to map coordinate
% gaucentx=maxcent_c-(3-gaucentx);
% gaucenty=maxcent_r-(3-gaucenty);
% 
% % 5by5 region around gaussian center
% gx=round(gaucentx);
% gy=round(gaucenty);
% ptgau=0;
% ptmaxgau=0;
% for k = gy-2:gy+2
%     for l = gx-2:gx+2
%         ptgau=ptgau+double(IF(k,l));
%     end
% end
% ptgau=ptgau/25;
% if ptgau > ptmaxgau
%     ptmaxgau = ptgau;
%     maxptgau = ptgau-(vensum*area-ptgau*25)/(area-25);
% end
% 
% handles.gaucentx=gaucentx;
% handles.gaucenty=gaucenty;
% handles.sx=sx;
% handles.sy=sy;
% handles.peakOD=peakOD;
% [sx,sy]
% 
% handles.ptmaxgau=ptmaxgau;
% handles.maxptgau=maxptgau;
% % 2015-02-17, end
% 
% % 2013-11-26 SR, estimating the shortest distance between the membrane(cell
% % boundary) and dot location, minmddistance
% b=handles.boundary;
% 
% bsize=size(b);
% minmddistance=100;
% 
% mx=0;
% my=0;
% 
% for j = 1:bsize(1)
%     mddistance=sqrt((gaucenty-b(j,1))^2+(gaucentx-b(j,2))^2);
%     if minmddistance > mddistance
%         minmddistance=mddistance;
%         mx=b(j,1);
%         my=b(j,2);
%     end
% end
% 
% handles.mx=mx;
% handles.my=my;
% handles.minmddistance=minmddistance;
% % end
% 
% axes(handles.axes14);
% handles.venmax2cursor=rectangle('Position',[gaucentx-1 gaucenty-1 2 2],'EdgeColor','g');
% set(handles.venmax2cursor,'HitTest', 'off');
% 
% set(handles.snr, 'String',num2str(maxptgau));
% set(handles.venmaxxy,'String',[num2str(gaucentx) ', ' num2str(gaucenty)]);
% set(handles.carea,'String',num2str(area));
% set(handles.vencon,'String',num2str(vensum));
% 
% %seaching maximum region - 49
% dmatrix49=zeros(2*handles.spix+1,2*handles.spix+1);
% for row=(rowref1-handles.spix):(rowref1+handles.spix),
%     for col=(colref1-handles.spix):(colref1+handles.spix),
%         sumval=int32(0);
%         for i=(row-3):(row+3),
%             for j=(col-3):(col+3),
%                 if((1<=i)&(i<=csize(1)))
%                     if((1<=j)&(j<=csize(2)))
%                         sumval=sumval+double(IF(i,j));
%                     end
%                 end
%             end
%         end
%         dmatrix49(row-rowref1+handles.spix+1,col-colref1+handles.spix+1)=sumval;
%     end
% end
% mx49=max(max(dmatrix49));
% mx49=mx49/49;
% handles.maxpt49=mx49-(vensum*area-mx49*49)/(area-49);
% handles.ptmax49=mx49;
% %end -- seaching maximum region in Venus - 49
% 
% %2015-02-18 add
% axes(handles.cropaxes2);
% text(gaucentx,gaucenty,'    ','color','g');
% text(gaucentx,gaucenty,'X','color','g');


guidata(hObject,handles);


% --- Executes during object creation, after setting all properties.
function axes13_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes13 (see GCBO)
% eventdata  reserved - to be defined in areaval future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axes13


% --- Executes on mouse press over axes background.
function axes12_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to axes12 (see GCBO)
% eventdata  reserved - to be defined in areaval future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)




function thrSNR_Callback(hObject, eventdata, handles)
% hObject    handle to thrSNR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of thrSNR as text
%        str2double(get(hObject,'String')) returns contents of thrSNR as a double


user_num = str2num(get(hObject,'String'));
handles.thr_SNR=user_num;

guidata(hObject,handles);



% --- Executes during object creation, after setting all properties.
function thrSNR_CreateFcn(hObject, eventdata, handles)
% hObject    handle to thrSNR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
