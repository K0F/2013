ArrayList taos;
/////////////////////////////////////////////////////////////////////

int NUM = 100;


float SLOWDOWN = 0.0;
int MIN_TIME = 20;
int MAX_TIME = 200;
int TRAIL_LEN = 1000;
/////////////////////////////////////////////////////////////////////


void setup(){
  size(800,600,P2D);
  textFont(createFont("Monaco",9,false));
  taos = new ArrayList();

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
  int w = 10;

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
    rect(pos.x,pos.y,w,w);
    text(nf(seed,6),pos.x,pos.y);

    for(int i = 1 ; i < trail.size();i++){
      PVector tmp1 = (PVector)trail.get(i);
      PVector tmp2 = (PVector)trail.get(i);

      stroke(255,145);
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
    seed = (int)random(100000,999999);
    String tmp = ""+nf(seed,6);
    int X = parseInt(tmp.substring(0,2));
    int Y = parseInt(tmp.substring(3,5));

    float mod1 = random(100)>50?-1:1;
    float mod2 = random(100)>50?-1:1;

    PVector result = new PVector(X*mod1,Y*mod2);
    result.normalize();

    return result;
  }
  /////////////////////////////////////////////////////////////////////


}
