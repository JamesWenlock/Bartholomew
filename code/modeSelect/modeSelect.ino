#include <Adafruit_NeoPixel.h>

#include <CapacitiveSensor.h>

/*
 * CapitiveSense Library Demo Sketch
 * Paul Badger 2008
 * Uses a high value resistor e.g. 10M between send pin and receive pin
 * Resistor effects sensitivity, experiment with values, 50K - 50M. Larger resistor values yield larger sensor values.
 * Receive pin is the sensor pin - try different amounts of foil/metal on this pin
 */
#define PIN            9

// How many NeoPixels are attached to the Arduino?
#define NUMPIXELS      23

Adafruit_NeoPixel pixels = Adafruit_NeoPixel(NUMPIXELS, PIN, NEO_GRB + NEO_KHZ800);


CapacitiveSensor purpleCap = CapacitiveSensor(4,2);        // 10M resistor between pins 4 & 2, pin 2 is sensor pin, add a wire and or foil if desired
CapacitiveSensor blueCap = CapacitiveSensor(5,6);        // 10M resistor between pins 4 & 2, pin 2 is sensor pin, add a wire and or foil if desired

void setup()                    
{
   //putpleCap.set_CS_AutocaL_Millis(0xFFFFFFFF);     // turn off autocalibrate on channel 1 - just as an example 
   Serial.begin(9600);
   pixels.begin();
   for(int i=0;i<NUMPIXELS;i++){
     pixels.setPixelColor(i,pixels.Color(255,0,255));
   }   
   pixels.show();
}

void loop()                    
{
    long start = millis();
    long purpleVal =  purpleCap.capacitiveSensor(30);
    long blueVal = blueCap.capacitiveSensor(30);
    int mode = 0;
    int capSensorLimit = 9000;
    Serial.print("Purple Val: ");
    Serial.println(blueVal);

    mode = mode + updateMode(purpleVal, 1, capSensorLimit);
    mode = mode + updateMode(blueVal, 2, capSensorLimit);

    Serial.write(mode);
    delay(100);                             // arbitrary delay to limit data to serial port 
}

int updateMode(float val, int code, int capSensorLimit) {
  if (val > capSensorLimit) {
    return code;
  }
  return 0;
}
