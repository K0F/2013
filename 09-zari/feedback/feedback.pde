
ArrayList neurons;
int NUM = 100;

void setup(){
  size(400,400);
}

void draw(){

  background(255);


  for(int i = 0 ; i < neurons.size();i++){
    Neuron n = (Neuron)neurons.get(i);
    n.draw();
  }


}


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

class Neuron{
  int id;
  PVector pos;

  boolean active;
  ArrayList conns;

  Neuron(int _id){
    active = true;
    id = _id;
    pos = new PVector(random(width),random(height));
  }


  void connect(){

    conns = new ArrayList();

    for(int i = 0 ; i < neurons.size();i++){
      Neuron n = (Neuron)neurons.get(i);
      if(n!=this)
        conns.add(new Connection(this,n));
    }
  }

  void draw(){
    
    fill(0);
    noStroke();
    rectMode(CENTER);
    rect(pos.x,pos.y,5,5);
  
  }

}

class Connection{
  Neuron a,b;
  float w;

  Connection(Neuron _a, Neuron _b){
    a=_a;
    b=_b;
    w = random(0,100)/100.0;
  }

}
