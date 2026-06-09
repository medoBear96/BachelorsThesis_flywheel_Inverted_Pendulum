void checkSign()
{
  if (stepSeconds>0)
    {
      digitalWrite(DIR_PIN,LOW);
    }
    else
    {
      digitalWrite(DIR_PIN,HIGH);
    }
}


void checkLimits()
{
  if (stepSeconds>=150000)
    {
      stepSeconds=140000;
    }
  if (stepSeconds<=-150000)
    {
      stepSeconds=-1400000;
    } 
}


void changeState()
{
  state= !state;
  digitalWrite(STEP_PIN,state);
}


void changeLed()
{
  led= !led;
  digitalWrite(LED_BUILTIN, led);
}



void calculate_timer()
{
  if(stepSeconds!=0)
  {
    timer=(2400)/abs(stepSeconds);
  }
  else
  {
    counter--;
    timer++;
  }
}
