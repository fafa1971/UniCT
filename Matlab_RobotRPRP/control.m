function tau=control(q_in);

%
% Controllore per il file SISTEMA.M di Simulink
% (Algoritmo di Controllo: PD o Feedback Linearization)
% Ritorna 'tau' - dati 'q' e 'q_des'
%       tau=control(q,q_des);
%

global Controllo Kv Kp

q_des=q_in(1:4);
v_des=q_in(5:8);
a_des=q_in(9:12);

q=q_in(13:16);
v=q_in(17:20);
a=q_in(21:24);

% Calcola le matrici della dinamica

[Matrix]=dynamic(q,v);

D=Matrix(:,1:4);
h=Matrix(:,5);
C=Matrix(:,6);
F=Matrix(:,7);

clear Matrix;

% Legge di controllo

if strcmp(upper(Controllo),'PD')     % Controllore PD
	tau=Kv*(v_des-v)+Kp*(q_des-q);
else                                 % Feedback Linearization
	tau=D*(a_des+Kv*(v_des-v)+Kp*(q_des-q))+h+C;
end

