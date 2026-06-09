#include <Wire.h>
//loop counter;
long counter=0;
//accelerometer, gyro and temperature variables
const int MPU=0x68;  
int16_t acx,acy,gyr;
int8_t data=0;
//  ______________________________________________
//
//                  SET-UP OPTION                               1-0    ->    on/off
//________________________________________________
//SERIAL OUTPUT 
boolean Arduino_nano_serial_output=0;
boolean MPU6050_serial_output=0;
boolean Offset_serial_output=0;
boolean Spies_serial_output=0;
boolean Other_serial_output=0;

//OFFSET ANALYSIS
boolean offset_analysis=0;  
boolean offset_central=0;                                            
int sample=500;              
int acc_x_offset =712;
int acc_y_offset =-189;
int gyr_offset =-92;     

//  ______________________________________________
//
//                FILTER & PID OPTION                      
//________________________________________________

float Kp=2000;    
float Ki=1;        
float Kd=0;        
float alpha=0.9984;
float beta=0.999;
float gamma=0.1;
float sp=0;       
boolean deg_flag=1;
//________ PINS _____________
//___________________________

//MPU PINS
#define MPU_ADO 22
#define MPU_Int 23

//SPIES
#define pinR      24
#define pinG      26
#define pinB      28
#define pinSound  30

//those pins are needed for inter-arduino Medo Connection (IAMC)
//five data pins - one sign pin - one interrupt pin
//IAMC                               
#define d1        32                 
#define d2        34
#define d3        36
#define d4        38
#define d5        40
#define d6        42
#define d7        44
#define d8        46

//arduino Nano 
#define standby   48
#define interrupt 50
#define power     52  



//_____________________________________
//
//------------- SET UP ----------------
//________________________________________________

void setup() 
{
  pinMode(MPU_Int, OUTPUT);
  pinMode(MPU_ADO, OUTPUT);
  
  pinMode(d1, OUTPUT); 
  pinMode(d2, OUTPUT);
  pinMode(d3, OUTPUT); 
  pinMode(d4, OUTPUT); 
  pinMode(d5, OUTPUT); 
  pinMode(d6, OUTPUT); 
  pinMode(d7, OUTPUT); 
  pinMode(d8, OUTPUT);
  
  pinMode(interrupt, OUTPUT); 
  pinMode(power, OUTPUT); 
  pinMode(standby, INPUT);

  pinMode(pinR, OUTPUT);                          
  pinMode(pinG, OUTPUT);
  pinMode(pinB, OUTPUT);
  pinMode(pinSound, OUTPUT);
  
  digitalWrite(MPU_ADO, LOW);
  digitalWrite(MPU_Int, LOW);
  //activate serial comunication
  Serial.begin(2000000);    
                             
  standbySignal(3);  
  //MPU setup function
  setup_mpu_6050_registers();   
  if(offset_analysis)
  {
    offset(sample);
  }
  if(offset_central)
  {
    offset_c(sample);
  }
  delay(10);
  //wake up Arduino Nano
  wakeup();    
  

  if (0) 
  {
    errorSignal();
  }
  //myPID.setOutputRange(minOutput, maxOutput);
  prestartSignal();
}
  




//_____________________________________
//
//------------- LOOP ------------------
//_____________________________________


void loop() {
  
  read_mpu_6050_data();      
  data = filter_and_PID();   
  sendData(data);            

  if(counter==900||counter==1900){}
  counter++;                                                     
  if (counter==1700)
  {
    green();
  }
  if (counter==2000)
  {
    off();
    counter=0;
  }
}
