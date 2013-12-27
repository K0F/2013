import org.puredata.processing.PureData;
PureData pd;

boolean bang;
float SEQ = 30;
float fade;

void setup(){

  size(800,600,P2D);
  pd = new PureData(this, 44100, 0, 2);

  pd.openPatch("test.pd");
  pd.start();

}

void draw() {

  if(fade < 0){
    bang = true;
    fade = SEQ;
  }

  fade-=1;

  pd.sendFloat("volume", 0.75);
  background(0);
  fill(200, 0, 0);
  stroke(255, 0, 0);
  ellipseMode(CENTER);
  rectMode(CENTER);

  noStroke();

  float p = noise(frameCount/100.0)*22+66;
  pd.sendFloat("p", p); // Send float message to symbol "pitch" in Pd.
  fill(255,map(fade,0,SEQ,0,255));
  rect(width/2, height/2.0, 200, 200);

  if(bang){
    pd.sendBang("bng");
    bang = false;
  }

}

