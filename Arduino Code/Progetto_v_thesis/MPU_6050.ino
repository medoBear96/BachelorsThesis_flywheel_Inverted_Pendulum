int rawx,rawy;
void setup_mpu_6050_registers()
{

  int err1=0;
  int err2=0;
  int err3=0;
  int tot=0;
  //Activate the MPU-6050
  delayMicroseconds(20);
  Wire.setClock(400000);       
  Wire.beginTransmission(0x68);   
  Wire.write(0x6B);             
  Wire.write(0x00);               
  err1=Wire.endTransmission(); 
  
  //Configure the accelerometer ()
  //  0x00 -> +/- 2g
  //  0x08 -> +/- 4g
  //  0x10 -> +/- 8g
  //  0x18 -> +/- 16g
  Wire.beginTransmission(0x68);
  Wire.write(0x1C);            
  Wire.write(0x00);               
  err2=Wire.endTransmission(); 
  
  //Configure the gyro 
  //  0x00 -> +/- 250°/s
  //  0x08 -> +/- 500°/s
  //  0x10 -> +/- 1000°/s
  //  0x18 -> +/- 2000°/s
  Wire.beginTransmission(0x68);  
  Wire.write(0x1B);              
  Wire.write(0x00);                 
  err3=Wire.endTransmission();    

  tot=err1+err2+err3;
  if (tot!=0)   
  {
     MPU_6050_error_print(err1,err2,err3);
     delayMicroseconds(50); 
     setup_mpu_6050_registers();                                      
  }
  else
  {
    MPU_6050_ok_print();
  }
}


void read_mpu_6050_data()
{                                            
  Wire.beginTransmission(0x68);         
  Wire.write(0x3B);                     
  int err1=Wire.endTransmission(false);    
  Wire.requestFrom(0x68,4,true);        
  acx=Wire.read()<<8|Wire.read();        
  acy=Wire.read()<<8|Wire.read();       
  
  Wire.beginTransmission(0x68);          
  Wire.write(0x47);                      
  int err2=Wire.endTransmission(false);                                         
  Wire.requestFrom(0x68,2,true);   
  gyr=Wire.read()<<8|Wire.read();       
  if (err1!=0||err2!=0)
  {
    read_mpu_6050_data();              
  }
}
