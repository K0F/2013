float FRICTION = 1.0;

boolean DEBUG = true;

Me me;

void setup(){

  size(800,600,P2D);

  me = new Me();
}

void draw(){

  background(0);


  fill(255,25);
  stroke(255,100);

  me.draw();



}

void mousePressed(){

  me.push();
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

    if(pos.x+radi/2>height || pos.y-radi/2<0)
      vel.y *= -1.0;


  }

  void move(){
    vel.add(acc);
    pos.add(vel);

    vel.mult(FRICTION);
    acc.mult(0);
  }
}
