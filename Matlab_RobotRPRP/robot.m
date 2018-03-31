function a=robot(inp);

%
% Programma per il file SISTEMA.M di Simulink
% Ritorna 'a' - dati 'tau' 'q' 'v'
%           a=robot(inp);
%

tau(1)=inp(1);
tau(2)=inp(2);
tau(3)=inp(3);
tau(4)=inp(4);

tau=tau';

% Posizioni

q(1)=inp(5);
q(2)=inp(6);
q(3)=inp(7);
q(4)=inp(8);

% Velocita'

v(1)=inp(9);
v(2)=inp(10);
v(3)=inp(11);
v(4)=inp(12);

v=v';

% Calcola le matrici della dinamica

[Matrix]=dynamic(q,v);

D=Matrix(:,1:4);
h=Matrix(:,5);
C=Matrix(:,6);
F=Matrix(:,7);

clear Matrix;

% Equazioni della dinamica (a=vettori-accelerazioni)

a=inv(D)*(tau-h-C-F);
