clear all;

u      = -0.00235;
tauq   = 0.01;

G = tf([u],[-tauq 0 1]);
C = tunablePID('C', 'pid');

k=1;
C.Kp.Value = 427;
C.Kd.Value = 4.5;
C.Ki.Value = 1*0.7;
T = feedback(G,C*k);

rlocus(T);
%pzmap(T);