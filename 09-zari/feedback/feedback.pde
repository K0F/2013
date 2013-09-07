
/////////////////////////////////////////////////


ArrayList neurons;
int NUM = 100;

/////////////////////////////////////////////////


void setup(){
  size(400,400,P2D);

  generateNew();
}

void draw(){

  background(255);


  for(int i = 0 ; i < neurons.size() ; i++){
    Neuron n = (Neuron)neurons.get(i);
    n.update();
  }

  float step = height / (neurons.size()+0.0);

  for(int i = 0 ; i < neurons.size() ; i++){
    Neuron n = (Neuron)neurons.get(i);
    n.draw();
    n.tail();
  }

}

/////////////////////////////////////////////////

void generateNew(){
  neurons = new ArrayList();

  for(int i = 0 ; i < NUM ; i ++){
    neurons.add(new Neuron(i));
  }

  for(int i = 0 ; i < neurons.size();i++){
    Neuron n = (Neuron)neurons.get(i);
    n.connect();
  }


}

/////////////////////////////////////////////////


class Neuron{
  ArrayList tail;
  int id;
  float val;
  float treshold;
  PVector pos;

  boolean active;
  ArrayList conns;

  Neuron(int _id){
    active = true;
    id = _id;
    pos = new PVector(random(width),random(height));
    val = 0.9;
    treshold = 0.5;
    tail = new ArrayList();
  }


  void connect(){

    conns = new ArrayList();

    for(int i = 0 ; i < neurons.size();i++){
      Neuron n = (Neuron)neurons.get(i);
      if(n!=this)
        conns.add(new Connection(this,n));
    }
  }

  float getVal(){
    float sum = 0;
    int cnt = 0;
    for(int i = 0 ; i < conns.size();i++){
      Connection c = (Connection)conns.get(i);
      if(c.b.active){
        sum += val*c.w;
        cnt++;
      }
    }
    sum /= (cnt+0.0);

    return sum;
  }

  void tail(){
    tail.add(val);

    if(tail.size()>width){
      tail.remove(0);
    }

    stroke(0,12);
    for(int i = 1 ; i < tail.size();i++){
      float af = height-(Float)tail.get(i-1)*height/2;
      float bf = height-(Float)tail.get(i)*height/2;
      line(i-1,af,i,bf);
    }

  }

  void update(){
    val += (getVal()-val)/10.0;

    active = (val >= treshold) ? true : false; 

    move();
  }

  void move(){
    //if(active)
    for(int i = 0 ; i < conns.size();i++){
      Connection c = (Connection)conns.get(i);
      if(c.b.active){
        if(c.d > 100+(val*10.0)){
          pos.x += (c.b.pos.x-pos.x)/(c.d*10.0);
          pos.y += (c.b.pos.y-pos.y)/(c.d*10.0);
        }
      }

      pos.x += random(-1,1)/100.0; 
      pos.y += random(-1,1)/100.0; 
    }

  }

  void draw(){

    if(active)
      drawConnections();

    fill(#ff0000,val*127);
    noStroke();
    rectMode(CENTER);
    rect(pos.x,pos.y,5,5);

    if(val>2)
      val*=0.99;


  }

  void drawConnections(){
    for(int i = 0; i < conns.size();i++){
      Connection c = (Connection)conns.get(i);
      c.draw();
    }
  }

}

/////////////////////////////////////////////////


class Connection{
  Neuron a,b;
  float w,d;

  Connection(Neuron _a, Neuron _b){
    a=_a;
    b=_b;
    w = random(0,200)/100.0;
  }

  void draw(){
    stroke(0,3*w);

    d = dist(a.pos.x,a.pos.y,b.pos.x,b.pos.y);
    line(a.pos.x,a.pos.y,b.pos.x,b.pos.y);

  }

}
