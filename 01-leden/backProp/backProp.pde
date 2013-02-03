ArrayList neurons;

int inputNum = 3;
int outputNum = 2;
int layNum = 3;
int nPerLayer = 10;

void setup(){
  size(400,400,P2D);
  createNetwork();
}

void createNetwork(){
  neurons = new ArrayList();

  for(int i = 0 ; i < inputNum;i++){
    neurons.add(new Neuron());
  }

  for(int i = 0 ; i < layNum ;i++){
    for(int ii = 0 ; ii < nPerLayer ;ii++){
      neurons.add(new Neuron(i));
    }  
  }

}


void draw(){
  background(0);

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

    inputs = getPreviousLayeNeurons();

    weights = new ArrayList();
    for(int i = 0; i < inputs.size();i++)
      weights.add(random(0,10)/10.0);

  }

  ArrayList getPreviousLayeNeurons(){
    ArrayList seek = new ArrayList();
    for(int i = 0 ; i < neurons.size();i++){
      Neuron n = (Neuron)neurons.get(i);
      if(n.layer==layer-1);
      seek.add(n);
    }
    return seek;
  }

}
