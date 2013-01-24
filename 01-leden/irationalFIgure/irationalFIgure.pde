ArrayList e;
int num = 3000;

float SLOW_DOWN = 0.15;

void setup(){
  size(1600,900,P2D);

  e = new ArrayList();
  for(int i = 0 ; i < num;i++)
    e.add(new Entity());
}


void draw(){
  background(0);

  for(int i = 0 ; i < e.size();i++){
    Entity tmp = (Entity)e.get(i);
    tmp.move();
    tmp.draw();
  }


}

class Entity{
  PVector pos,acc,vel;

  Entity(){
    pos = new PVector(random(width),random(height));
    acc = new PVector(0,0);
    vel = new PVector(0,0);
  }

  void move(){
    pos.add(vel);
    vel.add(acc);
    acc.add(new PVector(random(-1,1),random(-1,1)));
    acc.mult(SLOW_DOWN);
    vel.mult(0.98);

    border();
  }

  void border(){
    if(pos.x>width){pos.x=0;}
    if(pos.x<0){pos.x=width;}
    if(pos.y>height){pos.y=0;}
    if(pos.y<0){pos.y=height;}
  }

  void draw(){
    stroke(255);
    point(pos.x,pos.y);

  }
}
