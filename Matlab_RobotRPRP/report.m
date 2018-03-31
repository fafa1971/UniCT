% 
% Stampa i risultati della simulazione di SISTEMA.M
%

global q tau q1_des q2_des q3_des q4_des v1_des v2_des v3_des v4_des a1_des a2_des a3_des a4_des

close all;

% Posizioni e loro riferimenti

figure(1);
set(1,'Units','norma');
set(1,'Position',[0.05 0.30 0.6 0.6]);
set(1,'NumberTitle','off');
set(1,'Name','Posizioni e loro riferimenti');

subplot(2,2,1);
plot(q1_des,'y');
hold on;
newplot;
plot(q(:,1),'r');
xlabel('t');
ylabel('q1');

subplot(2,2,2);
plot(q2_des,'y');
hold on;
newplot;
plot(q(:,2),'r');
xlabel('t');
ylabel('q2');

subplot(2,2,3);
plot(q3_des,'y');
hold on;
newplot;
plot(q(:,3),'r');
xlabel('t');
ylabel('q3');

subplot(2,2,4);
plot(q4_des,'y');
hold on;
newplot;
plot(q(:,4),'r');
xlabel('t');
ylabel('q4');

% Velocità e loro riferimenti

figure(2);
set(2,'Units','norma');
set(2,'Position',[0.15 0.22 0.6 0.6]);
set(2,'NumberTitle','off');
set(2,'Name','Velocità e loro riferimenti');

subplot(2,2,1);
plot(v1_des,'y');
hold on;
newplot;
plot(q(:,5),'r');
xlabel('t');
ylabel('v1');

subplot(2,2,2);
plot(v2_des,'y');
hold on;
newplot;
plot(q(:,6),'r');
xlabel('t');
ylabel('v2');

subplot(2,2,3);
plot(v3_des,'y');
hold on;
newplot;
plot(q(:,7),'r');
xlabel('t');
ylabel('v3');

subplot(2,2,4);
plot(v4_des,'y');
hold on;
newplot;
plot(q(:,8),'r');
xlabel('t');
ylabel('v4');

% Accelerazioni e loro riferimenti

figure(3);
set(3,'Units','norma');
set(3,'Position',[0.25 0.14 0.6 0.6]);
set(3,'NumberTitle','off');
set(3,'Name','Accelerazioni e loro riferimenti');

subplot(2,2,1);
plot(a1_des,'y');
hold on;
newplot;
plot(q(:,9),'r');
xlabel('t');
ylabel('a1');

subplot(2,2,2);
plot(a2_des,'y');
hold on;
newplot;
plot(q(:,10),'r');
xlabel('t');
ylabel('a2');

subplot(2,2,3);
plot(a3_des,'y');
hold on;
newplot;
plot(q(:,11),'r');
xlabel('t');
ylabel('a3');

subplot(2,2,4);
plot(a4_des,'y');
hold on;
newplot;
plot(q(:,12),'r');
xlabel('t');
ylabel('a4');

% Forze Generalizzate

figure(4);
set(4,'Units','norma');
set(4,'Position',[0.35 0.06 0.6 0.6]);
set(4,'NumberTitle','off');
set(4,'Name','Forze Generalizzate');

subplot(2,2,1);
plot(tau(:,1));
xlabel('t');
ylabel('tau1');

subplot(2,2,2);
plot(tau(:,2));
xlabel('t');
ylabel('tau2');

subplot(2,2,3);
plot(tau(:,3));
xlabel('t');
ylabel('tau3');

subplot(2,2,4);
plot(tau(:,4));
xlabel('t');
ylabel('tau4');

