boolean DEBUG  = true;

Collada test;
Armature armature;
ArrayList bones;

float SCALE = 30.0;
Runnable runnable;
Thread thread;

PShape zzz;

void setup(){
  size(800,600,P3D);

  bones = new ArrayList();

  noSmooth();
  runnable = new Collada("test.dae");
  thread = new Thread(runnable);
  thread.start();
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

  if(armature!=null){
    armature.plot();
  }

  if(bones.size()>0){
    for(int i = 0; i < bones.size();i++){
      Bone b = (Bone)bones.get(i);
      b.plot();
    }

  }

  popMatrix();
}


