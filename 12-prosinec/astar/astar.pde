
ArrayList units;

int NUM = 10;
float GRID = 10.0;
int TRACE = 1000;
float SPEED = 1.0;

float RADI = 100.0;

void setup(){

  size(512,320,P3D);

  units = new ArrayList();

  for(int i = 0 ; i < NUM;i++)
    units.add(new Unit());

  noSmooth();
  ortho();

  rectMode(CENTER);


}

void draw(){
  background(255);

  pushMatrix();
  translate(width/2,height/2,0);
  rotateX(radians(30));
  rotateZ(radians(45));

  fill(255);
  stroke(0,120);
  for(int y = -width/2;y<=width/2;y+=GRID){
    for(int x = -height/2;x<=height/2;x+=GRID){

      pushMatrix();
      translate(0,0,noise(x/100.0,y/100.0)*100.0);
      rect(x,y,GRID,GRID);
      popMatrix();
    }
  }

  for(int i =0 ; i < units.size();i++){
    Unit tmp = (Unit)units.get(i);
    tmp.draw();
  }

  popMatrix();

}

class Unit{
  PVector pos,dir,vel;
  ArrayList trace;
  float speed = 10.0;

  Unit(){
    pos = new PVector(0,0,0);
    dir = new PVector(random(10)/10.0,random(10)/10.0,0);
    vel = new PVector(0,0,0);

    trace = new ArrayList();
  }

  void draw(){
  fill(255,0,0);

    pushMatrix();
    translate(pos.x,pos.y,pos.z);
    rotateZ(atan2(dir.y,dir.x));
    translate(0,0,GRID);
    box(GRID,GRID,GRID*2.0);
    popMatrix();

    drawTrace();

    move();
  }

  void drawTrace(){
    trace.add(pos.get());

    if(trace.size()>TRACE){
      trace.remove(0);
    }

    noFill();
    
    beginShape();
    for(int i = 0;i<trace.size();i++){
      PVector t = (PVector)trace.get(i);
      vertex(t.x,t.y,t.z);
    }
    endShape();

  }

  void move(){
    pos.z = noise(pos.x/100.0,pos.y/100.0)*100.0;
    speed = noise(frameCount/100.0+units.indexOf(this))*SPEED;
    dir = new PVector(cos(frameCount/RADI),sin(frameCount/RADI));
    pos.add(vel);
    vel.add(dir);
    vel.normalize();
    vel.mult(speed);
  }
}
