%%%%%%%%%%%%%%%%%%%%%% Velocity Measurement Experiment %%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%% Seoul National University %%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%% Department of Mechanical & Aerospace Engineering.%%%%%%%%%%%%%%%
%                               - Developer -                             %
%                                                                         %
% 2016.9.1. Two teaching Asistants - develop the original code            %
% 2016.11.12 Jaeuk Sim - contour level 조절, FFT, cylinder 그리는부분      %
% 2016.12.09 Heejoo Yang - strealine 그리기 개선                           %
% 2016.12.09 Yeongseop Jeong - 와도 단위 변환 (1/ms -> 1/s)                %
% 2016.12.13 Sohee Yoon - 파일입력자동화, streamslice, 실린더윤곽 코드업데이트%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Version edited for Fall '20 course
% 2020 2nd sem. exp. C
close all; clear all; clc;

%% Number of column and row of velocity vectors from PIV Image
% 0 deg case : column - 39, row - 29
% 45 deg case : column - 39, row - 29

num_of_col= 39;                                 % length of column
num_of_row= 29;                                 % length of row

%% VARIABLE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% 파일 입력 자동화 18~27 lines (Developed by S.Yoon 2016 11 12)
open_path = 'C:\Users\hyeon\Google 드라이브\20-2\기공실\속도실험\C\속도실험C PIV\45deg\';   % directory of folder at which the data exist
files_dat = dir([open_path,'*deg_*.txt']);                % obtain file data in format of '*deg_*.txt'
files_dat = files_dat(3:end);


num_of_data=size(files_dat,1);                  % number of data ( # of instantaneous velocity fields )

D= 0.005;                                            % characteristic length ( unit : [m] )
U_0= 0.074796;                                          % characteristic velocity ( unit : [m/s] )
                                                % varies depending on the Reynolds number. ( Re=U*D/v )
                                                % these parameters will be used in Exp B,C. ( when Exp A., D=U_0=1 )

mode=2;                                         % plot the averaged flow field
                                                % contourraged mode selection
                                                % [1:vorticity, 2:horizontal velocity, 3:vertical velocity]
min=-0.1;                                       % range of contour
max=0.1;
level=50;                                       % number of countour level

% variables related to FFT code (Developed by J.Sim 2016 11 12)
m=16;                                           % select x position of interrogation window for FFT
n=17;                                           % select y position of interrogation window for FFT

fps=500;                                       % camera fps
imagepairs=1;                                   % frame interval between velocity vector

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Averaging the flow fields

% obtain file data
for i=1:num_of_data
    a = fopen([open_path, files_dat(i).name], 'r');         % generate the stream between the target data and the CPU. 
    data = textscan(a, '%f %f %f %f %f', 'headerlines', 1); % remomve the headerline and scan the data 
    X(:,i)=data{1};     % x position                        % stack in 2-dimensional matrix
    Y(:,i)=data{2};     % y position
    U(:,i)=data{3};     % horizontal velocity
    V(:,i)=data{4};     % vertical velocity
    w(:,i)=data{5};     % vorticity (NOT velocity!)
    fclose(a);                                              % close the stream
    
end


% average
U_mean=mean(U,2);                                           % simply average velocity data using 'mean' function. ('2' means 'averaging in horizontal direction'
V_mean=mean(V,2);
w_mean=mean(w,2);

% normalize
X_n=X(:,1)/(D);
Y_n=Y(:,1)/(D);
U_n=U_mean/U_0; 
V_n=V_mean/U_0;
w_n=w_mean*(D)/U_0; % Edited by Y.Jeong 2016.12.10

% total average
U_meantotal=mean(U_mean);
V_meantotal=mean(V_mean);
w_meantotal=mean(w_mean);
display(U_meantotal);
display(V_meantotal);
display(w_meantotal);



%% Plotting the averaged flow field
% (modified by J.Sim 2016.11.12 - draw the cylinder contour)

% convert data format
count=1;
for j=1:num_of_col                              % Line-data -> two-dimensional data
    for i=1:num_of_row
        X_2D(i,j)=X_n(count);
        Y_2D(i,j)=Y_n(count);
        U_2D(i,j)=U_n(count);
        V_2D(i,j)=V_n(count);
        w_2D(i,j)=w_n(count);
        count=count+1;
    end

end

% contour
figure(1)
if mode==1
    [C,h]=contourf(X_2D(1,:),Y_2D(:,1),w_2D,level);hold on;  % vorticity contour
elseif mode==2
    [C,h]=contourf(X_2D(1,:),Y_2D(:,1),U_2D,level);hold on;  % horizontal velocity contour
elseif mode==3
    [C,h]=contourf(X_2D(1,:),Y_2D(:,1),V_2D,level);hold on;  % vertical velocity contour
end                                                          % activate only one of the three

% contour option
set(h,'LineColor','none')                           % removing contour line
caxis([min max]);                                   % setting the range of vortricty/velocity
colorbar;  

% showing color bar

% velocity vector field
quiver(X_n,Y_n,U_n,V_n, 'k');
%% Choose which figure to draw (Developed by S.Yoon 2016 11 12)
shapeType=3;            % choose shape type [1,2,3]=[circle,square,diamond]

if shapeType==1
    % draw circle
    [p,q]=scircle1(0,0,0.5);            % ( x of center , y of center , radius)
    fill(p,q,'w');
    axis equal;
elseif shapeType==2
    % draw square (AOA=0deg)
    rectangle('Position',[1.88 3.42 1 1],'FaceColor','w');
elseif shapeType==3
    % draw square (AOA=45deg)
    scale = 8.3841e-05;
    xx = [138*scale 138*scale-0.005/sqrt(2) 138*scale 138*scale+0.005/sqrt(2)];
    yy = [187*scale 187*scale+0.005/sqrt(2) 187*scale+0.005*2/sqrt(2) 187*scale+0.005/sqrt(2)];
    patch(xx/0.005,yy/0.005,'w');
end

%% Streamline


% streamline
figure('Name', 'Streamline');
[verts, averts] = streamslice( X_2D, Y_2D, U_2D, V_2D, 5);
sl = streamline( [verts averts]);
hold on;

%% Choose which figure to draw (Developed by S.Yoon 2016 11 12)
shapeType=3;            % choose shape type [1,2,3]=[circle,square,diamond]

if shapeType==1
    % draw circle
    [p,q]=scircle1(0,0,0.5);            % ( x of center , y of center , radius)
    fill(p,q,'w');
    axis equal;
elseif shapeType==2
    % draw square (AOA=0deg)
    rectangle('Position',[1.88 3.42 1 1],'FaceColor','w');
elseif shapeType==3
    % draw square (AOA=45deg)
    scale = 8.3841e-05;
    xx = [138*scale 138*scale-0.005/sqrt(2) 138*scale 138*scale+0.005/sqrt(2)];
    yy = [187*scale 187*scale+0.005/sqrt(2) 187*scale+0.005*2/sqrt(2) 187*scale+0.005/sqrt(2)];
    patch(xx/0.005,yy/0.005,'w');
end

%% FFT (Developed by J.Sim 2016.11.12)

z=V(num_of_col*n+m,:);       % extract one interrogation window
Fs=fps/imagepairs;           % fps between velocity vector (=sampling rate)
Ts=1/Fs;                     % time interval between velocity vertor (=sampling period)
N=length(z);                 % number of velocity vector

k=0:N-1;                     % k=0,1,2, - ,N-1
T=N*Ts;                      % last time
freq=k/T;                    % frequncy

Z=fft(z)/N*2;                % FFT, divide by N to normalize, x2 before removing symmetrical part
cutoff=ceil(N/2);            % N/2, round up to the integer
Z=Z(1:cutoff);               % remove symmetrical part
freq=freq(1:cutoff);         % remove symmetrical part
Z=abs(Z);                    % remove imaginary part

figure('Name', 'FFT')
plot(freq,Z);
xlabel('Freq [Hz]');
ylabel('Magnitude');
grid on;

%% Turbulence Intensity


                                                                                          

min=0;
max=0.1;

for i=1:1131
    U_sum(:,i)=0; V_sum(:,i)=0;
    for j=1:997
        U_sum(:,i)=U_sum(:,i)+(U(i,j)-U_mean(i)).^2; 
        V_sum(:,i)=V_sum(:,i)+(V(i,j)-V_mean(i)).^2;
    end
end
U_rms=sqrt(U_sum/999);V_rms=sqrt(V_sum/999);
KE=0.5*((U_rms).^2+(V_rms).^2);
KE_n=KE/(U_0).^2;
 
count=1;
for j=1:num_of_col                              
    for i=1:num_of_row
        KE_2D(i,j)=KE_n(count);
        count=count+1;
    end
end


[C,h]=contourf(X_2D(1,:),Y_2D(:,1),KE_2D,level);hold on; % turbulent kinetic energy contour
                                                        
set(h,'LineColor','none')                           
caxis([min max]); colorbar;                                           
xlabel('x/D');
ylabel('y/D');


 
%% Choose which figure to draw (Developed by S.Yoon 2016 11 12)

shapeType=3;            % choose shape type [1,2,3]=[circle,square,diamond]

if shapeType==1
    % draw circle
    [p,q]=scircle1(0,0,0.5);            % ( x of center , y of center , radius)
    fill(p,q,'w');
    axis equal;
elseif shapeType==2
    % draw square (AOA=0deg)
    rectangle('Position',[1.88 3.42 1 1],'FaceColor','w');
elseif shapeType==3
    % draw square (AOA=45deg)
    scale = 8.3841e-05;
    xx = [138*scale 138*scale-0.005/sqrt(2) 138*scale 138*scale+0.005/sqrt(2)];
    yy = [187*scale 187*scale+0.005/sqrt(2) 187*scale+0.005*2/sqrt(2) 187*scale+0.005/sqrt(2)];
    patch(xx/0.005,yy/0.005,'w');
end


