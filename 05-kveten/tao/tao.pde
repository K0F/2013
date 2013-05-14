/*
Coded by Kof @ 
Tue May 14 14:44:09 CEST 2013



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


ArrayList taos;
/////////////////////////////////////////////////////////////////////

int NUM = 10;
int SEED_COUNT = 3;

float SLOWDOWN = 0.5;
int MIN_TIME = 2;
int MAX_TIME = 200;
int TRAIL_LEN = 200;

ArrayList SEEDS;
/////////////////////////////////////////////////////////////////////


void setup(){
  size(640,384,P2D);
  textFont(createFont("Monaco",9,false));
  taos = new ArrayList();

  SEEDS = new ArrayList();
  for(int i = 0 ; i < NUM ; i++){
    int mod1 = random(100)>50?-1:1;

    SEEDS.add((int)random(100000,999999)*mod1);
  
  }
  for(int i = 0 ; i < NUM ; i++)
    taos.add(new Taoid());

  rectMode(CENTER);
}


void draw(){
  background(0);

  for(int i = 0 ; i < taos.size(); i++){
    Taoid t = (Taoid)taos.get(i);
    t.draw();

  }
}
/////////////////////////////////////////////////////////////////////

class Taoid{
  int seed;
  int w = 3;

  ArrayList trail;
  int cycle;

  PVector pos,vel,acc,dir;

  Taoid(){

    trail = new ArrayList();

    cycle = (int)random(MIN_TIME,MAX_TIME);

    pos = new PVector(random(width),random(height));
    vel = new PVector(0,0);
    acc = new PVector(0,0);

    dir = getVector();
  }
  /////////////////////////////////////////////////////////////////////

  void draw(){
    move();

    noStroke();
    rect(pos.x,pos.y,w,w);
    text(nf(seed,6),pos.x,pos.y);

    stroke(255,35);

    for(int i = 1 ; i < trail.size();i++){
      PVector tmp1 = (PVector)trail.get(i-1);
      PVector tmp2 = (PVector)trail.get(i);

      if(dist(tmp1.x,tmp1.y,tmp2.x,tmp2.y)<100)
        line(tmp1.x,tmp1.y,tmp2.x,tmp2.y);
    }

  }
  /////////////////////////////////////////////////////////////////////

  void move(){

    if(frameCount%cycle==0)
      dir = getVector();




    acc.add(dir);
    vel.add(acc);
    pos.add(vel);

    border();

    acc.mult(SLOWDOWN);
    vel.mult(SLOWDOWN);

    trail.add(new PVector(pos.x,pos.y));

    if(trail.size()>TRAIL_LEN)
      trail.remove(0);

  }
  /////////////////////////////////////////////////////////////////////

  void border(){
    if(pos.x>width)pos.x=0;
    if(pos.x<0)pos.x=width;
    if(pos.y>height)pos.y=0;
    if(pos.y<0)pos.y=height;
  }

  PVector getVector(){
    seed = (Integer)SEEDS.get((int)random(SEEDS.size()));
    String tmp = ""+nf(seed,6);
    int X = parseInt(tmp.substring(0,2));
    int Y = parseInt(tmp.substring(3,5));

      PVector result = new PVector(X,Y);
    result.mult(0.01);

    return result;
  }
  /////////////////////////////////////////////////////////////////////


}
