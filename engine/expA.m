rc=8.5;
S=58*0.001;
l=101*0.001;
a=S/2
R=l/a;
V_c=36*10^(-6); %m^3
%% VolumeÀ¸·Î º¯È¯ ÈÄ P-V ¼±µµ ±×¸®±â

V = zeros([1 800],'gpuArray');
CA_mean = gpuArray(CA_mean);
P_cyl_mean= gpuArray(P_cyl_mean);

for i=1:800
V(i)=(1+1/2*(rc-1)*(R+1-
cos(CA_mean(i)*pi/180)-sqrt(R^2-
(sin(CA_mean(i)*pi/180))^2)))*V_c;
end

figure(1);
plot(V,P_cyl_mean/10);
grid on;
xlabel('V(m^3)');
ylabel('P(MPa)');
title('P-V Diagram');

Net_Work=trapz(V,100000*P_cyl_mean); %J
NMEP=Net_Work/(270*10^(-6)); %Pa
