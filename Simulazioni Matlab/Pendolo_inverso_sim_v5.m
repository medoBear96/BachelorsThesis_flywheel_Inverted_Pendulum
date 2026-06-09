clear all

%____________IMPOSTAZIONI SIMULAZIONE__________________

dt      = 0.00005;      %aggiornamento del sistema (secondi)
dt_camp = 0.00125;      %attuazione del controllore (DEVE ESSERE MULTIPLO DI dt!!!!!)
t_sim   = 2;           %durata in secondi della simulazione
display = 1;            %ridurre dati su display: 1=>all   n=>uno ogni n
ampl    = 0.01;

%PID
k=2;
P       = 1*427*k;
D       = 1*4.5*k;
I       = 0.1*k;
anti_wu = 0;            %anti windup for integral action 1/0

target  = 0;
theta   = -0.05;          %angolo inziale (radianti)

corr_limit=60;

%______________________________________________________


%DISPLAY and COUNTER
counter = 1;
d_counter = 0;
d_array  = 1;


%MOMENTI D'INERZIA
I_tot   = 0.0021008;
I_vol   = 0.0004110;

%Altre COSTANTI
g       = 9.81;             %g in m/s^2
r       = 0.08;
m_tot   = 0.347;

%CALCOLI SETUP
mrg     = g*r*m_tot;        %calcolo in setup, dopo rimane costante
N       = t_sim/dt;         %numero iterazioni
CAMP    = dt_camp/dt;       %numero iterazioni per aggiornare il motore
d_a_size = N/display +1;

%ANGOLO TEHTA E DERIVATE
thetaI  = 0;             	%velocità
thetaII = 0;                %accelerazione
v_vol   = 0;

%MOMENTI MECCANICI
M_tot   = 0;
M_g     = 0;
M_m     = 0;

%CACLOLO ERRORE
e       = 0;
e_i     = 0;
e_d     = 0;
e_old   = 0;
rumore  = 0;
corr    = 0;



start = theta;
%valori rilevati
f_riv       = start;
f_riv_o     = start;

f_local_d   = 0;

%analisi max/min
f_max       = start;
f_max_t     = 1;
f_min       = start;
f_min_t     = 1;

%valori calcolati
f_der       = 0;
f_der_o     = 0;
f_der_sec   = 0;
f_value     = start;

long=2;
sum=0;
media_counter = 1;
for z=1:long
   old_values(z)=start;
end

%MAIN SIMULATION
for i=1:N
    %aggiorna momento totale
    M_g     = mrg * sin(theta);
    
    %inserisci momento motore M_m
    if counter==CAMP
        counter = 0;
        rumore  = ampl*random('normal',0,1);
        
        
        
        old_values(media_counter)= theta + rumore;
        for w=1:long
            sum=old_values(w);
        end
        sum = sum/long;
        media_counter = media_counter+1;
        if media_counter>long
            media_counter =1;
        end
        
        
        
        %%%%%
        f_riv = theta + rumore;
        f_local_d = f_riv - f_riv_o;
        if f_local_d > 0
            f_der   = (f_riv - f_max)/f_max_t;
            f_max   = f_riv;
            f_max_t = 0;
        else
            f_der   = (f_riv - f_min)/f_min_t;
            f_min   = f_riv;
            f_min_t = 0;
        end
        f_der_sec   = f_der - f_der_o;
        f_a = f_der_sec*0.5;
        f_b = f_der*1;
        f_c = f_value;
        f_value = f_a + f_b + f_c;
        f_der_o     = f_der;
        f_max_t     = f_max_t + 1;
        f_min_t     = f_min_t + 1;

        %}
        
        e   = target - savitsky;
        %e   = target - theta  - rumore; %calcolo errore
        
        
        
        
        
        e_i     = (e + e_i)*dt_camp;        %integrale
        e_d     = (e-e_old)/dt;             %derivativo
        e_old   = e;                        %salva valore 
        
        
        
        corr    = P*e + D*e_i + I*e_d;
        if corr>corr_limit
            corr=corr_limit;
        elseif corr<-corr_limit
            corr=-corr_limit;
        end
        v_vol   = v_vol + corr*dt;
        M_m     = I_vol*corr;
        %inserisci calcolo pid
    end
    counter = counter+1;
    
    M_tot   = M_g + M_m;
    
    thetaII = M_tot/I_tot;                                  %m/s^2
    theta   = 0.5*thetaII*(dt^2) + thetaI*dt + theta;     
    thetaI  = thetaI + thetaII*dt;                          %*1 s  
    
    if d_counter==display
        a(d_array) = theta;
        b(d_array) = theta + rumore;
        c(d_array) = f_value;
        d(d_array) = sum;
        f(d_array) = e_i;
        h(d_array) = e_d;
        d_counter = 0;
        d_array=d_array+1;
    end
    d_counter = d_counter + 1;
end
    
%VORREI VEDERE 3 GRAFICI DI 
%a  ; b e c nello stesso grafico; d
%ma non funzia XD


subplot(4,1,1)
plot(a*180/pi)
ylim([-10 4]);
ylabel('theta effettivo (rad)')
title(['Risposta allo scalino, durata simulazione t= ' num2str(t_sim) ' s, numero campioni= ' num2str(N)])
%hold on
subplot(4,1,2)
plot(b*180/pi)
ylim([-10 4]);
ylabel('theta rilevato (rad)')
title(['Risposta allo scalino, durata simulazione t= ' num2str(t_sim) ' s, numero campioni= ' num2str(N)])
%hold on
subplot(4,1,3)
plot(c*180/pi)
ylim([-10 4]);
ylabel('theta rilevato (rad)')
title(['Risposta allo scalino, durata simulazione t= ' num2str(t_sim) ' s, numero campioni= ' num2str(N)])
%hold on
subplot(4,1,4)
plot(d*180/pi)
ylim([-10 4]);
ylabel('theta rilevato (rad)')
title(['Risposta allo scalino, durata simulazione t= ' num2str(t_sim) ' s, numero campioni= ' num2str(N)])
%hold on
    