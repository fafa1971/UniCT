%
% INIT.M
% Inizializzazione dati per il file simulink SISTEMA.M
%

clear all;

% Parametri del robot [Kg] [m]

m1=2;
m2=1;
m3=2;
m4=1;

l1=0.5;
l2=0.2;
l3=0.5;
l4=0.2;

f1=0.0;
f2=0.0;
f3=0.0;
f4=0.0;

% Accelerazione di gravita' [m/sec^2]

g=9.81;

% Vettore dei tempi

td=(0:.01:5)';
T=0.01;       % intervallo per il calcolo traiettorie
Tf=5;         % Istante finale calcolo traiettorie

% Giunto 1

q1_start=0;   % Posizione iniziale 
q1_end=pi/4;  % Posizione finale
v1_start=0;   % Velocita' iniziale

v1_max=0.5;   % Velocita' massima
a1_max=2;     % Accelerazione massima

% Giunto 2

q2_start=0.1; % Posizione iniziale 
q2_end=0.15;  % Posizione finale
v2_start=0;   % Velocita' iniziale

v2_max=0.1;   % Velocita' massima
a2_max=2;     % Accelerazione massima

% Giunto 3

q3_start=0;   % Posizione iniziale 
q3_end=pi/8;  % Posizione finale
v3_start=0;   % Velocita' iniziale

v3_max=0.5;   % Velocita' massima
a3_max=2;     % Accelerazione massima

% Giunto 4

q4_start=0.08;% Posizione iniziale 
q4_end=0.12;  % Posizione finale
v4_start=0;   % Velocita' iniziale

v4_max=0.2;   % Velocita' massima
a4_max=2;     % Accelerazione massima

% Creazione riferimenti LSPB

[q1_des,v1_des,a1_des]=lspb(a1_max,v1_max,q1_start,q1_end,T,Tf);
[q2_des,v2_des,a2_des]=lspb(a2_max,v2_max,q2_start,q2_end,T,Tf);
[q3_des,v3_des,a3_des]=lspb(a3_max,v3_max,q3_start,q3_end,T,Tf);
[q4_des,v4_des,a4_des]=lspb(a4_max,v4_max,q4_start,q4_end,T,Tf);

q_des=[q1_des,q2_des,q3_des,q4_des,v1_des,v2_des,v3_des,v4_des,a1_des,a2_des,a3_des,a4_des];

% Calcolo matrici costanti Kp e Kd

omega=2*pi*2; 	% omega massima
csi=1;

Kp=eye(4)*omega^2;
Kv=eye(4)*2*csi*omega;

% Seleziona l'algoritmo di controllo

Controllo='Feedback Linearization'

% Esporta le variabili globali

global m1 m2 m3 m4 g l1 l2 l3 l4 Kp Kv f1 f2 f3 f4 Controllo