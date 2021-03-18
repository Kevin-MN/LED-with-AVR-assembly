#define blue 8    // define pins
#define red 9
#define green 10

const int sound_pin = A0; // declare sensor pin
const int thresh = 100; // declare volume threshhold volume

void setup() { 
  pinMode(sound_pin, INPUT);  // set sensor pin to input
}

void loop() {
  int sensor_value = analogRead(sound_pin); // obtain sensor value
  if(sensor_value >= thresh){ // led strip lights up if reading is greater than thresh 
    analogWrite(red,0);   // rgb strip blinks white
    analogWrite(blue, 255);
    analogWrite(green, 0);
  }
  else{ // reading not loud enough, turn lights off
  analogWrite(red,0);
  analogWrite(blue,0);
  analogWrite(green,0);
}
}
