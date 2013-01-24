
ArrayList traces;

void setup(){

  size(600,600,P3D);

  traces = new ArrayList();


}

float ROTATION_Y = 0;


void mousePressed(){
  if(mouseButton==LEFT){

    Trace tmp = new Trace();
    tmp.start();
    traces.add(tmp);
  }else if(mouseButton==RIGHT && traces.size()>=1){
    Trace last = (Trace)traces.get(traces.size()-1);
    traces.remove(last);
  }
}

void mouseReleased(){
  try{
  Trace tmp = (Trace)traces.get(traces.size()-1);
    tmp.stop();
  }catch(Exception e){;}
}






void draw(){

  ROTATION_Y = frameCount/70.0;

  background(200);

  pushMatrix();
  translate(width/2,0);
  rotateY(ROTATION_Y);

  pushMatrix();
  //translate(-width/2,-height/2);

  stroke(0,190);
  strokeWeight(2);
  noFill();

  for(int i = 0 ; i < traces.size();i++){
    Trace t  = (Trace)traces.get(i);
    t.drawShape();

  }

  popMatrix();

  popMatrix();
}

class Trace{
  ArrayList points;
  boolean writing = false;

  Trace(){
    points = new ArrayList();

  }

  void start(){
    writing = true;
  }

  void stop(){
    writing = false;
  }

  void drawShape(){
    beginShape();
    for(int i = 0 ; i < points.size();i+=2){
      PVector tmp = (PVector)points.get(i);
      vertex(tmp.x,tmp.y,tmp.z);

    }
    endShape();

    if(writing){
      //points.add(new PVector(modelX(mouseX,mouseY,0),modelY(mouseX,mouseY,0),modelZ(mouseX,mouseY,0)));
      points.add(new PVector(
            (cos(ROTATION_Y))*(mouseX-width/2),
             mouseY,
            (sin(ROTATION_Y))*(mouseX-width/2)
            ));
    
    }
  }


}
