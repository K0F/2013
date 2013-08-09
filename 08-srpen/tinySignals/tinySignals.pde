/**

Coded by Kof @ 
Sat Aug 10 00:22:46 CEST 2013



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

boolean DRAW_TRAIL = false;
int TRAIL_LENGTH = 20;

int STEP = 5;

float FRICTION = 0.9;
float FORCE = 1;
int INTERVAL = 140;
int INTERVAL_SPREAD = 0;

int TRAIL_ALPHA = 120;

ArrayList signals;

void setup(){
  size(320,320,P2D);

  noSmooth();
  rectMode(CENTER);

  textFont(createFont("Semplice Regular",8,false));

  signals = new ArrayList();
  
  int step = STEP;

  for(int y = step ; y<width-step ; y+=step)
  for(int x = step ; x<height-step ; x+=step)
    signals.add(new Signal(x,y));


  
}

void draw(){

  background(255);

  for(int i = 0 ; i < signals.size();i++){
    Signal s = (Signal)signals.get(i);
    s.draw();
  }

}

/////////////////////////////////////////////

class Signal{

  PVector pos,vel,acc;
  ArrayList trail;

  int cyc ;

  int smery[] = {0,1,2,3,3,2,1,0,1,2,3};
  int dir;

  Signal(int _x, int _y){
    dir = ((int)random(100))%smery.length;

    trail = new ArrayList();
    cyc = (int)random(INTERVAL_SPREAD)+INTERVAL;

    pos = new PVector(_x,_y);
    vel = new PVector(0,0);
    acc = new PVector(0,0);

  }

  Signal(){
    trail = new ArrayList();
    cyc = (int)random(INTERVAL_SPREAD)+INTERVAL;

    pos = new PVector(round(random(width/10))*10.0,round(random(height/10))*10.0);
    vel = new PVector(0,0);
    acc = new PVector(0,0);

  }


  void draw(){

    move();
    border();

    if(DRAW_TRAIL)
    leaveTrail();

    pushMatrix();

    translate(pos.x,pos.y);

    if(frameCount%cyc==0){
      pushMatrix();
      rotate(push() * HALF_PI + HALF_PI);
      stroke(0);
      line(10,-2.5,10,2.5);
      popMatrix();
    }

    fill(0);
    noStroke();



    //text(signals.indexOf(this),0,0);
    rect(0,0,STEP,STEP);
    popMatrix();
  }

  void border(){
    if(pos.x>width)pos.x=pos.x-width;
    if(pos.x<0)pos.x=width+pos.x;
    if(pos.y>height)pos.y=pos.y-height;
    if(pos.y<0)pos.y=height+pos.y;

  }

  void move(){

    pos.add(vel);
    vel.add(acc);

    acc.mult(FRICTION);
    vel.mult(FRICTION);


  }

  int push(){

    int smer = smery[dir++];

    dir = dir%smery.length;

    switch(smer){
      case 0:
        acc = new PVector(0,-1*FORCE); 
        break;
      case 1:
        acc = new PVector(1*FORCE,0); 
        break;
      case 2:
        acc = new PVector(0,1*FORCE); 
        break;
      case 3:
        acc = new PVector(-1*FORCE,0); 
        break;
    }
    return smer;
  }

  void leaveTrail(){

    trail.add(new PVector(pos.x,pos.y));

    if(trail.size() > TRAIL_LENGTH){
      trail.remove(0);
    }

    if(trail.size()>2)
    for(int i = 1 ; i < trail.size();i++){
      stroke(0,map(i,0,trail.size(),0,TRAIL_ALPHA));
      PVector st = (PVector)trail.get(i-1);
      PVector nd = (PVector)trail.get(i);
      
      float d = dist(st.x,st.y,nd.x,nd.y);
      if(d<40 && d > 1)
      line(st.x,st.y,nd.x,nd.y);
    }
  }
}
