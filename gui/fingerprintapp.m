function varargout = fingerprintapp(varargin)
% FINGERPRINTAPP MATLAB code for fingerprintapp.fig
%      FINGERPRINTAPP, by itself, creates a new FINGERPRINTAPP or raises the existing
%      singleton*.
%
%      H = FINGERPRINTAPP returns the handle to a new FINGERPRINTAPP or the handle to
%      the existing singleton*.
%
%      FINGERPRINTAPP('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in FINGERPRINTAPP.M with the given input arguments.
%
%      FINGERPRINTAPP('Property','Value',...) creates a new FINGERPRINTAPP or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before fingerprintapp_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to fingerprintapp_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help fingerprintapp

% Last Modified by GUIDE v2.5 29-May-2024 23:01:04

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @fingerprintapp_OpeningFcn, ...
                   'gui_OutputFcn',  @fingerprintapp_OutputFcn, ...
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


% --- Executes just before fingerprintapp is made visible.
function fingerprintapp_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to fingerprintapp (see VARARGIN)

% Choose default command line output for fingerprintapp
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes fingerprintapp wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = fingerprintapp_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in loadfirstfingerprint.
function loadfirstfingerprint_Callback(hObject, eventdata, handles)
    [path, nofile] = imgetfile();
    if nofile
        msgbox(sprintf('Slika nije pronađena!'), 'error', 'warning');
        return
    end
    handles.FirstFingerprintImage = imread(path);
    guidata(hObject, handles);
    axes(handles.imagefirstfingerprint);
    imshow(im2double(handles.FirstFingerprintImage));

% --- Executes on button press in loadsecondfingerprint.
function loadsecondfingerprint_Callback(hObject, eventdata, handles)
    [path, nofile] = imgetfile();
    if nofile
        msgbox(sprintf('Slika nije pronađena!'));
        return
    end
    handles.SecondFingerprintImage = imread(path);
    guidata(hObject, handles);
    axes(handles.imagesecondfingerprint);
    imshow(im2double(handles.SecondFingerprintImage));

% --- Executes on button press in startanalysisbutton.
function startanalysisbutton_Callback(hObject, eventdata, handles)
    if(~isfield(handles, 'FirstFingerprintImage') || ~isfield(handles, 'SecondFingerprintImage'))
        msgbox(sprintf('Niste učitali sliku!'));
        return
    end

    addpath '..\src'

    BlockSize = 16;
    Threshold = 0.5;
    GradSigma = 1;
    BlockSigma = 7;
    OrientSmoothSigma = 7;
    
    % First image processing
    
    msgbox('Započeta analiza prve slike!');
    
    INorm1 = normalization(handles.FirstFingerprintImage);

    [INorm1, Mask1] = segmentation(INorm1, Threshold, BlockSize);

    Orientation1 = orientation(INorm1, GradSigma, BlockSigma, OrientSmoothSigma);
    Frequency1 = frequency(INorm1, BlockSize, Orientation1, Mask1);

    GaborFilt1 = gabor_filter(handles.FirstFingerprintImage, Orientation1, Frequency1);

    [Skeletonized1, Endpoints1, Bifurcations1] = minutiae_extraction(GaborFilt1, Mask1);

    [XEndpoints1, YEndpoints1] = find(Endpoints1);
    [XBifurcations1, YBifurcations1] = find(Bifurcations1);

    % Plotting first analysis
    figure
    subplot(151)
    imshow(handles.FirstFingerprintImage);
    title("Originalni prvi otisak")

    subplot(152)
    imshow(INorm1 .* Mask1);
    title("Normalizovan i segmentiran prvi otisak")

    subplot(153)
    imshow(im2double(GaborFilt1) .* Mask1);
    title("Prvi otisak nakon Gabor filtra")

    subplot(154)
    imshow(Skeletonized1 .* Mask1);
    title("Skeletonizacija prvog otiska")

    subplot(155)
    imshow(Skeletonized1 .* Mask1);
    hold on
    plot(YEndpoints1, XEndpoints1, 'r*'); % Plot endpoints in red
    plot(YBifurcations1, XBifurcations1, 'g*'); % Plot bifurcations in green
    hold off
    title("Kritične tačke otiska")
    
    % Second image processing
    
    msgbox('Započeta analiza druge slike!');

    INorm2 = normalization(handles.SecondFingerprintImage);

    [INorm2, Mask2] = segmentation(INorm2, Threshold, BlockSize);

    Orientation2 = orientation(INorm2, GradSigma, BlockSigma, OrientSmoothSigma);
    Frequency2 = frequency(INorm2, BlockSize, Orientation2, Mask2);

    GaborFilt2 = gabor_filter(handles.SecondFingerprintImage, Orientation2, Frequency2);

    [Skeletonized2, Endpoints2, Bifurcations2] = minutiae_extraction(GaborFilt2, Mask2);

    [XEndpoints2, YEndpoints2] = find(Endpoints2);
    [XBifurcations2, YBifurcations2] = find(Bifurcations2);

    % Plotting second analysis
    figure
    subplot(151)
    imshow(handles.SecondFingerprintImage);
    title("Originalni drugi otisak")

    subplot(152)
    imshow(INorm2 .* Mask2);
    title("Normalizovan i segmentiran drugi otisak")

    subplot(153)
    imshow(im2double(GaborFilt2) .* Mask2);
    title("Drugi otisak nakon Gabor filtra")

    subplot(154)
    imshow(Skeletonized2 .* Mask2);
    title("Skeletonizacija drugog otiska")

    subplot(155)
    imshow(Skeletonized2 .* Mask2);
    hold on
    plot(YEndpoints2, XEndpoints2, 'r*'); % Plot endpoints in red
    plot(YBifurcations2, XBifurcations2, 'g*'); % Plot bifurcations in green
    hold off
    title("Kritične tačke otiska")
    
    XEndpoints1 = transpose(XEndpoints1);
    XEndpoints2 = transpose(XEndpoints2);
    XBifurcations1 = transpose(XBifurcations1);
    XBifurcations2 = transpose(XBifurcations2);

    YEndpoints1 = transpose(YEndpoints1);
    YEndpoints2 = transpose(YEndpoints2);
    YBifurcations1 = transpose(YBifurcations1);
    YBifurcations2 = transpose(YBifurcations2);

    Minutiae1X = [XEndpoints1, XBifurcations1];
    Minutiae2X = [XEndpoints2, XBifurcations2];
    Minutiae1Y = [YEndpoints1, YBifurcations1];
    Minutiae2Y = [YEndpoints2, YBifurcations2];

    % Minutiae matching
    Minutiae1 = [Minutiae1X; Minutiae1Y];
    Minutiae2 = [Minutiae2X; Minutiae2Y];
    Score = minutiae_matching(Minutiae1, Minutiae2, Orientation1, Orientation2);
    ScoreText = findobj('Tag', 'scoreresult');
    msgbox(strcat('Podudarnost dva otiska prsta: ', num2str(round(Score * 100)), '%'));
    set(ScoreText, 'String', strcat(num2str(round(Score * 100)), '%'));


