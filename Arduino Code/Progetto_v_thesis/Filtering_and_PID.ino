//VARIABLES AND CONSTATS

long t = 0;                         
long lt = 0;                       
int dt = 580;         

double e = 0.0;                       
double le = 0.0;                   

double i = 0.0;                       
double d = 0.0;                       

double correction = 0;                 
double constant = 0.000000;

float acc_angle = 0.0;                
float gyr_angle = 0.0;                 
float gyr_rot = 0.0;                  
double fb = 0.00;                      

#define R2D 57.3

int8_t output;


int8_t filter_and_PID()
{
  t  = micros();                                                                           
  dt = t - lt;
  lt = t;
  acc_angle   = (atan2(abs(acx-acc_x_offset),abs(acy-acc_y_offset))*R2D)-45);    
  gyr_rot     = ( (gyr - gyr_offset) * (0.00763 * dt) );
  gyr_angle   = gyr_angle  + (gyr_rot / 1000000);                                           
  fb          = alpha * (gyr_angle) + (1 - alpha) * (acc_angle);                                       
  
  e   = sp - fb;                                                                               
  i   = i + e*dt;                                                                            
  d   = (e - le)/dt;                                                                        
  le  = e;
  correction = Kp * e + Ki * i + Kd * d;                                                         

  
  if (correction>=124)
  {
    correction=124;
  }
  if (correction<=(-124))
  {
    correction=(-124);
  }
  if (isnan(correction))
  {
    correction=previous_correction;
  }
  else
  {
    previous_correction=correction;
  }
  output=round(correction);
  return output;                                                                        
}
