T_inf=21.156; 
h=3.7245;
k=401; %기본 물성치 설정
dz=0.002; %격자를 0.002m cube로 세팅

T = T_inf * ones(51,143); % 온도 array설정
T_temp = ones(51,143); % 반복문에 사용할 임시 온도 
T(1:51,1)=42.953; % base temperature

error=1;
errormax=1e-7; 
iteration=0;

while(error > errormax) %error가 errormax보다 클 시에 명령을 계속 시행
    T_temp = T; 
    
%공식: refer to the report
% 내부 격자  
for i=2:50
    for j=2:142
        T(i,j)=(T(i,j-1)+T(i,j+1)+T(i+1,j)+T(i-1,j)+(2*h*dz/k)*T_inf)/(4+2*h*dz/k);
    end 
end
for i=2:142
    T(1,i)=(T(1,i+1)+T(1,i-1)+2*T(2,i)+(4*h*dz/k)*T_inf)/(4+4*h*dz/k); % 왼쪽 모서리
    T(51,i)=(T(51,i+1)+T(51,i-1)+2*T(50,i)+(4*h*dz/k)*T_inf)/(4+4*h*dz/k); % 오른쪽 모서리
end
for i=2:50
    T(i,143)=(T(i+1,143)+T(i-1,143)+2*T(i,142)+(4*h*dz/k)*T_inf)/(4+4*h*dz/k); % 위쪽 모서리
end
T(1,143)=(T(2,143)+T(1,142)+(3*h*dz/k)*T_inf)/(2+3*h*dz/k); % 왼쪽 꼭짓점
T(51,143)=(T(50,143)+T(51,142)+(3*h*dz/k)*T_inf)/(2+3*h*dz/k); % 오른쪽 꼭짓점

error=max(max(abs(T-T_temp))); %가장 큰 값으로 오차 세팅
iteration=iteration+1; 
end 

X=0:0.002:0.1;
Y=0:0.002:0.284; %격자 설정

X_2=ones(51,143);
Y_2=ones(51,143);

q=100;
for i=1:51
    for j=1:143
        X_2(i,j)=X(1,i);
        Y_2(i,j)=Y(1,j);
    end
end


%시각화
figure(2)
mesh(Y_2,X_2,T);
hold on;                                                          
title('Temperature Distribution Using FDM')
xlabel('distance to x-direction (m)');
ylabel('distance to y-direction (m)');
zlabel('Temperature(°C))');
legend('Temperature of Fin(°C)','Location','northeast');