BrainP5 brain;

float SMOOTHING = 100.0;

boolean debug = false;

float [][] vals;

float val[];
float maxval = 1;

void setup() {
  size(512,512,P2D);

  val = new float[8];
  vals = new float[8][width];

  for(int i = 0 ; i < val.length;i++)
    val[i] = 0;

  brain = new BrainP5(this, "/dev/rfcomm0");
}

void draw() {
  brain.read();

  int l = 8;
  float w = width / (8.0);

  background(0);

  for(int i = 0 ; i < l;i++){
    maxval = max(maxval,brain.eegPower[i]);    
  }

  maxval *= 0.999;

  for(int i = 0 ; i < l;i++){
    val[i] += (map(brain.eegPower[i],0,maxval,0,-height)-val[i]) / SMOOTHING;


    vals[i][frameCount%(width-1)] = val[i];

    if(debug)
      print(val[i]+",");
    noStroke();
    fill(255,127,0,70);
    rect(w*i,height,w,val[i]);

  }

  noFill();
  stroke(255,120);
  for(int i = 0 ; i < l;i++){
    beginShape();
    for(int q = 0 ; q < vals[i].length;q++){
      vertex(q,-vals[i][q]);
    }
    endShape();
  }
  if(debug)
    println();
}

