
//________ PINS _______________
//-----------------------------

//________ INPUT ______________                                      
#define d1        9                     
#define d2        8
#define d3        7
#define d4        6
#define d5        5
#define d6        4
#define d7        3
#define d8        A4

#define interrupt 2

//________ OUTPUT _____________

#define standby   A3                    

#define DIR_PIN   A0                      
#define STEP_PIN  A1
#define EN_PIN    A5
#define CS_PIN    10  
#define MOSI_PIN  11
#define MISO_PIN  12
#define SCK_PIN   13
//________ VARIABLES __________
//-----------------------------


volatile boolean flag=false;

  
boolean state=0;                             
int acceleration =0;                            

float stepSeconds=0;                        
long counter=0;                            
long timer=1000000;

long counter1=0;                             
boolean led=0;                               





//________ IMPOSTATION ________
//-----------------------------

#define maxGear 3
#define minGear 0

int gear=2;                           

#define blink_time 1000


void setup() {
  //MedoConnection PINS
  pinMode(interrupt, INPUT_PULLUP); 
  attachInterrupt(digitalPinToInterrupt(interrupt), IRS, RISING);
  pinMode(d1, INPUT); 
  pinMode(d2, INPUT);
  pinMode(d3, INPUT); 
  pinMode(d4, INPUT); 
  pinMode(d5, INPUT); 
  pinMode(d6, INPUT); 
  pinMode(d7, INPUT); 
  pinMode(d8, INPUT); 
  pinMode(standby, OUTPUT); 

  //Motor control PINS
  
  pinMode(LED_BUILTIN, OUTPUT);
  pinMode(DIR_PIN, OUTPUT); 
  pinMode(STEP_PIN, OUTPUT);
  pinMode(EN_PIN, OUTPUT); 
  pinMode(MISO_PIN, OUTPUT); 
  digitalWrite(EN_PIN, LOW);
  digitalWrite(MISO_PIN, LOW);
  
  digitalWrite(standby,HIGH);
  changeLed();
  delayMicroseconds(20);
  while(flag==false)                      
  
  flag=false;
  changeLed();
  //Serial.println("helo");
  
}




void loop() 
{
  if(flag==true)
  {
    acceleration = newData();
    flag=false; 
  }
  checkSign();
  calculate_timer();
 
  
  counter++;
  counter1++;
  if (counter >= timer)
  {
    changeState();
    stepSeconds=stepSeconds+acceleration;
    counter = 0;
  }
  if (counter1 >= blink_time)
  {
    changeLed();
    counter1 = 0;
  }
  
}
