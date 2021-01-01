#코드 첨부
%평균 변수명을 mot, 25, 35, 45를 붙여서 변경
%% CAD에 따른 압력 그래프
figure(1)
plot(CA_mean_mot,P_cyl_mean_mot,'-')
hold on
plot(CA_mean_25,P_cyl_mean_25,'--')
hold on
plot(CA_mean_35,P_cyl_mean_35,':')
hold on
plot(CA_mean_45,P_cyl_mean_45,'-.')
legend('motoring','25 °','35 °', '45 °')
xlabel('CAD (°)')
ylabel('Pressure (Bar)')
title('Pressure inside Cylinder')
hold off
%(1)번
%% MAP at IVC 및 흡배기온도
figure(2)
x=[25, 35, 45];
y=[MAP_ivc_mean_25, MAP_ivc_mean_35, MAP_ivc_mean_45];
bar(x,y,0.5)
xlabel('bTDC (°)')
ylabel('Pressure (bar)')
title('MAP ivc at each angle')
hold off
figure(3)
x=[25, 35, 45];
y=[T_in_mean_25, T_in_mean_35, T_in_mean_45];
bar(x,y,0.5)
xlabel('bTDC (°)')
ylabel('Temperature (°C)')
title('Mean Intake temperature')
hold off
figure (4)
x=[25, 35, 45];
y=[T_ex_mean_25, T_ex_mean_35, T_ex_mean_45];
bar(x,y,0.5)
xlabel('bTDC (°)')
ylabel('Temperature [°C]')
title('Mean Exhaust temperature')
hold off
%% GMEP, NMEP, PMEP, 토크, power
%Gross work - net work = pumping work의 관계 이용
%조건 설정
r_c=8.5;
S=0.058;
l=0.101;
a=S/2;
R=l/a;
V_c=36;
angle=pi/180*CA_mean;
%크랭크각도->부피 변환 식
V=36*(1+1/2*(r_c-1)*(R+1-cos(angle)-sqrt(R.^2-sin(angle).^2)));
%25도 점화
net_25= trapz(V,P_cyl_mean_25)*0.1;
V_25=zeros(1,401);
P_25=zeros(1,401);
for i=204: 604 % 204번째~604번째가 연소에 의한 압축-팽창과정 (각각이 극대임)
V_25(i-203)=V(i);
P_25(i-203)=P_cyl_mean_25(i);
end
gross_25=trapz(V_25,P_25)*0.1;
pump_25=net_25-gross_25;
GMEP_25=(gross_25/270)*10;
NMEP_25=(net_25/270)*10;
PMEP_25=(pump_25/270)*10;
torque_25=net_25*pi/4;
power_25=net_25*RPM_mean_25/120*0.001;
%35도 점화
net_35= trapz(V,P_cyl_mean_35)*0.1;
V_35=zeros(1,401);
P_35=zeros(1,401);
for i=204: 604
V_35(i-203)=V(i);
P_35(i-203)=P_cyl_mean_35(i);
end
gross_35=trapz(V_35,P_35)*0.1;
pump_35=net_35-gross_35;
GMEP_35=(gross_35/270)*10;
NMEP_35=(net_35/270)*10;
PMEP_35=(pump_35/270)*10;
torque_35=net_35/4/pi; %[Nm]
power_35=net_35*RPM_mean_35/120*0.001;
%45도 점화
net_45= trapz(V,P_cyl_mean_45)*0.1;
V_45=zeros(1,401);
P_45=zeros(1,401);
for i=204: 604
V_45(i-203)=V(i);
P_45(i-203)=P_cyl_mean_45(i);
end
gross_45=trapz(V_45,P_45)*0.1; % [J]
pump_45=net_45-gross_45;
GMEP_45=(gross_45/270)*10;
NMEP_45=(net_45/270)*10;
PMEP_45=(pump_45/270)*10;
torque_45=net_45/4/pi; %[Nm]
power_45=net_45*RPM_mean_45/120*0.001; %[kW]
figure(5)
name={'GMEP';'NMEP';'PMEP'};
x=[1:3];
y=[GMEP_25,GMEP_35,GMEP_45;NMEP_25,NMEP_35,NMEP_45;PMEP_25,PMEP_35,PMEP_45];
bar(x,y)
set(gca,'xticklabel',name,'fontsize',18)
ylabel('Pressure (bar)')
title('GMEP, NMEP, PMEP')
legend('25°','35°','45°')
%% 토크, 출력, 열효율
Ang_Val_25=RPM_mean_25/120;
Ang_Val_35=RPM_mean_35/120;
Ang_Val_45=RPM_mean_45/120;
Net_Work_25=NMEP_25*10^5*270*10^-6;
Net_Work_35=NMEP_35*10^5*270*10^-6;
Net_Work_45=NMEP_45*10^5*270*10^-6;
Torque_25=Net_Work_25/(4*pi);
Torque_35=Net_Work_35/(4*pi);
Torque_45=Net_Work_45/(4*pi);
Power_25=Ang_Val_25*Net_Work_25;
Power_35=Ang_Val_35*Net_Work_35;
Power_45=Ang_Val_45*Net_Work_45;
m_fuel_25=(MAP_ivc_mean_25*27*8.5/7.5/(273.70)/(T_in_mean_25+273.15))/16.1;
m_fuel_35=(MAP_ivc_mean_35*27*8.5/7.5/(273.70)/(T_in_mean_35+273.15))/16.1;
m_fuel_45=(MAP_ivc_mean_45*27*8.5/7.5/(273.70)/(T_in_mean_45+273.15))/16.1;
ef_25=Net_Work_25/m_fuel_25/(44.7*10.6);
ef_35=Net_Work_35/m_fuel_35/(44.7*10.6);
ef_45=Net_Work_45/m_fuel_45/(44.7*10.6);
figure(6)
x=[25, 35, 45];
y=[Torque_25,Torque_35,Torque_45];
bar(x,y,0.5)
xlabel('bTDC (°)')
ylabel('Torque [Nm]')
title('Torque')
set(gca,'fontsize',18)
figure(7)
x=[25, 35, 45];
y=[power_25,power_35,power_45];
bar(x,y,0.5)
xlabel('bTDC (°)')
ylabel('Power (kW)')
title('Power')
set(gca,'fontsize',18)
figure(8)
x=[25, 35, 45];
y=[ef_25,ef_35,ef_45];
bar(x,y,0.5)
xlabel('bTDC (°)')
ylabel('Thermal Efficiency (%)')
title('Thermal Efficiency')
set(gca,'fontsize',18)
%% 열손실 및 저위발열량
%25deg
x=[0 10 20 30 40 50 60 400 450 500 550 600 650 700];
v=[-148.34 -137.93 -127.48 -116.99 -106.45 -95.86 -85.24 -2486.4 -2427.1 -2366.9 -2305.9 -2244 -
2181.4 -2118];
h_in_25=interp1(x,v,T_in_mean_25);
h_out_25=interp1(x,v,T_ex_mean_25);
Q_given_25=(h_in_25-h_out_25)*1000*m_fuel_25*16.1;
Q_loss_25=Q_given_25-Net_Work_25; %열에너지 손실
LHV_25=m_fuel_25*44.7*10^6;
%35deg
h_in_35=interp1(x,v,T_in_mean_35);
h_out_35=interp1(x,v,T_ex_mean_35);
Q_given_35=(h_in_35-h_out_35)*1000*m_fuel_35*16.1;
Q_loss_35=Q_given_35-Net_Work_35;
LHV_35=m_fuel_35*44.7*10^6;
%45deg
h_in_45=interp1(x,v,T_in_mean_45);
h_out_45=interp1(x,v,T_ex_mean_45);
Q_given_45=(h_in_45-h_out_45)*1000*m_fuel_45*16.1;
Q_loss_45=Q_given_45-Net_Work_45;
LHV_45=m_fuel_45*44.7*10^6;
figure(9)
name={'LHV';'Q_g_i_v_e_n';'Q_l_o_s_s'};
x=[1:3];
y=[LHV_25 LHV_35 LHV_45;Q_given_25 Q_given_35 Q_given_45; Q_loss_25 Q_loss_35 Q_loss_45 ];
bar(x,y)
set(gca,'xticklabel',name,'fontsize',18)
ylabel('Heat loss (J/cycle)')
title('Heat loss vs. Spark Time')
legend('25°','35°','45°')
%% Otto cycle
R=287;
k=1.35;
ottoV1=V(204);
ottoV2=V(406);
m_25=MAP_ivc_mean_25*30.6/R/(T_in_mean_25+273.15);
% 25 degree
% 1
ottoP1_25=MAP_ivc_mean_25;
%1->2:
ottoV_25=linspace(ottoV1,ottoV2,1000);
ottoP_25=zeros(1,1000);
for i=1:1000
ottoP_25(i)=(ottoP1_25*ottoV1^k)*(ottoV_25(i))^(-k);
end
% 2->3
ottoT2_25=0.1*ottoP_25(1000)*ottoV2/(m_25*R);
ottoT3_25=ottoT2_25+LHV_25/(m_25*821);
ottoP3_25=0.1*m_25*R*ottoT3_25/ottoV2;
a=linspace(ottoP_25(1000),ottoP3_25,1000);
for i=1001:2000
ottoV_25(i)=ottoV2;
ottoP_25(i)=a(i-1000);
end
% 3->4
a=linspace(ottoV2,ottoV1,1000);
for i=2001:3000
ottoV_25(i)=a(i-2000);
ottoP_25(i)=(ottoP_25(2000)*ottoV2^k)*(ottoV_25(i))^-k;
end
figure(10);
plot(V,P_cyl_mean_25*0.1,'r'); %cm^3, MPa
hold on;
plot(ottoV_25,ottoP_25,'b');
xlabel("Volume (cm^3)");
ylabel("Pressure (bar)");
title("Otto & Real cycle Comparison (25°)");
hold off;
% 35 degree
m_35=MAP_ivc_mean_35*30.3/R/(T_in_mean_35+273.15);
% 1
ottoP1_35=MAP_ivc_mean_35;
% 1->2
ottoV_35=linspace(ottoV1,ottoV2,1000);
ottoP_35=zeros(1,1000);
for i=1:1000
ottoP_35(i)=(ottoP1_35*ottoV1^k)*(ottoV_35(i))^(-k);
end
% 2->3
ottoT2_35=0.1*ottoP_35(1000)*ottoV2/(m_35*R);
ottoT3_35=ottoT2_35+LHV_35/(m_35*821);
ottoP3_35=0.1*m_35*R*ottoT3_35/ottoV2;
a=linspace(ottoP_35(1000),ottoP3_35,1000);
for i=1001:2000
ottoV_35(i)=ottoV2;
ottoP_35(i)=a(i-1000);
end
% 3->4
a=linspace(ottoV2,ottoV1,1000);
for i=2001:3000
ottoV_35(i)=a(i-2000);
ottoP_35(i)=(ottoP_35(2000)*ottoV2^k)*(ottoV_35(i))^-k;
end
figure(11);
plot(V,P_cyl_mean_35*0.1,'r'); %cm^3, bar
hold on;
plot(ottoV_35,ottoP_35,'b');
xlabel("Volume [cm^3]");
ylabel("Pressure [bar]");
title("Otto & Real cycle Comparison (35°)");
% 45 degree
m_45=MAP_ivc_mean_45*30.6/R/(T_in_mean_45+273.15);
% 1
ottoP1_45=MAP_ivc_mean_45;
% 1->2
ottoV_45=linspace(ottoV1,ottoV2,1000);
ottoP_45=zeros(1,1000);
for i=1:1000
ottoP_45(i)=(ottoP1_45*ottoV1^k)*(ottoV_45(i))^(-k);
end
% 2->3
ottoT2_45=0.1*ottoP_45(1000)*ottoV2/(m_45*R);
ottoT3_45=ottoT2_45+LHV_45/(m_45*821);
ottoP3_45=0.1*m_45*R*ottoT3_45/ottoV2;
a=linspace(ottoP_45(1000),ottoP3_45,1000);
for i=1001:2000
ottoV_45(i)=ottoV2;
ottoP_45(i)=a(i-1000);
end
% 3->4
a=linspace(ottoV2,ottoV1,1000);
for i=2001:3000
ottoV_45(i)=a(i-2000);
ottoP_45(i)=(ottoP_45(2000)*ottoV2^k)*(ottoV_45(i))^-k;
end
figure(12);
plot(V,P_cyl_mean_45*0.1,'r'); %cm^3, bar
hold on;
plot(ottoV_45,ottoP_45,'b');
xlabel("Volume [cm^3]");
ylabel("Pressure [bar]");
title("Otto & Real cycle Comparison (45°)");
%% Gross Work 비교
oGross_25=polyarea(ottoV_25,ottoP_25);
oGross_35=polyarea(ottoV_35,ottoP_35);
oGross_45=polyarea(ottoV_45,ottoP_45);
RWork_25=GMEP_25*27;
RWork_35=GMEP_35*27;
RWork_45=GMEP_45*27;
figure(13);
name={'25°';'35°';'45°'};
x=[1:3];
y=[oGross_25, RWork_25;oGross_35, RWork_35;oGross_45, RWork_45 ];
bar(x,y)
ylabel('Heat loss (J/cycle)')
title('Gross Work of Otto Cycle and Real Cycle')
legend('Otto Cycle','Real Cycle')
xlabel("bTDC(°)");
ylabel("Gross work(J/Cycle)");
title("Gross work comparison between otto & real cycle");
legend("Otto cycle","Real cycle",direction,"northwest");
