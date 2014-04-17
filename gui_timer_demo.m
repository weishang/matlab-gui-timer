function varargout = gui_timer_demo(varargin)
% GUI_TIMER_DEMO MATLAB code for gui_timer_demo.fig
%      GUI_TIMER_DEMO, by itself, creates a new GUI_TIMER_DEMO or raises the existing
%      singleton*.
%
%      H = GUI_TIMER_DEMO returns the handle to a new GUI_TIMER_DEMO or the handle to
%      the existing singleton*.
%
%      GUI_TIMER_DEMO('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI_TIMER_DEMO.M with the given input arguments.
%
%      GUI_TIMER_DEMO('Property','Value',...) creates a new GUI_TIMER_DEMO or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before gui_timer_demo_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to gui_timer_demo_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help gui_timer_demo

% Last Modified by GUIDE v2.5 16-Apr-2014 22:23:36

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @gui_timer_demo_OpeningFcn, ...
                   'gui_OutputFcn',  @gui_timer_demo_OutputFcn, ...
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


% --- Executes just before gui_timer_demo is made visible.
function gui_timer_demo_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to gui_timer_demo (see VARARGIN)

% Choose default command line output for gui_timer_demo
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);


% creating the timer object, so that live mode is possible
timer_obj = timer(...
    'StartFcn',         @user_timer_start, ...              % start function
    'TimerFcn',         {@user_timer_update, hObject}, ...  % timer function, has to specific the handle to the GUI,
    'StopFcn',          @user_timer_stop, ...               % stop function
    'ErrorFcn',         @user_timer_err, ...                % error function
    'ExecutionMode',    'fixedRate', ...                    %
    'Period',           0.1, ...                            % updates every xx seconds
    'TasksToExecute',   inf, ...
    'BusyMode',         'drop');

% save the timer object as application data
setappdata(hObject, 'timer_obj', timer_obj);                 % need to save it because we need to stop and delete it when quit

set(handles.pb_resume_pause, 'string', 'Pause');

start(timer_obj);


% --- Outputs from this function are returned to the command line.
function varargout = gui_timer_demo_OutputFcn(hObject, eventdata, handles) 
varargout{1} = handles.output;

% --- Executes when user attempts to close gui_timer_demo.
function gui_timer_demo_CloseRequestFcn(hObject, eventdata, handles)
stop(getappdata(hObject, 'timer_obj'));     % stop the timer 
delete(getappdata(hObject, 'timer_obj'));   % delete the timer 
delete(hObject);                            % delete the gui

% --- Executes on button press in pb_resume_pause.
function pb_resume_pause_Callback(hObject, eventdata, handles)
timer_obj = getappdata(gcf, 'timer_obj');
switch get(timer_obj, 'running' ) 
    case 'off',
        set(handles.pb_resume_pause, 'string', 'Pause');
        start(timer_obj);
    case 'on',
        set(handles.pb_resume_pause, 'string', 'Resume');
        stop(timer_obj);
end        

function user_timer_update(src,evt, fig_handle)
handles = guihandles(fig_handle);
set(handles.lbl_timeNow, 'string', datestr(now, 'yyyy-mm-dd HH:MM:SS'));

function user_timer_start(src, evt)
disp('Timer was started!');

function user_timer_stop(src, evt)
disp('Timer was stopped.');

function user_timer_err(src, evt)
disp('Timer error.');