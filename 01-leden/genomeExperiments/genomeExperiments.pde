
float ATT_FORCE = 2.5;
float FRICTION =  0.0;//006;
float FOLLOW_SPEED = 30.0;

int num = 16;
int TRAIL_LEN = 190;
int SKIP = 1;


ArrayList nodes;
PVector c, sc;

void setup() {
  size(800, 800, P2D);

  smooth();

  nodes = new ArrayList();

  c = new PVector(width/2, height/2);
  sc = new PVector(width/2, height/2);


  for (int i = 0 ; i < num;i ++) {
    nodes.add(new Node());
  }
}



void draw() {
  background( 0 );

  sc.x += (c.x-sc.x) / FOLLOW_SPEED;
  sc.y += (c.y-sc.y) / FOLLOW_SPEED;

  pushMatrix();
  translate(-sc.x+width/2, -sc.y+height/2);

  for (int i = 0 ; i < nodes.size();i++) {
    Node n = (Node)nodes.get(i);
    n.draw();
  }

  noFill();
  beginShape();
  Node zero = (Node)nodes.get(0);
  for (int i = 0 ; i < zero.trail.size();i += SKIP) {
    for (int q = 0 ; q < nodes.size();q++) {
      Node n1  = (Node)nodes.get(q);
      Node n2  = (Node)nodes.get(q);

      PVector t1 = (PVector)n1.trail.get(i);
      PVector t2 = (PVector)n2.trail.get(i);

      stroke(255, map(i, 0, zero.trail.size(), 0, 40));


      curveVertex(t1.x, t1.y);//,t2.x,t2.y);
    }
  }
  endShape();

  popMatrix();
}

class Node {
  PVector pos, acc, vel;
  float R = 5.0;
  ArrayList trail;

  Node() {
    trail = new ArrayList();
    pos = new PVector(random(width), random(height));
    vel = new PVector(0, 0);
    acc = new PVector(random(-1, 1), random(-1, 1));
  }

  void move() { 
    pos.add(vel);
    vel.add(acc);
    vel.mult(1.0/(FRICTION+1.0));

    acc = new PVector();

    for (int i = 0 ; i < nodes.size();i++) {
      if (i!=nodes.indexOf(this)) {
        Node other = (Node)nodes.get(i);
        float d = 1.0+dist(pos.x, pos.y, other.pos.x, other.pos.y);
        PVector dir = new PVector(other.pos.x-pos.x, other.pos.y-pos.y);
        dir.normalize();
        dir.mult(ATT_FORCE / pow(d, 0.95));


        acc.add(dir);
      }
    }
  }





  void draw() {
    move();

    fill(255, 90);
    stroke(255, 200);
    pushMatrix();
    translate(pos.x, pos.y);
    // ellipse(0, 0, R, R);
    popMatrix();


    PVector dir = new PVector(pos.x-c.x, pos.y-c.y);
    dir.normalize();
    dir.mult(1.0+1/(nodes.size()-1.0));
    c.add(dir);

    trail.add(new PVector(pos.x, pos.y));

    if (trail.size()>TRAIL_LEN) {
      for (int i = 0 ; i < SKIP;i++)
        trail.remove(0);
    }

    stroke(255, 45);
    for (int i = 1 ; i < trail.size();i+=SKIP) {
      PVector one = (PVector)trail.get(i-1);
      PVector two = (PVector)trail.get(i);
      stroke(255, map(i, 1, trail.size(), 0, 90));
      line(one.x, one.y, two.x, two.y);
    }
  }
}

