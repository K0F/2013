float FRICTION = 1.0;

float MNR = 50;
float MXR = 150;


boolean DEBUG = true;

int INIT_NUM = 10;

Me me;
ArrayList bubs;
Interaction interaction;

void setup(){

  size(800,600,P2D);

  me = new Me();

  bubs = new ArrayList();

  for(int i = 0 ; i < INIT_NUM;i++)
    bubs.add(new Ob());

  interaction = new Interaction();
}

void draw(){

  background(0);


  fill(255,25);
  stroke(255,100);

  interaction.solve();

  for(int i = 0 ; i < bubs.size();i++){
    Ob tmp = (Ob)bubs.get(i);
    tmp.draw();
  }


  me.draw();



}

void mousePressed(){

  me.push();
}

class Interaction{

  void solve(){


    for(int i = 0 ; i < bubs.size();i++){
      Ob one = (Ob)bubs.get(i);
      for(int ii = 0 ; ii < bubs.size();ii++){
        if(i!=ii){
          Ob two = (Ob)bubs.get(ii);
          float d = dist(one.pos.x,one.pos.y,two.pos.x,two.pos.y);
          if(d < one.radi/2.0 + two.radi/2.0){
            one.radi = d-(one.radi/2.0-two.radi/2.0);  
          }
        }
      }
    }
  }

}

class Me{

  float radi = 100;
  PVector acc,vel,pos;

  Me(){
    pos = new PVector(width/2,height/2);
    vel = new PVector(0,0);
    acc = new PVector(0,0);

  }

  void push(){

    PVector dir = new PVector(pos.x-mouseX,pos.y-mouseY);
    dir.normalize();
    acc.add(dir);
  }

  void draw(){
    move();
    bounce();
    pushMatrix();
    translate(pos.x,pos.y);
    ellipse(0,0,radi,radi);
    popMatrix();

    if(DEBUG){
      line(mouseX,mouseY,pos.x,pos.y);
    }
  }

  void bounce(){
    if(pos.x+radi/2>width || pos.x-radi/2<0)
      vel.x *= -1.0;

    if(pos.y+radi/2>height || pos.y-radi/2<0)
      vel.y *= -1.0;


  }

  void move(){
    vel.add(acc);
    pos.add(vel);

    vel.mult(FRICTION);
    acc.mult(0);
  }
}

class Ob extends Me{
  Ob(){
    super();

    radi = random(MNR,MXR);

    pos = new PVector(random(radi/2,width-radi/2),random(radi/2,height-radi/2));
    vel = new PVector(random(-2,2),random(-2,2));
  }
}
