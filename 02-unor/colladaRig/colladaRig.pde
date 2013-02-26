boolean DEBUG  = true;

Collada test;
ArrayList bones;

float S = 1.0;
int TRAIL_LENGTH = 10;
int TRAIL_ALPHA = 10;

float SCALE = 30.0;

void setup(){
  size(800,600,P3D);

  bones = new ArrayList();

  noSmooth();
  test = new Collada("test.dae");
}

void draw(){
  background(255);

  pushMatrix();
  translate(width/2,height/2);
  scale(SCALE,SCALE,SCALE);
  pointLight(255,255,255,-5,-5,5);
  rotateX(HALF_PI);
  rotateZ(radians(frameCount/7.0));
  noStroke();
  fill(255,127,12);

  if(test!=null)
    test.drawFaces();

  if(bones.size()>0){
    for(int i = 0; i < bones.size();i++){
      Bone b = (Bone)bones.get(i);
      b.draw();
    }

  }

  popMatrix();
}


