function varargout = threecolorconc(varargin)
% THREECOLORCONC M-file for threecolorconc.fig
%      THREECOLORCONC, by itself, creates a new THREECOLORCONC or raises the existing
%      singleton*.
%
%      H = THREECOLORCONC returns the handle to a new THREECOLORCONC or the handle to
%      the existing singleton*.
%
%      THREECOLORCONC('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in THREECOLORCONC.M with the given input arguments.
%
%      THREECOLORCONC('Property','Value',...) creates a new THREECOLORCONC or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before viewstk3conc_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to threecolorconc_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".im
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help threecolorconc

% Last Modified by GUIDE v2.5 29-Apr-2010 00:34:51


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
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to threecolorconc (see VARARGIN)

string1=mat2str(cell2mat(varargin(1)));
string2=mat2str(cell2mat(varargin(2)));
%imfilename1=[string1 '\' string2 'dic.stk'];
%imfilename2=[string1 '\' string2 'gfp.stk'];

imfilename1=[string1(2:end-1) '\' string2(2:end-1) 'BF.tif'];
imfilename2=[string1(2:end-1) '\' string2(2:end-1) '488nm.tif'];
imfilename3=[string1(2:end-1) '\' string2(2:end-1) '488nm.tif'];
imfilename4=[string1(2:end-1) '\' string2(2:end-1) '488nm.tif'];

%imfilename1=[string1 '\dic' string2 '.stk'];
%imfilename2=[string1 '\gfp' string2 '.stk'];

%string1=mat2str(cell2mat(varargin(1)));
%imfilename1=[string1 'dic.stk' ];
%imfilename2=[string1 'gfp.stk' ];
handles.ph = tiffreadnew2(imfilename1);
handles.fl = tiffreadnew2(imfilename2);
handles.fl2 = tiffreadnew2(imfilename3);
handles.fl3 = tiffreadnew2(imfilename4);
handles.phframe=1;
handles.flframe=1;
handles.flframe2=1;
handles.flframe3=1;
handles.phmax=2000;
handles.phmin=000;
handles.flmax=5000;
handles.flmin=0;
handles.flmax2=2000;
handles.flmin2=0;
handles.flmax3=7000;
handles.flmin3=0;
axes(handles.flaxes);
handles.flim=imshow(handles.fl(handles.flframe).data,[handles.flmin,handles.flmax]);
set(handles.flim, 'HitTest', 'off');
axes(handles.flaxes2);
handles.flim2=imshow(handles.fl2(handles.flframe2).data,[handles.flmin2,handles.flmax2]);
set(handles.flim2, 'HitTest', 'off');
axes(handles.flaxes3);
handles.flim3=imshow(handles.fl3(handles.flframe3).data,[handles.flmin3,handles.flmax3]);
set(handles.flim3, 'HitTest', 'off');
axes(handles.phaxes);
handles.phim=imshow(handles.ph(handles.phframe).data,[handles.phmin,handles.phmax]);
set(handles.phim, 'HitTest', 'off');
set(handles.figure1, 'HitTest', 'off');
handles.col=0;
handles.row=0;
handles.boxtype=1;
handles.showcell=0;
handles.showdot=0;
handles.savefile='data';


disp(['Processing frame:      ']);
bws=[];
vendots={};

%for cframe=1:2,%check 347 line
for cframe=1:size(handles.ph,2),%check 347 line
    if (cframe==1)
        disp(sprintf('\b\b\b\b\b%4i', cframe))
    else
        disp(sprintf('\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b%4i', cframe))
    end
    
    I=handles.ph(cframe).data;
    %I=handles.fl2(cframe).data;
    %I=max(max(I))-I;
    %level=graythresh(I);
    %bw=im2bw(I,level);
    %Read images
    
    % Taeki's part : using image histogram and regionprops function,
    %                only finds 'single' cell, not aggregated.
    UNSHARPCONST = 0.2;
    BIN = 800;
    CELLSIZEMIN = 50;
    CELLSIZEMAX = 500;
    LIGHTSPOTDECLARECONST = 0.95;

    im = double(I);
    bgr = min(min(im));
    im = im - bgr;

    sfilter = fspecial('unsharp');
    sh = imfilter(im,sfilter,UNSHARPCONST);

    sz = size(I);
    %wth = width of image, hgt = height of image
    hgt = sz(1);
    wth = sz(2);

    toohighintensityposition = round(LIGHTSPOTDECLARECONST*wth*hgt);
    resh = reshape(sh, [1 wth*hgt]);
    sortresh = sort(resh, 'ascend');
    toohighintensityvalue = sortresh(1,toohighintensityposition);
    
    sortresh2 = zeros(1,wth*hgt);
    n = 0;
    for x=1:hgt*wth,
        if resh(1,x) > 0
            if resh(1,x) < toohighintensityvalue
                n = n+1;
                sortresh2(1,n) = resh(1,x);
            end
        end
    end
    
    vec = zeros(1,n);
    for x=1:n,
        vec(1,x) = sortresh2(1,x);
    end
    
    method1 = zeros(wth,hgt);
    method4 = zeros(wth,hgt);
    method1 = 1 + method1;

    histo = hist(vec, BIN);
    %figure, hist(vec, BIN);

    histomax = max(histo);
    for x=1:BIN,
        if histo(x) == histomax
            maxposition = x;
        end
    end

    PMINTHRESH = 0.01*histo(maxposition);

    minposition = maxposition;
    for x=3:maxposition,
        if histo(x-1) > histo(x) && histo(x-2) > histo(x)
            if histo(x+1) > histo(x) && histo(x+2) > histo(x)
                if histo(x) < histo(minposition) + PMINTHRESH
                    minposition = x;
                end
            end
        end
    end

    if minposition == maxposition
        minposition = 0.679 * maxposition;
        % 0.679 is an experimental value, not reasonable one.
    end

    edgevalue1 = max(vec) * minposition / BIN;

    for y=1:wth,
        for z=1:hgt,
            if im(y,z) > edgevalue1
                % bw image from image histogram
                method1(y,z) = 0;
            end
        end
    end

    cc = bwconncomp(method1);
    stats = regionprops(cc, 'Area');
    
    % Cell size minimum criteria : holes from background usually filtered here
    idx1 = find([stats.Area] > CELLSIZEMIN);
    method4min = ismember(labelmatrix(cc), idx1);
    % Cell size maximum criteria : attached 2 or more cells usually filtered here
    idx2 = find([stats.Area] < CELLSIZEMAX);
    method4max = ismember(labelmatrix(cc), idx2);

    for y=1:wth,
        for z=1:hgt,
            if method4max(y,z) > 0 && method4min(y,z) > 0
                % Cells match with both min, max criteria is defined
                method4(y,z) = 1;
            end
        end
    end

    %figure, imshow(method1);
    %figure, imshow(method4max);
    %figure, imshow(method4min);
    %figure, imshow(method4);
    
    bw = method4;
    
    % Cells cut is erazed    -----------------------
    for y=1:wth,
        bw(y,hgt)=1;
        bw(y,1)=1;
        bw(y,hgt-1)=1;
        bw(y,2)=1;
    end
    for z=1:hgt,
        bw(wth,z)=1;
        bw(1,z)=1;
        bw(wth-1,z)=1;
        bw(2,z)=1;
    end
    % Cells cut is erazed    -----------------------
    
    
    %{
    This part is originally NKLee's part to eraze aggregated cell, but
    Taeki's work covers all of this and more memory-efficient way.
    
    [labeled,numObjects] = bwlabel(bw,4);
    for i = 1:numObjects,
        rc = find(bwlabel(labeled,4)==i);
        % In original, we decide cell size here but.. it already did.
        %if ((length(rc)<20) || (length(rc)>200)) 
            %bw(rc)=0;
        %end
    end
    %}
    
    bws=cat(3,bws,bw);% make stack of corrected bw image
    
%{
    axes(handles.phaxes);
    imshow(bw);
    axes(handles.flaxes);
    se=strel('disk',15);
    se2=strel('disk',10);
    imshow(imsubtract(imdilate(bw,se),imdilate(bw,se2)));
%}
    
    %start dots------------------------------------
    vendot=[];
        
    I2=handles.fl(cframe).data;
    I3=handles.fl2(cframe).data;
    I4=handles.fl3(cframe).data;
    
    se=strel('disk',15);
    se2=strel('disk',10);
    bwdil=imdilate(bw,se);
    bwdil2=imdilate(bw,se2);
    
    
    %se=strel('disk',1);
    %I3=imsubtract(I3,imopen(I3,se));
%     [labeleddil,numObjectsdil] = bwlabel(bwdil,4);
%     bgs1=[];
%     bgs2=[];
%     bgs3=[];
%     for i=1:numObjectsdil,
%         bg1=double(0);
%         bg2=double(0);
%         bg3=double(0);
%         bgsize=double(0);
%         [rdil,cdil]=find(bwlabel(labeleddil,4)==i);
%         for j=1:length(rdil),
%             if(bwdil2(rdil(j),cdil(j))==0)
%                 bg1=bg1+double(I2(rdil(j),cdil(j)));
%                 bg2=bg2+double(I3(rdil(j),cdil(j)));
%                 bg3=bg3+double(I4(rdil(j),cdil(j)));
%                 bgsize=bgsize+1;
%             end
%         end
%         bg1=double(bg1)/double(bgsize);
%         bgs1=[bgs1;bg1];
%         bg2=double(bg2)/double(bgsize);
%         bgs2=[bgs2;bg2];
%         bg3=double(bg3)/double(bgsize);
%         bgs3=[bgs3;bg3];
%     end
    
    %level=graythresh(I2);
    %bw2=im2bw(I2,level);
    %se=strel('disk',1);
    %bw2=imdilate(bw2,se);

    [labeled,numObjects] = bwlabel(bw,4);

    I2=double(I2);
    I3=double(I3);
    I4=double(I4);
    
    I2bg=mode(mode(I2));
    I3bg=mode(mode(I3));
    I4bg=mode(mode(I4));

    disp(['Total objects:      ']);
    disp(sprintf('\b\b\b\b\b%4i', numObjects));
    disp(['Analyzing objects number:      ']);
    
    for i=1:numObjects,
    disp(sprintf('\b\b\b\b\b%4i', i));
    [r,c]=find(bwlabel(labeled,4)==i);

        if(length(r)>0),
        axes(handles.cropaxes2);
        bwcrop=imcrop(bw,[min(c)-2 min(r)-2 max(c)-min(c)+4 max(r)-min(r)+4]);
        %bw2crop=imcrop(bw2,[min(c)-2 min(r)-2 max(c)-min(c)+4 max(r)-min(r)+4]);
        %I2crop=imcrop(I2,[min(c)-2 min(r)-2 max(c)-min(c)+4 max(r)-min(r)+4]);
        %I3crop=imcrop(I3,[min(c)-2 min(r)-2 max(c)-min(c)+4 max(r)-min(r)+4]);

        %bw2crop=bwcrop.*bw2crop;
        %[labeled2,numObjects2] = bwlabel(bwcrop,4);
    
        vensum=double(0);
        mcsum=double(0);
        cfpsum=double(0);
            for j=1:length(r),
                vensum=vensum+double(I3(r(j),c(j)));
                cfpsum=cfpsum+double(I2(r(j),c(j)));
                mcsum=mcsum+double(I4(r(j),c(j)));
            end
        vensum=double(vensum)/double(length(r));
        cfpsum=double(cfpsum)/double(length(r));
        mcsum=double(mcsum)/double(length(r));
        %vendot=[vendot;cfpsum vensum mcsum bgs1(labeleddil(r(1),c(1))) bgs2(labeleddil(r(1),c(1))) bgs3(labeleddil(r(1),c(1)))];
        %vendot=[vendot;r(1) c(1) cfpsum vensum mcsum length(r) cframe bgs1(labeleddil(r(1),c(1))) bgs2(labeleddil(r(1),c(1))) bgs3(labeleddil(r(1),c(1)))];
        vendot=[vendot;r(1) c(1) cfpsum vensum mcsum length(r) cframe I2bg I3bg I4bg ];
    %{
    for j=1:numObjects2,
        [r2,c2]=find(bwlabel(labeled2,4)==j);
        sum=double(0);
        maxsum=double(0);
        maxi=0;
        %I2crop=double(I2crop);
        for i=1:length(r2),
            x1=r2(i)+min(r)-3;
            y1=c2(i)+min(c)-3;
            if ((x1>1)&(y1>1)&(x1<size(I2,1))&(y1<size(I2,2))),
                sum=double(I2(x1,y1)+I2(x1-1,y1)+I2(x1+1,y1)+I2(x1,y1-1)+I2(x1,y1+1)+I2(x1-1,y1-1)+I2(x1-1,y1+1)+I2(x1+1,y1-1)+I2(x1+1,y1+1))/9;
            %sum=double((I2crop(r2(i),c2(i))+I2crop(r2(i)-1,c2(i))+I2crop(r2(i)+1,c2(i))+I2crop(r2(i),c2(i)-1)+I2crop(r2(i),c2(i)+1)+I2crop(r2(i)-1,c2(i)-1)+I2crop(r2(i)-1,c2(i)+1)+I2crop(r2(i)+1,c2(i)-1)+I2crop(r2(i)+1,c2(i)+1)))/9;
            end
            if(sum>maxsum)
                maxsum=sum;
                maxi=i;
            end
        end
        %axes(handles.cropaxes);
        %if(maxi>0)&(j==2)
            %summatr
            %maxi
            %r2(maxi)
            %c2(maxi)
        %I2crop=imcrop(I2,[min(c)-2 min(r)-2 max(c)-min(c)+4 max(r)-min(r)+4]);
        %I2crop(r2(maxi),c2(maxi))=0;
        %imshow(I2crop,[handles.flmin,handles.flmax]);
        %handles.flcursor=rectangle('Position',[10 5 1 1],'EdgeColor','r');
        %handles.flcursor=rectangle('Position',[c2(maxi) r2(maxi) 1 1],'EdgeColor','r');
        %axes(handles.cropaxes2);
        %imshow(bw2crop);
        %end
        axes(handles.flaxes);
        if(maxi>0)
            mcdot=[mcdot;r2(maxi)+min(r)-2-1 c2(maxi)+min(c)-2-1 sum];
            %handles.flcursor=rectangle('Position',[c2(maxi)+min(c)-2 r2(maxi)+min(r)-2 5 5],'EdgeColor','r');
        %handles.flcursor=rectangle('Position',[c2(maxi) r2(maxi) 2 2],'EdgeColor','r');
            maxsumven=double(0);
            sum=double(0);
            dotval=0;
            %I3crop=double(I3crop);
            for venr=(r2(maxi)+min(r)-2-1-2):(r2(maxi)+min(r)-2-1+2),
                for venc=(c2(maxi)+min(c)-2-1-2):(c2(maxi)+min(c)-2-1+2),
                    %sum=double(abs((-8)*I3crop(venr,venc)+I3crop(venr-1,venc)+I3crop(venr+1,venc)+I3crop(venr,venc-1)+I3crop(venr,venc+1)+I3crop(venr-1,venc-1)+I3crop(venr-1,venc+1)+I3crop(venr+1,venc+1)+I3crop(venr+1,venc-1)));
                    sum=double(abs((-8)*I3(venr,venc)+I3(venr-1,venc)+I3(venr+1,venc)+I3(venr,venc-1)+I3(venr,venc+1)+I3(venr-1,venc-1)+I3(venr-1,venc+1)+I3(venr+1,venc+1)+I3(venr+1,venc-1)));
                    %sum=double((I3(venr,venc)+I3(venr-1,venc)+I3(venr+1,venc)+I3(venr,venc-1)+I3(venr,venc+1)+I3(venr-1,venc-1)+I3(venr-1,venc+1)+I3(venr+1,venc+1)+I3(venr+1,venc-1))/9);
                    if(sum>maxsumven)
                        maxsumven=sum;
                        maxvenr=venr;
                        maxvenc=venc;
                        dotval=double((I3(venr,venc)+I3(venr-1,venc)+I3(venr+1,venc)+I3(venr,venc-1)+I3(venr,venc+1)+I3(venr-1,venc-1)+I3(venr-1,venc+1)+I3(venr+1,venc+1)+I3(venr+1,venc-1))/9);
                    end
                end
            end
            venr=r2(maxi)+min(r)-3;
            venc=c2(maxi)+min(c)-3;
            dotvalmc=double((I3(venr,venc)+I3(venr-1,venc)+I3(venr+1,venc)+I3(venr,venc-1)+I3(venr,venc+1)+I3(venr-1,venc-1)+I3(venr-1,venc+1)+I3(venr+1,venc+1)+I3(venr+1,venc-1))/9);
            vendot=[vendot;maxvenr maxvenc dotval vensum dotvalmc length(r) cframe bgs(labeleddil(venr,venc))];
            %axes(handles.flaxes2);
            %handles.flcursor=rectangle('Position',[maxvenc maxvenr 5 5],'EdgeColor','g');
            %handles.flcursor=rectangle('Position',[maxvenc+min(c)-2 maxvenr+min(r)-2 5 5],'EdgeColor','g');
        end
    end  % for all dots
    %}
        end  % if cell exists
    end  % for all cells
    
    vendots=[vendots vendot];
    
end % for all frames
handles.bws=bws;
handles.bwsorig=bws;
handles.vendots=vendots;


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
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton21.
function pushbutton21_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton21 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%mcdots=handles.mcdots;
vendots=handles.vendots;
venlist=[];
%for i=1:9,
for i=1:size(handles.ph,2)
    vendot=vendots{i};
    %mcdot=mcdots{i};
    bw=handles.bws(:,:,i);
    for i=1:size(vendot,1)
        if(bw(vendot(i,1),vendot(i,2))==1)
            %venlist=[venlist;vendot(i,1) vendot(i,2) vendot(i,3) vendot(i,4) vendot(i,5) vendot(i,8) vendot(i,9) vendot(i,10)];
            venlist=[venlist;vendot(i,1) vendot(i,2) vendot(i,3) vendot(i,4) vendot(i,5) vendot(i,6) vendot(i,7) vendot(i,8) vendot(i,9) vendot(i,10)];
        end%vendot=[vendot;r(1) c(1) cfpsum vensum mcsum length(r) cframe bgs1(labeleddil(r(1),c(1))) bgs2(labeleddil(r(1),c(1))) bgs3(labeleddil(r(1),c(1)))];
    end
end    
save(handles.savefile,'venlist');
guidata(hObject,handles);



% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
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
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
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
% eventdata  reserved - to be defined in a future version of MATLAB
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
% eventdata  reserved - to be defined in a future version of MATLAB
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
axes(handles.flaxes2);
handles.flim2=imshow(handles.fl2(handles.flframe2).data,[handles.flmin2,handles.flmax2]);
set(handles.flim2, 'HitTest', 'off');
set(handles.frval3,'String',num2str(handles.flframe2));



guidata(hObject,handles);


% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
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
axes(handles.flaxes2);
handles.flim2=imshow(handles.fl2(handles.flframe2).data,[handles.flmin2,handles.flmax2]);
set(handles.flim2, 'HitTest', 'off');
set(handles.frval3,'String',num2str(handles.flframe2));
axes(handles.flaxes3);
handles.flim3=imshow(handles.fl3(handles.flframe3).data,[handles.flmin3,handles.flmax3]);
set(handles.flim2, 'HitTest', 'off');
set(handles.frval4,'String',num2str(handles.flframe3));



guidata(hObject,handles);

% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
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
% eventdata  reserved - to be defined in a future version of MATLAB
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
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double
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
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double
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
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit3_Callback(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit3 as text
%        str2double(get(hObject,'String')) returns contents of edit3 as a double
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
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit4_Callback(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit4 as text
%        str2double(get(hObject,'String')) returns contents of edit4 as a double
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
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




% --- Executes on mouse press over axes background.
function flaxes_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to flaxes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 

% --- Executes on mouse press over axes background.
function phaxes_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to phaxes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on mouse press over axes background.
function axes5_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to axes5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
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



% --- Executes on mouse press over axes background.
function axes6_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to axes6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
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

bw=handles.bws(:,:,handles.phframe);
bworig=handles.bwsorig(:,:,handles.phframe);

[labeled,numObjects] = bwlabel(bw,4);
[labeledorig,numObjectsorig] = bwlabel(bworig,4);

if(labeled(row,col)>0),
    rc= labeled==labeled(row,col);
    bw(rc)=0;
elseif(labeledorig(row,col)>0),
    rc= labeledorig==labeledorig(row,col);
    bw(rc)=1;
end
handles.bws(:,:,handles.phframe)=bw;

axes(handles.phaxes);
handles.phim=imshow(handles.ph(handles.phframe).data,[handles.phmin,handles.phmax]);
set(handles.phim, 'HitTest', 'off');
bw=handles.bws(:,:,handles.phframe);

[labeled,numObjects] = bwlabel(bw,4);

I=handles.ph(handles.phframe).data;
axes(handles.phaxes);
boundaries=bwboundaries(bw,4,'noholes');
hold on;
for ii=1:numObjects,
    b=boundaries{ii};
    h=plot(b(:,2),b(:,1),'y','LineWidth',1);
    set(h, 'HitTest', 'off');
end
hold off;

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
% eventdata  reserved - to be defined in a future version of MATLAB
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
patches=zeros(area,2);
sdsum=0;
for j = 1:area
    sdsum=(double(IF(r(j),c(j)))-fsum)^2+sdsum;
end
sdsum=sqrt(sdsum/area);
IF2=IF-fsum-1.5*sdsum;
IF2=im2bw(IF2,.1/65536);
IF2=imopen(IF2,strel('disk',1));
% for now figure,imshow(IF2,[0 1]);
for j = 1:area
    %{
    patches(j)=patches(j)+calcpatch(bw,FL,-1,0,r,c,j,fsum);
    patches(j)=patches(j)+calcpatch(bw,FL,1,0,r,c,j,fsum);
    patches(j)=patches(j)+calcpatch(bw,FL,0,-1,r,c,j,fsum);
    patches(j)=patches(j)+calcpatch(bw,FL,0,1,r,c,j,fsum);
    if(patches(j)>maxpt)
        maxpt=patches(j);
        maxj=j;
    end
    %}
    pt9=double(FL(r(j),c(j)))+double(FL(r(j)-1,c(j)))+double(FL(r(j)+1,c(j)))+double(FL(r(j),c(j)+1))+double(FL(r(j)-1,c(j)+1))+double(FL(r(j)+1,c(j)+1))+double(FL(r(j),c(j)-1))+double(FL(r(j)-1,c(j)-1))+double(FL(r(j)+1,c(j)-1));
    pt9=pt9/9;
    %if(pt9>ptmax)
    %    ptmax=pt9;
    %end
    %pt9=(double(FL(r(j),c(j)))-S1(count))^2+(double(FL(r(j)-1,c(j)))-S1(count))^2+(double(FL(r(j)+1,c(j)))-S1(count))^2+(double(FL(r(j),c(j)+1))-S1(count))^2+(double(FL(r(j)-1,c(j)+1))-S1(count))^2+(double(FL(r(j)+1,c(j)+1))-S1(count))^2+(double(FL(r(j),c(j)-1))-S1(count))^2+(double(FL(r(j)-1,c(j)-1))-S1(count))^2+(double(FL(r(j)+1,c(j)-1))-S1(count))^2;
    %pt9=sqrt(pt9)/9;
    if(((double(FL(r(j),c(j)))-double(FL(r(j)+1,c(j))))>0)&((double(FL(r(j),c(j)))-double(FL(r(j)-1,c(j))))>0)&((double(FL(r(j),c(j)))-double(FL(r(j),c(j)+1)))>0)&((double(FL(r(j),c(j)))-double(FL(r(j),c(j)-1)))>0))
        pt4=(double(FL(r(j),c(j)))-double(FL(r(j)+1,c(j))))^2+(double(FL(r(j),c(j)))-double(FL(r(j)-1,c(j))))^2+(double(FL(r(j),c(j)))-double(FL(r(j),c(j)+1)))^2+(double(FL(r(j),c(j)))-double(FL(r(j)+1,c(j)-1)))^2;
    else
        pt4=0;
    end
    %pt4=(pt4);
    %pt4=pt4*pt9;
    %pt4=pt9;
    patches(j,1)=pt9;
    patches(j,2)=j;
    if((pt4>ptmax)&(pt9>fsum))
        ptmax=pt4;
        maxj=j;
        maxpt=pt9-(fsum*area-pt9*9)/(area-9);
    end
end
%{
patches2=sortrows(patches);
for row=1:size(FL,1)
    for col=1:size(FL,2)
        FL(row,col)=0;
    end
end
for k=round((area*.9)):area
    FL(r(patches2(k,2)),c(patches2(k,2)))=1;
end
%}

%{
maxpt2=0;
maxj2=1;
ptmax2=0;
for j = 1:area
    pt9=double(FL(r(j),c(j)))+double(FL(r(j)-1,c(j)))+double(FL(r(j)+1,c(j)))+double(FL(r(j),c(j)+1))+double(FL(r(j)-1,c(j)+1))+double(FL(r(j)+1,c(j)+1))+double(FL(r(j),c(j)-1))+double(FL(r(j)-1,c(j)-1))+double(FL(r(j)+1,c(j)-1));
    pt9=pt9/9;
    pt4=(double(FL(r(j),c(j)))-double(FL(r(j)+1,c(j))))^1+(double(FL(r(j),c(j)))-double(FL(r(j)-1,c(j))))^1+(double(FL(r(j),c(j)))-double(FL(r(j),c(j)+1)))^1+(double(FL(r(j),c(j)))-double(FL(r(j)+1,c(j)-1)))^1;
    dist=(r(j)-r(maxj))^2+(c(j)-c(maxj))^2;
    pt4=pt4*pt9;
    if((pt4>ptmax2)&(pt9>fsum))
        if(dist>25)
            ptmax2=pt4;
            maxj2=j;
            maxpt2=pt9-fsum;
        end
    end
end
%}
%figure,plot(linspace(1,area,area),patches,'r',linspace(1,area,area),patches2,'b');
set(handles.intval,'String',num2str(fsum));
handles.bw=bw;
axes(handles.cropaxes2);
%imshow(FL,[0 1]);
imshow(IF,[handles.flmin,handles.flmax]);
text(c(maxj),r(maxj),['    ' num2str(maxpt)],'color','r');
set(handles.intval,'String',num2str(maxpt));
set(handles.fsum,'String',num2str(area));
text(c(maxj),r(maxj),'X','color','r');
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


% --- Executes on button press in calcint.
function calcint_Callback(hObject, eventdata, handles)
% hObject    handle to calcint (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
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
area
for j = 1:area
    pt9=double(FL(r(j),c(j)))+double(FL(r(j)-1,c(j)))+double(FL(r(j)+1,c(j)))+double(FL(r(j),c(j)+1))+double(FL(r(j)-1,c(j)+1))+double(FL(r(j)+1,c(j)+1))+double(FL(r(j),c(j)-1))+double(FL(r(j)-1,c(j)-1))+double(FL(r(j)+1,c(j)-1));
    pt9=pt9/9;
    %if(pt9>ptmax)
    %    ptmax=pt9;
    %end
    %pt9=(double(FL(r(j),c(j)))-S1(count))^2+(double(FL(r(j)-1,c(j)))-S1(count))^2+(double(FL(r(j)+1,c(j)))-S1(count))^2+(double(FL(r(j),c(j)+1))-S1(count))^2+(double(FL(r(j)-1,c(j)+1))-S1(count))^2+(double(FL(r(j)+1,c(j)+1))-S1(count))^2+(double(FL(r(j),c(j)-1))-S1(count))^2+(double(FL(r(j)-1,c(j)-1))-S1(count))^2+(double(FL(r(j)+1,c(j)-1))-S1(count))^2;
    %pt9=sqrt(pt9)/9;
    %pt4=(double(FL(r(j),c(j)))-double(FL(r(j)+1,c(j))))^2+(double(FL(r(j),c(j)))-double(FL(r(j)-1,c(j))))^2+(double(FL(r(j),c(j)))-double(FL(r(j),c(j)+1)))^2+(double(FL(r(j),c(j)))-double(FL(r(j)+1,c(j)-1)))^2;
    %pt4=(pt4);
    if(pt9>ptmax)
        ptmax=pt9;qp
        maxj=j;
        maxpt=pt9-(fsum*area-pt9*9)/(area-9);
    end
end
set(handles.intval,'String',num2str(fsum));
handles.bw=bw;
axes(handles.cropaxes2);
imshow(IF,[handles.flmin,handles.flmax]);
text(c(maxj),r(maxj),['    ' num2str(maxpt)],'color','r');
set(handles.intval,'String',num2str(maxpt));
text(c(maxj),r(maxj),'X','color','r');

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
set(handles.intval,'String',num2str(fsum));
guidata(hObject,handles);
%}



% --- Executes on button press in mancut.
function mancut_Callback(hObject, eventdata, handles)
% hObject    handle to mancut (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
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
set(handles.intval,'String',num2str(fsum));
handles.bw=bw;
imshow(bw);

maxj=1;
maxpt=0;
ptmax=0;
area
FL=IF;
for j = 1:area
    pt9=double(FL(r(j),c(j)))+double(FL(r(j)-1,c(j)))+double(FL(r(j)+1,c(j)))+double(FL(r(j),c(j)+1))+double(FL(r(j)-1,c(j)+1))+double(FL(r(j)+1,c(j)+1))+double(FL(r(j),c(j)-1))+double(FL(r(j)-1,c(j)-1))+double(FL(r(j)+1,c(j)-1));
    pt9=pt9/9;
    %if(pt9>ptmax)
    %    ptmax=pt9;
    %end
    %pt9=(double(FL(r(j),c(j)))-S1(count))^2+(double(FL(r(j)-1,c(j)))-S1(count))^2+(double(FL(r(j)+1,c(j)))-S1(count))^2+(double(FL(r(j),c(j)+1))-S1(count))^2+(double(FL(r(j)-1,c(j)+1))-S1(count))^2+(double(FL(r(j)+1,c(j)+1))-S1(count))^2+(double(FL(r(j),c(j)-1))-S1(count))^2+(double(FL(r(j)-1,c(j)-1))-S1(count))^2+(double(FL(r(j)+1,c(j)-1))-S1(count))^2;
    %pt9=sqrt(pt9)/9;
    %pt4=(double(FL(r(j),c(j)))-double(FL(r(j)+1,c(j))))^2+(double(FL(r(j),c(j)))-double(FL(r(j)-1,c(j))))^2+(double(FL(r(j),c(j)))-double(FL(r(j),c(j)+1)))^2+(double(FL(r(j),c(j)))-double(FL(r(j)+1,c(j)-1)))^2;
    %pt4=(pt4);
    if(pt9>ptmax)
        ptmax=pt9;
        maxj=j;
        maxpt=pt9-fsum;
    end
end
axes(handles.cropaxes2);
imshow(IF,[handles.flmin,handles.flmax]);
text(c(maxj),r(maxj),['    ' num2str(maxpt)],'color','r');
text(c(maxj),r(maxj),'X','color','r');
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
% eventdata  reserved - to be defined in a future version of MATLAB
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
axes(handles.flaxes2);
handles.flim2=imshow(handles.fl2(handles.flframe2).data,[handles.flmin2,handles.flmax2]);
set(handles.flim2, 'HitTest', 'off');
set(handles.frval3,'String',num2str(handles.flframe2));



guidata(hObject,handles);

% --- Executes on button press in pushbutton11.
function pushbutton11_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
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
axes(handles.flaxes2);
handles.flim2=imshow(handles.fl2(handles.flframe2).data,[handles.flmin2,handles.flmax2]);
set(handles.flim2, 'HitTest', 'off');
set(handles.frval3,'String',num2str(handles.flframe2));


guidata(hObject,handles);


% --- Executes on button press in pushbutton12.
function pushbutton12_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%cframe=handles.flframe;
cframe=handles.phframe;
if(cframe~=size(handles.fl,2))
    handles.flframe=cframe+1;
end
axes(handles.flaxes);
handles.flim=imshow(handles.fl(handles.flframe).data,[handles.flmin,handles.flmax]);
set(handles.flim, 'HitTest', 'off');
set(handles.frval1,'String',num2str(handles.flframe));
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



cframe=handles.phframe;
if(cframe~=size(handles.ph,2))
    handles.phframe=cframe+1;
end


axes(handles.phaxes);
handles.phim=imshow(handles.ph(handles.phframe).data,[handles.phmin,handles.phmax]);
set(handles.phim, 'HitTest', 'off');
set(handles.frval2,'String',num2str(handles.phframe));

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
area
for j = 1:area
    pt9=double(FL(r(j),c(j)))+double(FL(r(j)-1,c(j)))+double(FL(r(j)+1,c(j)))+double(FL(r(j),c(j)+1))+double(FL(r(j)-1,c(j)+1))+double(FL(r(j)+1,c(j)+1))+double(FL(r(j),c(j)-1))+double(FL(r(j)-1,c(j)-1))+double(FL(r(j)+1,c(j)-1));
    pt9=pt9/9;
    %if(pt9>ptmax)
    %    ptmax=pt9;
    %end
    %pt9=(double(FL(r(j),c(j)))-S1(count))^2+(double(FL(r(j)-1,c(j)))-S1(count))^2+(double(FL(r(j)+1,c(j)))-S1(count))^2+(double(FL(r(j),c(j)+1))-S1(count))^2+(double(FL(r(j)-1,c(j)+1))-S1(count))^2+(double(FL(r(j)+1,c(j)+1))-S1(count))^2+(double(FL(r(j),c(j)-1))-S1(count))^2+(double(FL(r(j)-1,c(j)-1))-S1(count))^2+(double(FL(r(j)+1,c(j)-1))-S1(count))^2;
    %pt9=sqrt(pt9)/9;
    %pt4=(double(FL(r(j),c(j)))-double(FL(r(j)+1,c(j))))^2+(double(FL(r(j),c(j)))-double(FL(r(j)-1,c(j))))^2+(double(FL(r(j),c(j)))-double(FL(r(j),c(j)+1)))^2+(double(FL(r(j),c(j)))-double(FL(r(j)+1,c(j)-1)))^2;
    %pt4=(pt4);
    if(pt9>ptmax)
        ptmax=pt9;
        maxj=j;
        maxpt=pt9-fsum;
    end
end
set(handles.intval,'String',num2str(fsum));
handles.bw=bw;
axes(handles.cropaxes2);
imshow(IF,[handles.flmin,handles.flmax]);
text(c(maxj),r(maxj),['    ' num2str(maxpt)],'color','r');
text(c(maxj),r(maxj),'X','color','r');
guidata(hObject,handles);

% --- Executes on button press in pushbutton13.
function pushbutton13_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
cframe=handles.phframe;
if(cframe~=1)
    handles.flframe=cframe-1;
end
axes(handles.flaxes);
handles.flim=imshow(handles.fl(handles.flframe).data,[handles.flmin,handles.flmax]);
set(handles.flim, 'HitTest', 'off');
set(handles.frval1,'String',num2str(handles.flframe));
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

cframe=handles.phframe;
if(cframe~=1)
    handles.phframe=cframe-1;
end
axes(handles.phaxes);
handles.phim=imshow(handles.ph(handles.phframe).data,[handles.phmin,handles.phmax]);
set(handles.phim, 'HitTest', 'off');
set(handles.frval2,'String',num2str(handles.phframe));



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
area
for j = 1:area
    pt9=double(FL(r(j),c(j)))+double(FL(r(j)-1,c(j)))+double(FL(r(j)+1,c(j)))+double(FL(r(j),c(j)+1))+double(FL(r(j)-1,c(j)+1))+double(FL(r(j)+1,c(j)+1))+double(FL(r(j),c(j)-1))+double(FL(r(j)-1,c(j)-1))+double(FL(r(j)+1,c(j)-1));
    pt9=pt9/9;
    %if(pt9>ptmax)
    %    ptmax=pt9;
    %end
    %pt9=(double(FL(r(j),c(j)))-S1(count))^2+(double(FL(r(j)-1,c(j)))-S1(count))^2+(double(FL(r(j)+1,c(j)))-S1(count))^2+(double(FL(r(j),c(j)+1))-S1(count))^2+(double(FL(r(j)-1,c(j)+1))-S1(count))^2+(double(FL(r(j)+1,c(j)+1))-S1(count))^2+(double(FL(r(j),c(j)-1))-S1(count))^2+(double(FL(r(j)-1,c(j)-1))-S1(count))^2+(double(FL(r(j)+1,c(j)-1))-S1(count))^2;
    %pt9=sqrt(pt9)/9;
    %pt4=(double(FL(r(j),c(j)))-double(FL(r(j)+1,c(j))))^2+(double(FL(r(j),c(j)))-double(FL(r(j)-1,c(j))))^2+(double(FL(r(j),c(j)))-double(FL(r(j),c(j)+1)))^2+(double(FL(r(j),c(j)))-double(FL(r(j)+1,c(j)-1)))^2;
    %pt4=(pt4);
    if(pt9>ptmax)
        ptmax=pt9;
        maxj=j;
        maxpt=pt9-fsum;
    end
end
set(handles.intval,'String',num2str(fsum));
handles.bw=bw;
axes(handles.cropaxes2);
imshow(IF,[handles.flmin,handles.flmax]);
text(c(maxj),r(maxj),['    ' num2str(maxpt)],'color','r');
text(c(maxj),r(maxj),'X','color','r');
guidata(hObject,handles);





% --- Executes on button press in pushbutton14.
function pushbutton14_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
cframe=handles.flframe2;
if(cframe~=1)
    handles.flframe2=cframe-1;
end
axes(handles.flaxes2);
handles.flim2=imshow(handles.fl2(handles.flframe2).data,[handles.flmin2,handles.flmax2]);
set(handles.flim2, 'HitTest', 'off');
set(handles.frval3,'String',num2str(handles.flframe2));
guidata(hObject,handles);

% --- Executes on button press in pushbutton15.
function pushbutton15_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
cframe=handles.flframe2;
if(cframe~=size(handles.fl2,2))
    handles.flframe2=cframe+1;
end
axes(handles.flaxes2);
handles.flim2=imshow(handles.fl2(handles.flframe2).data,[handles.flmin2,handles.flmax2]);
set(handles.flim2, 'HitTest', 'off');
set(handles.frval3,'String',num2str(handles.flframe2));
guidata(hObject,handles);


function edit5_Callback(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit5 as text
%        str2double(get(hObject,'String')) returns contents of edit5 as a double
user_num = str2num(get(hObject,'String'));
if isnan(user_num)
    errordlg('You must enter a numeric value','Bad Input','modal')
    return
end
if (user_num>=handles.flmax2)
    errordlg('You must enter a value less than the max','Bad Input','modal')
    return
end
handles.flmin2=user_num;
axes(handles.flaxes2);
handles.flim2=imshow(handles.fl2(handles.flframe2).data,[handles.flmin2,handles.flmax2]);
set(handles.flim2, 'HitTest', 'off');
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function edit5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit6_Callback(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit6 as text
%        str2double(get(hObject,'String')) returns contents of edit6 as a double
user_num = str2num(get(hObject,'String'));
if isnan(user_num)
    errordlg('You must enter a numeric value','Bad Input','modal')
    return
end
if (user_num<=handles.flmin2)
    errordlg('You must enter a value greater than the min','Bad Input','modal')
    return
end
handles.flmax2=user_num;
axes(handles.flaxes2);
handles.flim2=imshow(handles.fl2(handles.flframe2).data,[handles.flmin2,handles.flmax2]);
set(handles.flim2, 'HitTest', 'off');
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function edit6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton16.
function pushbutton16_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton16 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
cframe=handles.flframe2-10;
if(cframe>=1)
    handles.flframe2=cframe;
else
    handles.flframe2=1;
end
axes(handles.flaxes2);
handles.flim2=imshow(handles.fl2(handles.flframe2).data,[handles.flmin2,handles.flmax2]);
set(handles.flim2, 'HitTest', 'off');
set(handles.frval3,'String',num2str(handles.flframe2));
guidata(hObject,handles);

% --- Executes on button press in pushbutton17.
function pushbutton17_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton17 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
cframe=handles.flframe2+10;
if(cframe<=size(handles.fl2,2))
    handles.flframe2=cframe;
else
    handles.flframe2=size(handles.fl2,2);
end
axes(handles.flaxes2);
handles.flim2=imshow(handles.fl2(handles.flframe2).data,[handles.flmin2,handles.flmax2]);
set(handles.flim2, 'HitTest', 'off');
set(handles.frval3,'String',num2str(handles.flframe2));
guidata(hObject,handles);



% --- Executes on button press in pushbutton18.
function pushbutton18_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton18 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
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



% --- Executes on button press in pushbutton19.
function pushbutton19_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton19 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
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





% --- Executes on mouse press over figure background, over a disabled or
% --- inactive control, or over an axes background.
function figure1_WindowButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)




% --- Executes during object creation, after setting all properties.
function axes6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axes6





function edit7_Callback(hObject, eventdata, handles)
% hObject    handle to edit7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit7 as text
%        str2double(get(hObject,'String')) returns contents of edit7 as a double
user_text = get(hObject,'String');
handles.savefile=user_text;
guidata(hObject,handles);


% --- Executes during object creation, after setting all properties.
function edit7_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end






% --- Executes on button press in pushbutton22.
function pushbutton22_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton22 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
bw=handles.bws(:,:,handles.phframe);
bw=zeros(size(bw));
handles.bws(:,:,handles.phframe)=bw;
guidata(hObject,handles);



% --- Executes on button press in pushbutton23.
function pushbutton23_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton23 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton24.
function pushbutton24_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton24 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function edit8_Callback(hObject, eventdata, handles)
% hObject    handle to edit8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit8 as text
%        str2double(get(hObject,'String')) returns contents of edit8 as a double
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
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit9_Callback(hObject, eventdata, handles)
% hObject    handle to edit9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit9 as text
%        str2double(get(hObject,'String')) returns contents of edit9 as a double
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
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton25.
function pushbutton25_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton25 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton26.
function pushbutton26_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton26 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

