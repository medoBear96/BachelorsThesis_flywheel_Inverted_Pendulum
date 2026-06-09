clear all

ang=1*pi/180   % Angolo iniziale (angolo 0 = posizione di equilibrio verticale)
targ=0;         % target
P=9.04;D=0;I=21.7;    % Costanti PID 

% Valori iniziali dai quali iniziare l'integrazione numerica
dt=1257;
err_old=0;
vel_mo=0;
erri=0;
ome_p=0;
vel_m=0;

peso=263;   % peso del pendolo
I1=0.2055;    % Momento d'inerziadel volano
I2=2.0641;   % Momento d'inerzia del pendolo inverso

N=500; % Numero di integrazioni
assex=1:N;
for i=1:N

err=ang-targ;       % errore
if((err*erri)<0)    % evita wind-up
    erri=0;
erri=erri+err;      % errore integrale
errd=err-err_old;   % derivata dell'errore 
err_old=err;        % aggiornamento 

vel_m=P*err+D*errd+I*erri;  % velocità del motore generata dal PID
% if abs(vel_m)>1000 vel_m=1000*sign(vel_m); end  % si supponga la velocità non possa superare un certo valore massimo pari a 1000

% acc_m=P*err+D*errd+I*erri;
% vel_m=vel_m+P*err+D*errd+I*erri;

acc_m=vel_m-vel_mo; % accellerazione del motore
vel_mo=vel_m;       % aggiornamento velocità (per calcolare l'accelerazione)

C1=peso*sin(ang)*0.08;   % Coppia ribaltante 
C2=acc_m*I1;        % Coppia raddrizzante sviluppata dall'accelerazione del motore

C=C1-C2;            % Coppia complessiva

acc_p=C/I2;         %accelerazione del pendolo
ome_p=ome_p+acc_p;  % velocità angolare del pendolo
ang=ang+ome_p;      % Posizione del pendolo

if (ang>pi) ang=ang-2*pi;end
if (ang<-pi) ang=ang+2*pi;end

% Salvo alcuni risultati nei vettori 

a(i)=ang;
c1(i)=C1;
c2(i)=-C2;
v(i)=vel_m;

end


% Plot di alcuni risultati 

subplot(3,1,1)
plot(a*180/pi)
subplot(3,1,2)
plot(assex,c1,assex,c2)
subplot(3,1,3)
plot(v)


