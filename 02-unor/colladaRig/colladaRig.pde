boolean DEBUG  = true;

Collada test;
ArrayList bones;

float S = 1.0;
int ALPHA = 80;
int TRAIL_LENGTH = 10;
int TRAIL_ALPHA = 255;

float SCALE = 10.0;

void setup(){
  size(800,600,P3D);

  bones = new ArrayList();

  noSmooth();
  test = new Collada("test.dae");

  strokeWeight(2);
}

void draw(){
  background(0);

  pushMatrix();
  translate(width/2,height/2);
  scale(SCALE,SCALE,SCALE);
  pointLight(255,255,255,-5,-5,5);
  rotateX(HALF_PI);
  rotateZ(radians(frameCount/7.0));
  noStroke();
  fill(255,127,12);

  hint(ENABLE_DEPTH_TEST);
  if(test!=null)
    test.drawFaces();
  hint(DISABLE_DEPTH_TEST);
  if(bones.size()>0){
    for(int i = 0; i < bones.size();i++){
      Bone b = (Bone)bones.get(i);
      b.draw();
    }

  }

  popMatrix();
}


