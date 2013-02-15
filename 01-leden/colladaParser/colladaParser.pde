boolean DEBUG  = true;


Collada test;
Armature armature;
ArrayList bones;

float SCALE = 30.0;
Runnable runnable;
Thread thread;

PShape zzz;

void setup(){
  size(800,600,OPENGL);

  bones = new ArrayList();
  
  noSmooth();
  runnable = new Collada("test3.dae");
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
  noStroke();//stroke(0);
  fill(255,127,12);

  //shape(zzz,0,0);
  if(test!=null)
    test.drawFaces();
  //test = new Collada("test2.dae");
  //

  if(armature!=null){
    armature.plot();
  }

  if(bones.size()>0){
      pushMatrix();
    for(int i = 0; i < bones.size();i++){
      Bone b = (Bone)bones.get(i);
      applyMatrix(b.matrix);
      box(0.33);

    }

      popMatrix();
  }

  popMatrix();
}


