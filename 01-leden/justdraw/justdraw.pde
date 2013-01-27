/**
  Fri Jan 25 01:58:55 CET 2013



  ,dPYb,                  ,dPYb,
  IP'`Yb                  IP'`Yb
  I8  8I                  I8  8I
  I8  8bgg,               I8  8'
  I8 dP" "8    ,ggggg,    I8 dP
  I8d8bggP"   dP"  "Y8ggg I8dP
  I8P' "Yb,  i8'    ,8I   I8P
  ,d8    `Yb,,d8,   ,d8'  ,d8b,_
  88P      Y8P"Y8888P"    PI8"8888
  I8 `8,
  I8  `8,
  I8   8I
  I8   8I
  I8, ,8'
  "Y8P'
 */


boolean AUTOROTATE_Y = false;

ArrayList traces;

////////////////////////////////////////////////////

boolean ROTATING = false;
float TARGET_ROTATION_Y = 0;
float TARGET_ROTATION_X = 0;
float TARGET_ROTATION_Z = 0;
float ROT_START_X = 0;
float ROT_START_Y = 0;
float ROT_START_Z = 0;

void setup(){

  size(600,600,P3D);

  traces = new ArrayList();

}

float ROTATION_Y = 0;
float ROTATION_X = 0;
float ROTATION_Z = 0;

///////////////////////////////////////////////////


void mousePressed(){
  if(mouseButton==LEFT){

    Trace tmp = new Trace();
    tmp.start();
    traces.add(tmp);
  }else{
    ROTATING = true;
    TARGET_ROTATION_Y = ROTATION_Y;
    TARGET_ROTATION_X = ROTATION_X;
    TARGET_ROTATION_Z = ROTATION_Z;
    ROT_START_Y = mouseX;
    ROT_START_X = mouseY;
    ROT_START_Z = mouseX-mouseY;
  }
}

///////////////////////////////////////////////////

void mouseReleased(){
  try{
    Trace tmp = (Trace)traces.get(traces.size()-1);
    tmp.stop();
  }catch(Exception e){;}

  if(mouseButton==RIGHT){
    ROTATING=false;

  }
}

void keyPressed(){
  if(traces.size()>=1){
    Trace last = (Trace)traces.get(traces.size()-1);
    traces.remove(last);
  }

}

//////////////////////////////////////////////////

void draw(){

  if(ROTATING){
    TARGET_ROTATION_Y += (ROTATION_Y+radians(mouseX-ROT_START_Y)-TARGET_ROTATION_Y)/40.0;
    TARGET_ROTATION_X -= (ROTATION_X+radians(mouseY-ROT_START_X)-TARGET_ROTATION_X)/40.0;
    TARGET_ROTATION_Z -= (ROTATION_Z+(radians(mouseX-mouseY-ROT_START_Z))-TARGET_ROTATION_Z)/40.0;
  }

  if(AUTOROTATE_Y){

  ROTATION_Y += 0.05;
  }else{
  ROTATION_Y += (TARGET_ROTATION_Y-ROTATION_Y) / 10.0;
  ROTATION_X += (TARGET_ROTATION_X-ROTATION_X) / 10.0;
  ROTATION_Z += (TARGET_ROTATION_Z-ROTATION_Z) / 10.0;
  }
  background(200);

  pushMatrix();
  translate(width/2,height/2);
  rotateY(ROTATION_Y);
  pushMatrix();
  rotateX(ROTATION_X);
pushMatrix();
  rotateX(ROTATION_Z);


  pushMatrix();
  //translate(-width/2,-height/2);

  stroke(0,190);
  strokeWeight(2);
  noFill();

  box(100);

  for(int i = 0 ; i < traces.size();i++){
    Trace t  = (Trace)traces.get(i);
    t.drawShape();
  }
  popMatrix();
  popMatrix();
  popMatrix();
  popMatrix();
}

////////////////////////////////////////////////

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
      strokeWeight(10.0);
      vertex(tmp.x,tmp.y,tmp.z);
    }
    endShape();


    float x1 = mouseX+width/2;
    float y1 = (cos(ROTATION_X))*(mouseY-height/2);
    float z1 = (sin(ROTATION_X))*(mouseY-height/2);

    float x2 = (cos(ROTATION_Y))*(mouseX-width/2);
    float y2 = mouseY-height/2;
    float z2 = (sin(ROTATION_Y))*(mouseX-width/2);
   
    float x3 = (cos(ROTATION_Z))*(mouseY-width/2);
    float y3 = (sin(ROTATION_Z))*(mouseX-width/2);
    float z3 = (y2+x1)/2.0;

   /* 

    if(writing){
      points.add(new PVector(
            modelX(x1,y1,z1),
            modelY(x2,y2,z2),
            modelZ(x3,y3,z3)
            ));
            */
  /*   
        points.add(new PVector(
            (x1+x2)/2.0,
            (y1+y2)/2.0,
            (z1+z2)/2.0
            ));
*/
        
         //correct Y

      if(writing){
      points.add(new PVector(
            (cos(ROTATION_Y))*(mouseX-width/2),
            mouseY-height/2,
            (sin(ROTATION_Y))*(mouseX-width/2)
            )); 
      }
      
/*

         points.add(new PVector(
         mouseX,
         (cos(ROTATION_X))*(mouseY-width/2),
         (sin(ROTATION_X))*(mouseY-width/2)
         ));
       */
  }

}

////////////////////////////////////////////////
