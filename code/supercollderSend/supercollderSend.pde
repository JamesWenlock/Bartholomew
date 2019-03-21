import processing.serial.*;
import oscP5.*;
import netP5.*;
int val;

Serial myPort;
OscP5 oscP5;
NetAddress myRemoteLocation;

void setup() {
 println(Serial.list()); 
 myPort = new Serial(this, Serial.list()[1], 9600);
 oscP5 = new OscP5(this,12000);
 myRemoteLocation = new NetAddress("127.0.0.1",57120);
 
}

void draw() {
  if ( myPort.available() > 0) {  // If data is available,
    val = myPort.read();         // read it and store it in val
    OscMessage myMessage = new OscMessage("/test");
    myMessage.add(val);  
    println(val);
    oscP5.send(myMessage, myRemoteLocation);    
  } 
}