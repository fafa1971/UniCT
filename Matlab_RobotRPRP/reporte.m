% 
% Stampa gli errori della simulazione di SISTEMA.M
%

global q q1_des q2_des q3_des q4_des v1_des v2_des v3_des v4_des a1_des a2_des a3_des a4_des

close all;

% Errori delle Posizioni

figure(1);
set(1,'Units','norma');
set(1,'Position',[0.05 0.30 0.6 0.6]);
set(1,'NumberTitle','off');
set(1,'Name','Errori delle Posizioni');

subplot(2,2,1);
plot(q(:,1)-q1_des,'y');
xlabel('t');
ylabel('e(q1)');

subplot(2,2,2);
plot(q(:,2)-q2_des,'y');
xlabel('t');
ylabel('e(q2)');

subplot(2,2,3);
plot(q(:,3)-q3_des,'y');
xlabel('t');
ylabel('e(q3)');

subplot(2,2,4);
plot(q(:,4)-q4_des,'y');
xlabel('t');
ylabel('e(q4)');

% Errori delle Velocità

figure(2);
set(2,'Units','norma');
set(2,'Position',[0.15 0.22 0.6 0.6]);
set(2,'NumberTitle','off');
set(2,'Name','Errori delle Velocità');

subplot(2,2,1);
plot(q(:,5)-v1_des,'y');
xlabel('t');
ylabel('e(v1)');

subplot(2,2,2);
plot(q(:,6)-v2_des,'y');
xlabel('t');
ylabel('e(v2)');

subplot(2,2,3);
plot(q(:,7)-v3_des,'y');
xlabel('t');
ylabel('e(v3)');

subplot(2,2,4);
plot(q(:,8)-v4_des,'y');
xlabel('t');
ylabel('e(v4)');

% Errori delle Accelerazioni

figure(3);
set(3,'Units','norma');
set(3,'Position',[0.25 0.14 0.6 0.6]);
set(3,'NumberTitle','off');
set(3,'Name','Errori delle Accelerazioni');

subplot(2,2,1);
plot(q(:,9)-a1_des,'y');
xlabel('t');
ylabel('e(a1)');

subplot(2,2,2);
plot(q(:,10)-a2_des,'y');
xlabel('t');
ylabel('e(a2)');

subplot(2,2,3);
plot(q(:,11)-a3_des,'y');
xlabel('t');
ylabel('e(a3)');

subplot(2,2,4);
plot(q(:,12)-a4_des,'y');
xlabel('t');
ylabel('e(a4)');
