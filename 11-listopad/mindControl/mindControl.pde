import oscP5.*;
import netP5.*;

OscP5 oscP5;

int MAX_BUFFER = 1024;

float [] raw;
float med,att,rr;

ArrayList attH,medH,rawH;

void setup(){

  size(1024,768,P2D);

  attH = new ArrayList();
  medH = new ArrayList();
  rawH = new ArrayList();
  
  raw = new float[8];
  oscP5 = new OscP5(this,5003);

}



void draw(){

  background(0);

  stroke(255,100);
  noFill();
  
  beginShape();
  for(int i = 0 ; i < attH.size();i++){
    float tmp = (Float)attH.get(i);
    vertex(i,height-tmp*4.0);

  }
  endShape();

  stroke(#ffcc00,100);

  beginShape();
  for(int i = 0 ; i < medH.size();i++){
    float tmp = (Float)medH.get(i);
    vertex(i,height-tmp*4.0);

  }
  endShape();

  stroke(#00ff00,100);

  beginShape();
  for(int i = 0 ; i < rawH.size();i++){
    float tmp = (Float)rawH.get(i);
    vertex(i,height-tmp/100.0);

  }
  endShape();
}

void oscEvent(OscMessage theOscMessage) {
  String pattern = theOscMessage.addrPattern(); 
  if(pattern.equals("/m/raw")){

    for(int i = 0 ; i < 8;i++)
      raw[i] = theOscMessage.get(i).intValue();

  }

  if(pattern.equals("/m/amr")){

    att = theOscMessage.get(0).intValue();
    med = theOscMessage.get(1).intValue();
    rr = theOscMessage.get(2).intValue();

    attH.add(att);
    medH.add(med);
    rawH.add(rr);

    if(attH.size()>MAX_BUFFER){
      attH.remove(0);
    }

    if(medH.size()>MAX_BUFFER){
      medH.remove(0);
    }
  
    if(rawH.size()>MAX_BUFFER){
      rawH.remove(0);
    }
  }

  /*
  print(" typetag: "+theOscMessage.typetag());
  println(" timetag: "+theOscMessage.timetag());
  */
}

