/**
 * oscP5parsing by andreas schlegel
 * example shows how to parse incoming osc messages "by hand".
 * it is recommended to take a look at oscP5plug for an
 * alternative and more convenient way to parse messages.
 * oscP5 website at http://www.sojamo.de/oscP5
 */

import oscP5.*;
import netP5.*;

OscP5 oscP5;
NetAddress myRemoteLocation;

float attention,meditation,raw;

ArrayList att,med,rraw;

void setup() {
  size(1600,400,P2D);
  frameRate(25);
  /* start oscP5, listening for incoming messages at port 12000 */
  oscP5 = new OscP5(this,5003);


  att= new ArrayList();
  med= new ArrayList();
  rraw= new ArrayList();


  /* myRemoteLocation is a NetAddress. a NetAddress takes 2 parameters,
   * an ip address and a port number. myRemoteLocation is used as parameter in
   * oscP5.send() when sending osc packets to another computer, device, 
   * application. usage see below. for testing purposes the listening port
   * and the port of the remote location address are the same, hence you will
   * send messages back to this sketch.
   */
  myRemoteLocation = new NetAddress("127.0.0.1",12000);
}

void draw() {
  background(
      map(attention,0,100,0,255.0),
      map(meditation,0,100,0,255.0),
      map(raw,-32000,32000,0,255.0)
      );  



  if(att.size()>1)
  for(int i = 1 ; i < att.size();i++){
    float a1 = (Float)att.get(i-1);
    float b1 = (Float)med.get(i-1);
    float c1 = (Float)rraw.get(i-1);

    float a2 = (Float)att.get(i);
    float b2= (Float)med.get(i);
    float c2 = (Float)rraw.get(i);


    float A1 = map(a1,0,100,height,0);
    float B1 = map(b1,0,100,height,0);
    float C1 = map(c1,-32000,32000,height,0);


    float A2 = map(a2,0,100,height,0);
    float B2 = map(b2,0,100,height,0);
    float C2 = map(c2,-32000,32000,height,0);


    stroke(#ff0000,100);
    line(i-1,A1,i,A2);
    stroke(#00ff00,100);
    line(i-1,B1,i,B2);
    stroke(#0000FF,100);
    line(i-1,C1,i,C2);
  }


}


void oscEvent(OscMessage theOscMessage) {
  /* check if theOscMessage has the address pattern we are looking for. */

  if(theOscMessage.checkAddrPattern("/eeg")==true) {
    /* check if the typetag is the right one. */
    if(theOscMessage.checkTypetag("iii")) {
      /* parse theOscMessage and extract the values from the osc message arguments. */
      attention += (theOscMessage.get(0).intValue()-attention) / 55.0 ;  
      meditation += (theOscMessage.get(1).intValue() - meditation) / 5.0;
      raw += (theOscMessage.get(2).intValue()-raw) / 10.0;

      att.add(attention);
      med.add(meditation);
      rraw.add(raw);

      if(att.size()>width)
        att.remove(0);

      if(med.size()>width)
        med.remove(0);

      if(rraw.size()>width)
        rraw.remove(0);


      println(raw);

      return;
    }  
  } 
  println("### received an osc message. with address pattern "+theOscMessage.addrPattern());
}
