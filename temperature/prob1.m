L=0.27; %길이 (단위:m)
T_b=42.953; %base temperature
T_inf=21.156; %environment temperature
k=401; %구리의 열전도율 @25도
h=3.7245; %T_tip, T_b를 이용한 대류 열전도계수
m=3.078; 
x1=0:0.001:0.27; 
y1=((cosh(m*(L-x1))+(h/(m*k))*sinh(m*(L-x1)))/(cosh(m*L)+(h/(m*k))*sinh(m*L)))*(T_b-T_inf)+T_inf;



% Real temperature
x2=0.018*[0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15]; % 0.27m가 15등분 되어 있으므로 0.018m가 각 지점 사이의 거리이다.
y2=[42.953	40.596	0/0	38.234	39.332	37.884	36.847	36.368	34.938	35.175	34.836	0/0	34.005	0/0	32.938	33.773]; % real temperature

%그래프 그리기
plot(x1,y1)
hold on
plot(x2,y2,'o') 
title('Temperature v. fin legth')
xlabel('Fin length(m)');
ylabel('T(°C), Temperature');
legend('Analytical','Experiment')
