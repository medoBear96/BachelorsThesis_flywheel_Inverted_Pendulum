void wakeup()
{
  boolean proceed=0;
  digitalWrite(interrupt,LOW);
  digitalWrite(power,HIGH);
  Arduino_nano_print();
  Arduino_nano_online_print();
  digitalWrite(interrupt,HIGH);
  delayMicroseconds(100);
  digitalWrite(interrupt,LOW);
}


void sendData(int8_t acceleration)
{
  digitalWrite(d1, bitRead(acceleration, 0)); 
  digitalWrite(d2, bitRead(acceleration, 1));
  digitalWrite(d3, bitRead(acceleration, 2)); 
  digitalWrite(d4, bitRead(acceleration, 3)); 
  digitalWrite(d5, bitRead(acceleration, 4)); 
  digitalWrite(d6, bitRead(acceleration, 5)); 
  digitalWrite(d7, bitRead(acceleration, 6)); 
  digitalWrite(d8, bitRead(acceleration, 7)); 
  //Serial.println(acceleration);
  delayMicroseconds(5);
  digitalWrite(interrupt, HIGH); 
  delayMicroseconds(10);
  digitalWrite(interrupt, LOW);
}
