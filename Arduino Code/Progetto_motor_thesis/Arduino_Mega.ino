void IRS()
{
  flag=true;
}

int newData()
{
  int8_t data=0;                   
  boolean read1= digitalRead(d1);
  boolean read2= digitalRead(d2);
  boolean read3= digitalRead(d3);
  boolean read4= digitalRead(d4);
  boolean read5= digitalRead(d5);
  boolean read6= digitalRead(d6);
  boolean read7= digitalRead(d7);;
  boolean read8= digitalRead(d8);    
  
  data = read8<<7 | read7<<6 | read6<<5 | read5<<4 | read4<<3 | read3<<2 | read2<<1 | read1;   
  return data;
}
