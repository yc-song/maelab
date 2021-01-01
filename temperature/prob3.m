figure(3);
plot(x1,y1); % analytic data
hold on;
plot(x2,y2, 'o'); % Real data
hold on;
plot(Y_2(1,1:136), T(26,1:136),'--'); % 중앙의 26번째 값 설정, FDM data
hold on;
title('Comparison of Temperature Analysis Method')
xlabel('distance from base (m)')
ylabel('Temperature(°C)')
legend('Analytic','Experiment','FDM')