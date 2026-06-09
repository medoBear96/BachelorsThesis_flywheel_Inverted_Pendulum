clear all

%____________IMPOSTAZIONI SIMULAZIONE__________________

dt      = 0.00005;      %aggiornamento del sistema (secondi)
dt_camp = 0.00125;      %attuazione del controllore (DEVE ESSERE MULTIPLO DI dt!!!!!)
t_sim   = 1;           %durata in secondi della simulazione
display = 1;            %ridurre dati su display: 1=>all   n=>uno ogni n
ampl    = 0.00005;

%PID
k=3;
P       = 1*427*k;
D       = 1*4.5*k;
I       = 0.1*0.7*k;
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
thetaR  = 0;
thetaRO = 0;




%%questi valori sono frutto di stima
last_value = -0.05;         %valore appena stimato
actual_value = 0;       %valore da stimare

%%valori rilevati
last_riv =0;
actual_riv =0;
local_der=0;            %derivata locale

%max and min array
maxs = [0 1];
mins = [0 1];
lastd = 0;
actuald = 0;
secondd = 0; 



%MAIN SIMULATION
for i=1:N
    %aggiorna momento totale
    M_g     = mrg * sin(theta);
    
    %inserisci momento motore M_m
    if counter==CAMP
        counter = 0;
        rumore  = ampl*random('normal',0,1);
        thetaR  = -theta + rumore;
        
        actual_riv=thetaR;
        local_der = actual_riv - last_riv; 
        last_riv = actual_riv;
        if local_der>0          %caso maxs
            actuald = (actual_riv-maxs(1))/maxs(2);
            secondd = actuald-lastd;
            a   = secondd*0.5;
            b   = actuald;
            c   = last_value;

            actual_value = a + b + c;
            maxs(1) = last_riv;
            maxs(2) = 1;
            mins(2) = mins(2)+1;
        else
            actuald = (actual_riv-mins(1))/mins(2);
            secondd = actuald-lastd;
            a   = secondd*0.5;
            b   = actuald;
            c   = last_value;

            actual_value = a + b + c;
            mins(1) = last_riv;
            mins(2) = 1;
            maxs(2) = maxs(2)+1; 
        end
        last_value=actual_value;
        lastd= actuald;


        
        e_d     = (thetaR-thetaRO)/dt;
        thetaRO = thetaR;
        
        
        e   = target - theta  + rumore; %calcolo errore
        %e   = target - last_value;
        
        if anti_wu==1
            if e_old>0 && e<0
                e_i=0;
            end
        elseif e_old<0 && e>0
                e_i=0;
            
        end
        
        
        
        
        e_i     = (e + e_i)*dt_camp;        %integrale
        %e_d     = (e-e_old)/dt;             %derivativo
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
        c(d_array) = corr;
        d(d_array) = actual_value;
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



%ylabel('errore (degrees)')
%subplot(3,1,2)
%plot(b) 
%ylabel('correzione (rad/s^2)')

subplot(4,1,1)
plot(a) 
ylabel('theta')    
    

subplot(4,1,2)
plot(b) 
ylabel('theta + rumore')    

subplot(4,1,3)
plot(d) 
ylabel('actual_value')    


subplot(4,1,4)
plot(c) 
ylabel('corr')  










    
    
    