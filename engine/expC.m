%b보고서 작성 코드를 그대로 쓰기 위해 25=> low load 35=> mid load 45=> high
%load로 한다.
%% CAD에 따른 압력 그래프
plot(CA_mean_25,P_cyl_mean_25,'--')
hold on
plot(CA_mean_35,P_cyl_mean_35,':')
hold on
plot(CA_mean_45,P_cyl_mean_45,'-.')
legend('Low-Load','Mid-Load', 'High Load')
xlabel('CAD (°)')
ylabel('Pressure (Bar)')
title('CAD v. Pressure')
hold off
%% 흡배기온도 및 최대압력
MAP=[MAP_ivc_mean_25,MAP_ivc_mean_35,MAP_ivc_mean_45];
TEX=[T_ex_mean_25,T_ex_mean_35,T_ex_mean_45];
TIN=[T_in_mean_25,T_in_mean_35,T_in_mean_45];
plot(MAP,TIN);
xlabel("MAP(bar)");
ylabel("Temperature(℃)");
title("Intake Temperature");
plot(MAP,TEX);
xlabel("MAP(bar)");
ylabel("Temperature(℃)");
title("Exhaust Temperature");
plot(MAP,TEX);
xlabel("MAP(bar)");
ylabel("Temperature(℃)");
title("Exhaust Temperature");
PMAX(1)=0;
for i=1:800
 while(PMAX(1)<P_cyl_mean_25(i)) PMAX(1)=P_cyl_mean_25(i);
 end
end
PMAX(2)=0;
for i=1:800
 while(PMAX(2)<P_cyl_mean_35(i)) PMAX(2)=P_cyl_mean_35(i);
 end
end
PMAX(3)=0;
for i=1:800
 while(PMAX(3)<P_cyl_mean_45(i)) PMAX(3)=P_cyl_mean_45(i);
 end
end
plot(MAP,PMAX);
xlabel("MAP (bar)");
ylabel("Maximum Pressure (bar)");
title("Maximum Pressure");
%%GMEP, NMEP, PMEP
r_c=8.5;
S=58*0.001;
l=101*0.001;
a=S/2;
R=l/a;
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
GMEP=[GMEP_25, GMEP_35, GMEP_45];
NMEP=[NMEP_25, NMEP_35, NMEP_45];
PMEP=[PMEP_25, PMEP_35, PMEP_45];
plot(MAP,GMEP);
xlabel("MAP(bar)");
ylabel("GMEP(bar)");
title("GMEP");
plot(MAP,PMEP);
xlabel("MAP(bar)");
ylabel("PMEP(bar)");
title("PMEP");
plot(MAP,NMEP);
xlabel("MAP(bar)");
ylabel("NMEP(bar)");
title("NMEP");
%% 출력, 열효율
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
Power=[Power_25, Power_35, Power_45];
ef=[ef_25, ef_35, ef_45];
plot(MAP,Power);
xlabel("MAP(bar)");
ylabel("Power(W)");
title("Power");
plot(MAP,ef);
xlabel("MAP(bar)");
ylabel("Efficiency");
title("Efficiency");
%% 열손실 및 저위발열량
%25deg
x=[0 10 20 30 40 50 60 400 450 500 550 600 650 700];
v=[-148.34 -137.93 -127.48 -116.99 -106.45 -95.86 -85.24 -2486.4 -2427.1 -2366.9 -2305.9
-2244 -2181.4 -2118];
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
Q_loss=[Q_loss_25, Q_loss_35, Q_loss_45];
LHV=[LHV_25,LHV_35,LHV_45];
plot(MAP,Q_loss);
hold on;
plot(MAP,LHV)
xlabel("MAP(bar)");
ylabel("Heat loss(J)");
title("Heat loss");
