


import oscP5.*;
import netP5.*;

boolean saveit = false;


int frames = 0;
int totalFrames = 31;


color A,B;//



OscP5 oscP5;
NetAddress myRemoteLocation;

float attention,meditation,raw;

ArrayList att,med,rraw,pos;

public void setup() {
  size(1600, 900,OPENGL);
  hint(DISABLE_DEPTH_TEST) ;
  oscP5 = new OscP5(this,5003);


  att= new ArrayList();
  med= new ArrayList();
  rraw= new ArrayList();

  pos = new ArrayList();

  A = color(#FFFFFF);
  B = color(#000000);

  frameRate(100);

  imageMode(CENTER);

  noFill();
  stroke(0);
  strokeWeight(20);
  smooth();
}

void oscEvent(OscMessage theOscMessage) {
  /* check if theOscMessage has the address pattern we are looking for. */

  try{
  if(theOscMessage.checkAddrPattern("/eeg")==true) {
    /* check if the typetag is the right one. */
    if(theOscMessage.checkTypetag("iii")) {
      /* parse theOscMessage and extract the values from the osc message arguments. */
      attention += (theOscMessage.get(0).intValue() - attention) / 20.0 ;  
      meditation += (theOscMessage.get(1).intValue() - meditation) / 20.0;
      raw += (theOscMessage.get(2).intValue()-raw) / 20.0;

      att.add(attention);
      med.add(meditation);
      rraw.add(raw);

      if(att.size()>width)
        att.remove(0);

      if(med.size()>width)
        med.remove(0);

      if(rraw.size()>width)
        rraw.remove(0);


      pos.add(new PVector(map(attention,0,100,0,width),map(meditation,0,100,0,height)));


      if(pos.size()>1000)
        pos.remove(0);


      return;
    }  
  } 

  }catch(Exception e){;}
}



void draw() {
  background(
      map(attention,0,100,0,255),
      map(meditation,0,100,0,255),
      map(raw,-32000,32000,0,255)

      );

  float speed = attention/1000.0;

  noStroke();


  stroke(0);
  beginShape();
  for(int i = 0 ; i < pos.size();i++){
    PVector tmp = (PVector)pos.get(i);
   
    stroke(0,map(i,0,pos.size(),0,120));
    vertex(tmp.x,tmp.y);
  }
  endShape();

  /*
  pushMatrix();

  translate(width/2,height/2);

  rotate(frameCount/10000.0);
  pushMatrix();
  translate(0,-sin(frameCount/10000.0)*200.0);
  rotate(frameCount/10000.0);

  fill(B);

  float frac = PI / (meditation/2.0);

  for(float f = frac/2 ; f < TWO_PI;f += frac*2){

    triangle(
        cos(f)*width,sin(f)*width,
        cos(f+frac)*width,sin(f+frac)*width,
        0,0);
  }
  popMatrix();


  pushMatrix();
  translate(0,sin(frameCount/10000.0)*200.0);
  rotate(-frameCount/speed);

  frac = PI / (attention/4.0+10.0);

  for(float f = frac/2 ; f < TWO_PI;f += frac*2){
    triangle(
        cos(f)*width,sin(f)*width,
        cos(f+frac)*width,sin(f+frac)*width,
        0,0);
  }

  popMatrix();
  popMatrix();
*/
  strokeWeight(1);

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


      stroke(#ff0000,20);
      line(i-1,A1,i,A2);
      stroke(#00ff00,20);
      line(i-1,B1,i,B2);
      stroke(#0000FF,20);
      line(i-1,C1,i,C2);
    }
}
