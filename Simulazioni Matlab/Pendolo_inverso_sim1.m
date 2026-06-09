clear all

%IMPOSTAZIONI SIMULAZIONE

dt      = 0.00001;      %aggiornamento del sistema s
dt_camp = 0.001250;      %frequenza di correzione s DEVE ESSERE MULTIPLO DI dt
counter = 1;
t_sim   = 2;            %10 sec 

%DISPLAY
display = 100;           %display: 1=>all   n=>uno ogni n
d_counter = 0;
d_array  = 1;




%MOMENTI MECCANICI
M_tot   = 0;
M_g     = 0;
M_m     = 0;

%MOMENTI D'INERZIA
I_tot   = 2.0641;
I_vol   = 0.2055;

%COSTANTI
g       = 9.81;             %g in m/s^2
r       = 0.08;
m_tot   = 263;

%CALCOLI SETUP
mrg     = g*r*m_tot;        %calcolo in setup, dopo rimane costante
N       = t_sim/dt;         %numero iterazioni
CAMP    = dt_camp/dt;       %numero iterazioni per aggiornare il motore
d_a_size = N/display +1;
a(
%ANGOLO TEHTA E DERIVATE
theta   = 0.1;              %angolo inziale
thetaI  = 0;             	%velocità
thetaII = 0;                %accelerazione

%CACLOLO ERRORE
e       = 0;
e_i     = 0;
e_d     = 0;
e_old   = 0;
target  = 0;

%PID
P       = 3;
D       = 0;
I       = 0.00000;


%MAIN SIMULATION
for i=1:N
    %aggiorna momento totale
    M_g     = mrg * sin(theta);
    
    %inserisci momento motore M_m
    if counter==CAMP
        counter = 0;
        
        e       = target - theta;           %calcolo errore
        e_i     = (e + e_i)*dt_camp;        %integrale
        e_d     = (e-e_old)/dt;             %derivativo
        e_old   = e;                        %salva valore 
        
        corr    = P*e + D*e_i + I*e_d;
        M_m     = I_vol*corr;
        %inserisci calcolo pid
    end
    counter = counter+1;
    
    M_tot   = M_g - M_m;
    
    thetaII = M_tot/I_tot;                                  %m/s^2
    theta   = 0.5*thetaII*(dt^2) + thetaI*dt + theta;     
    thetaI  = thetaI + thetaII*dt;                          %*1 s  
    
    if d_counter==display
        a(d_array) = theta;
        b(d_array) = M_g;
        c(d_array) = M_m;
        d(d_array) = M_tot;
        d_counter = 0;
    end
    d_counter = d_counter + 1;
end
    
%VORREI VEDERE 3 GRAFICI DI 
%a  ; b e c nello stesso grafico; d
%ma non funzia XD

subplot(3,1,1)
plot(a)
subplot(3,1,2)
plot(b,c)
subplot(3,1,3)
plot(d)    
    

    
    
    
    
    