ArrayList neurons;

Neuron i1,i2,i3;
Neuron o1,o2;

int inputNum = 3;
int outputNum = 2;
int layNum = 3;
int nPerLayer = 10;

void setup(){
  size(400,400,P2D);
  rectMode(CENTER);

  createNetwork();
}

void createNetwork(){
  neurons = new ArrayList();

  i1 = new Neuron();
  i2 = new Neuron();
  i3 = new Neuron();


  neurons.add(i1);
  neurons.add(i2);
  neurons.add(i3);

  for(int i = 0 ; i < layNum ;i++){
    for(int ii = 0 ; ii < nPerLayer ;ii++){
      neurons.add(new Neuron(i));
    }  
  }

  o1 = new Neuron(layNum+2);
  o2 = new Neuron(layNum+2);

  neurons.add(o1);
  neurons.add(o2);



}


void draw(){
  background(0);

  i1.sum = noise(frameCount/10.0);
  i2.sum = noise(frameCount/100.0);
  i3.sum = noise(frameCount/1000.0);


  for(int i = 3 ; i < neurons.size();i++){
    Neuron tmp = (Neuron)neurons.get(i);
    tmp.compute();
  }

  float siz = 10;

  for(int i = 3 ; i < neurons.size();i++){
    Neuron tmp = (Neuron)neurons.get(i);
    float x = (neurons.indexOf(tmp) % 10) * siz ;
    float y = tmp.layer*siz;

    pushMatrix();
    noStroke();
    translate(x,y);
    fill(tmp.sum*255);
    rect(0,0,siz/2,siz/2);
    popMatrix();
  }

}

class Neuron{
  ArrayList inputs,weights;
  int layer;
  float sum;

  Neuron(){
    layer = 0;
    sum = 0;
    inputs = null;
    weights = null;
  }

  Neuron(int _layer){
    layer = _layer;
    sum = 0;

    inputs = getPreviousLayerNeurons();

    weights = new ArrayList();
    for(int i = 0; i < inputs.size();i++)
      weights.add(random(0,10)/10.0);
  }

  float sum(){
    float result = 0;
    for(int i = 0 ; i < inputs.size();i++){
      Neuron n = (Neuron)inputs.get(i);
      float w = (Float)weights.get(i);
      result += n.sum*w;
    }
    return result;
  }

  void compute(){
    sum = sum();
  }

  ArrayList getPreviousLayerNeurons(){
    ArrayList seek = new ArrayList();
    for(int i = 0 ; i < neurons.size();i++){
      Neuron n = (Neuron)neurons.get(i);
      if(n.layer==layer-1);
      seek.add(n);
    }
    return seek;
  }
}
