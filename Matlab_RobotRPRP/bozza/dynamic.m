function [Matrix]=dynamic(q,v);

%
% Programma per il file SISTEMA.M di Simulink
% Ritorna le matrici della Dinamica - dati 'q' e 'v'
%        [Matrix]=dynamic(q,v);
%

global m1 m2 m3 m4 l1 l2 l3 l4 g f1 f2 f3 f4

% Notazione compatta

C1=cos(q(1));
C3=cos(q(3));

S1=sin(q(1));
S3=sin(q(3));

% Matrici cinematiche dirette di trasformazione

A01=[C1 -S1 0 0; S1 C1 0 0; 0 0 1 0; 0 0 0 1];
A12=[1 0 0 0; 0 0 1 0; 0 -1 0 q(2); 0 0 0 1];
A23=[C3 0 S3 0; S3 0 -C3 0; 0 1 0 0; 0 0 0 1];
A34=[1 0 0 0; 0 1 0 0; 0 0 1 q(4); 0 0 0 1];
T04=[C1*C3 -S1 C1*S3 C1*S3*q(4);
     S1*C3 C1 S1*S3 S1*S3*q(4);
     -S3 0 C3 C3*q(4)+q(2)
     0 0 0 1];

% Matrici cinematiche inverse di trasformazione

A10=[C1 S1 0 0; -S1 C1 0 0; 0 0 1 0; 0 0 0 1];
A21=[1 0 0 0; 0 0 -1 q(2); 0 1 0 0; 0 0 0 1];
A32=[C3 S3 0 0; 0 0 1 0; S3 -C3 0 0; 0 0 0 1];
A43=[1 0 0 0; 0 1 0 0; 0 0 1 -q(4); 0 0 0 1];

% Baricentri dei 4 link rispetto ai propri Sistemi di Riferimento

r11=[0 0 0.5*l1 1]';
r22=[0 0.5*l2 0 1]';
r33=[0 0 0.5*l3 1]';
r44=[0 0 -0.5*l4 1]';

% Baricentri dei link rispetto agli altri Sistemi di Riferimento

r02=A01*A12*r22;
r04=T04*r44;
r12=A12*r22;
r31=A32*A21*r11;
r32=A32*r22;

% Quadrati dei moduli dei vettori dei baricentri

R02=r02'*r02-1;
R04=r04'*r04-1;
R12=r12'*r12-1;
R31=r31'*r31-1;
R32=r32'*r32-1;
R11=r11'*r11-1;

% Matrici delle equazioni dinamiche

D=[0.5*m1*R12+0.25*m3*R32+0.5*m1*R11-0.333*m4*l4^2*C3^2+0.25*C3^2*m4*R04+0.25*m3*R31+q(4)^2*m4+q(4)*m4*l4*C3^2-q(4)*m4*l4+0.25*C3^2*m3*R32+0.25*C3^2*m3*R31-0.333*m3*l3^2*C3^2+0.5*m2*R02+0.333*m3*l3^2+0.25*m4*R04+0.333*m4*l4^2-q(4)^2*m4*C3^2 0 0 0
   0 m2-0.5*S3*m3*l3+m4 -0.5*S3*m3*l3+0.5*S3*m4*l4-S3*q(4)*m4 C3*m4
   0 -0.5*S3*m3*l3+0.5*S3*m4*l4-S3*q(4)*m4 0.25*m3*R32+0.25*m3*R31+q(4)^2*m4-q(4)*m4*l4+0.333*m3*l3^2+0.25*m4*R04+0.333*m4*l4^2 0
   0 C3*m4 0 m4];

h=[(m4*l4*C3^2+2*m4*q(4)-2*m4*q(4)*C3^2-m4*l4)*v(4)*v(1)+(-0.5*S3*m3*C3*R32-0.5*S3*m3*C3*R31+0.667*C3*m3*l3^2*S3-0.5*S3*m4*R04*C3+0.667*S3*C3*m4*l4^2-2*S3*C3*q(4)*m4*l4+2*S3*q(4)^2*C3*m4)*v(3)*v(1)
   (-0.5*C3*m3*l3+0.5*C3*m4*l4-C3*q(4)*m4)*v(3)^2-2*v(3)*S3*m4*v(4)
   (2*m4*q(4)-m4*l4)*v(4)*v(3)+((0.25*S3*m3*C3)*(R32+R31)-0.333*C3*m3*l3^2*S3+0.25*S3*C3*m4*R04-0.333*S3*C3*m4*l4^2+S3*C3*q(4)*m4*l4-S3*q(4)^2*C3*m4)*v(1)^2
   (0.5*m4*l4-m4*q(4))*v(3)^2+(0.5*m4*l4-0.5*m4*l4*C3^2-m4*q(4)+m4*q(4)*C3^2)*v(1)^2];

C=[0
   (m2+m3+m4)*g
   -0.5*m3*g*l3*S3-m4*(-0.5*g*l4*S3+g*S3*q(4))
   m4*g*C3];

% Attrito viscoso

F=[f1 0 0 0
   0 f2 0 0
   0 0 f3 0
   0 0 0 f4]*v;

% Riunisce tutti i risultati in una sola matrice

Matrix=[D,h,C,F];