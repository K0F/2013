import oscP5.*;
import netP5.*;

OscP5 oscP5;

int MAX_BUFFER = 1024;

int [] raw;
float med,att,rr;

ArrayList attH,medH,rawH,waves;

void setup(){

  size(1024,768,P2D);

  attH = new ArrayList();
  medH = new ArrayList();
  rawH = new ArrayList();

  waves = new ArrayList();

  raw = new int[8];
  oscP5 = new OscP5(this,5003);

}



void draw(){

  background(0);


  /////////// RAW //////////////////////////

  stroke(#ff0000,100);
  for(int ii = 0; ii < 8;ii++){
    beginShape();
    for(int i = 0 ; i < waves.size();i++){
      int tmp = ((int[])waves.get(i))[ii];
      vertex(i,height/2-tmp/100.0);

    }
    endShape();
  }


  noFill();

  /////////// AMR //////////////////////////

  stroke(255,100);

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
    vertex(i,height/2-tmp/100.0);

  }
  endShape();



}

void oscEvent(OscMessage theOscMessage) {
  String pattern = theOscMessage.addrPattern(); 
  if(theOscMessage.checkAddrPattern("/m/raw")){

    for(int i = 0 ; i < 8;i++){
      raw[i] = theOscMessage.get(i).intValue();
    }

    waves.add(raw);

    if(waves.size()>MAX_BUFFER)
      waves.remove(0);
  }

  if(theOscMessage.checkAddrPattern("/m/amr")){

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
  
  if(theOscMessage.checkAddrPattern("/nia/data")){

    String a  = theOscMessage.get(0).stringValue();
    println("NIA said:"+a);
     print(" typetag: "+theOscMessage.typetag());
     println(" timetag: "+theOscMessage.timetag());

  }
}

