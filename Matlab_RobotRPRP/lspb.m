function [Q,V,A]=LSPB(A_max,V_max,X_start,X_end,T,T_end);


% [Q,V,A]=LSPB(A_max,V_max,X_start,X_end,T,T_end)
% Genera un riferimento LSPB
%
% Q=posizione; V=velocita'; A=accelerazione
% A_max=Accelerazione massima
% V_max=Velocita' massima
% X_start=Posizione iniziale
% X_end=Posizione finale
% T=Delta-time
% T_end=Tempo finale

s=sign(X_end-X_start);

V_max=s*abs(V_max);
A_max=s*abs(A_max);

if (V_max*V_max)>=A_max*(X_end-X_start)
  disp('Traiettoria impossibile')
  break;
end

tb=V_max/A_max;

tf=(X_end-X_start)/V_max+tb;

T1=0:T:tb;
q1=X_start*ones(size(T1))+0.5*A_max*T1.*T1;
v1=A_max*T1;
a1=A_max*ones(size(T1));

n1=max(size(T1));

T2=(T1(n1)+T):T:(tf-tb);
q2=0.5*(X_end+X_start-V_max*tf)*ones(size(T2))+V_max*T2;
v2=V_max*ones(size(T2));
a2=zeros(size(T2));

n2=max(size(T2));

T3=(T2(n2)+T):T:tf;
q3=(X_end-0.5*A_max*tf*tf)*ones(size(T3))+A_max*tf*T3-0.5*A_max*T3.*T3;
v3=ones(size(T3))*V_max-A_max*(T3-ones(size(T3))*T2(n2));
a3=-A_max*ones(size(T3));

n3=max(size(T3));

T4=(T3(n3)+T):T:T_end;
q4=X_end*ones(size(T4));
v4=zeros(size(T4));
a4=zeros(size(T4));

Q=[q1 q2 q3 q4]';
V=[v1 v2 v3 v4]';
A=[a1 a2 a3 a4]';
