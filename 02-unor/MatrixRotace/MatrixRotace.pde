/*
 * Generic Vertebrate
 * Krystof & Jachym Pesek
 * 2013
 */


int num = 40;

float SPREAD = 0.033;
float SPEED = 150.0;
float ANGLE = 60.0;

int NUM_SEGMENTS = 16;

boolean APPLIED = true;

boolean NOISED = false;

int TRAIL_LENGTH = 200;
int TRAIL_ALPHA = 50;

float ALPHA = 80;

float W = 20;
float S = 10;
float L = 20;
float V = 50;

float SCALE = 0.65;

ArrayList bones;
PMatrix3D clean;

PVector target = new PVector(0,0,L);

PImage texture;

void setup(){
  size(800,600,P3D);

  texture = loadImage("texture.png");
  textureMode(NORMAL);

  clean = new PMatrix3D(
      1,0,0,0,
      0,1,0,0,
      0,0,1,0,
      0,0,0,1
      );

  printMatrix();


  bones = new ArrayList();
  Rovina first = new Rovina(clean);
  bones.add(first);

  for(int i = 0 ; i < num; i ++){
    Rovina previous = (Rovina)bones.get(bones.size()-1);
    bones.add(new Rovina(clean,previous));

  }

  strokeWeight(1);

  smooth();
}



void draw(){
  background(0);

  // set rotations per bone
  for(int i = 0 ; i < bones.size();i++){
    Rovina r = (Rovina)bones.get(i);
    r.rotate(
        (noise(i*SPREAD+frameCount/SPEED,0,0)-0.5)*ANGLE,
        (noise(0,i*SPREAD+frameCount/SPEED,0)-0.5)*ANGLE,
        (noise(0,0,i*SPREAD+frameCount/SPEED)-0.5)*ANGLE
        );
  }


  // set coordinates of world 
  pushMatrix();
  translate(width/2,height/2,0);
  scale(SCALE);
  rotateX(QUARTER_PI);
  rotateZ(QUARTER_PI+frameCount/300.0);

  lights();

  // apply 
  for(int i = 0 ; i < bones.size();i++){
    Rovina r = (Rovina)bones.get(i);
    r.updateVertices();
  }

  noStroke();
  fill(127);

  hint(ENABLE_DEPTH_TEST);

  // draw geom hits here 
  for(int i = 0 ; i < bones.size();i++){
    Rovina r = (Rovina)bones.get(i);
    r.drawTrail();
  }


  for(int b = 1 ; b < bones.size();b++){
    Rovina r1 = (Rovina)bones.get(b-1);
    ArrayList verts1 = r1.vertices;
    Rovina r2 = (Rovina)bones.get(b);
    ArrayList verts2 = r2.vertices;

    PVector vert1[] = new PVector[r1.vertices.size()];
    PVector vert2[] = new PVector[r2.vertices.size()];




    if(vert1.length==vert2.length){

      for(int i = 0 ; i < vert1.length;i++){
        vert1[i] = (PVector)r1.vertices.get(i);
        vert2[i] = (PVector)r2.vertices.get(i);
      }

      for(int i = 1 ; i < vert1.length + 1; i += 1){
        PVector v1 = vert1[i-1];
        PVector v2 = vert1[i%vert1.length];
        PVector v3 = vert2[i%vert1.length];
        PVector v4 = vert2[i-1];

        float Us = (float)(vert1.length);
        float Vs = (float)bones.size();

        noStroke();
        beginShape();
        texture(texture);
        vertex(v1.x,v1.y,v1.z,(i-1)/Us,(b-1)/Vs);
        vertex(v2.x,v2.y,v2.z,(i)/Us,(b-1)/Vs);
        vertex(v3.x,v3.y,v3.z,(i)/Us,(b)/Vs);
        vertex(v4.x,v4.y,v4.z,(i-1)/Us,(b)/Vs);
        endShape(CLOSE);
      }

    }
  }



  hint(DISABLE_DEPTH_TEST);

  // draw geom hits here 
  for(int i = 0 ; i < bones.size();i++){
    Rovina r = (Rovina)bones.get(i);
    r.draw();
  }

  popMatrix();
}


class Rovina{
  ArrayList vertices;

  ArrayList trail;
  PVector x,y,z;
  PMatrix3D matrix,base;

  Rovina parent;

  PVector relPoint;
  PVector origin;


  Rovina(PMatrix3D _mat){
    initialize(_mat);
    trail = new ArrayList();
  }


  Rovina(PMatrix3D _mat,Rovina _parent){
    parent = _parent;
    initialize(_mat);
    trail = new ArrayList();

    base.m03 = target.x;
    base.m13 = target.y;
    base.m23 = target.z;
    updateVertices();
  }

  void initialize(PMatrix _mat){
    matrix = new PMatrix3D(_mat);
    base = new PMatrix3D(_mat);

    origin = absolutePoint(0,0,0);
    relPoint = absolutePoint(target.x,target.y,target.z);
    updateVertices();
  }

  void updateVertices(){
    if(parent!=null)
      inherit();

    origin  = absolutePoint(0,0,0);
    relPoint = absolutePoint(target.x,target.y,target.z);

    vertices = new ArrayList();

    float step = radians(360.0/(NUM_SEGMENTS+0.0));

    for(float f = 0 ; f < radians(360) ; f += step){
      if(NOISED){
        float shiftX = (noise(f/radians(360),bones.indexOf(this)/10.0+frameCount/80.0))*4.0;
        float shiftY = (noise(bones.indexOf(this)/10.0+frameCount/80.0,f/radians(360)))*4.0;
        vertices.add(absolutePoint(
              cos(f)*V*shiftX,
              sin(f)*V*shiftY,
              0));
      }else{
        vertices.add(absolutePoint(
              cos(f)*V,
              sin(f)*V,
              0));

      }

    }
  }

  PVector relativePoint(float _x,float _y, float _z){
    PVector pt = new PVector(_x,_y,_z);
    PMatrix3D nn = new PMatrix3D(matrix);
    nn.invert();
    nn.mult(pt,pt);

    return pt;
  }

  PVector absolutePoint(float _x,float _y, float _z){
    PVector pt = new PVector(_x,_y,_z);
    PMatrix3D nn = new PMatrix3D(matrix);
    nn.mult(pt,pt);

    return pt;
  }
  void inherit(){
    matrix.preApply(parent.matrix);//new PMatrix3D(base);
  }

  void rotate(float _x, float _y, float _z){
    float radx = radians(_x);
    float rady = radians(_y);
    float radz = radians(_z);

    float ca = cos(radx);
    float sa = sin(radx);

    float cb = cos(rady);
    float sb = sin(rady);

    float cg = cos(radz);
    float sg = sin(radz);

    float[] mat = new float[16];
    matrix = new PMatrix3D(base);
    matrix.get(mat);

    // working X,Y,Z arbitrary solution
    matrix = new PMatrix3D(
        cb*cg,cg*sa*sb-ca*sg,ca*cg*sb+sa*sg,mat[3],
        cb*sg,ca*cg+sa*sb*sg,-cg*sa+ca*sb*sg,mat[7],
        -sb,cb*sa,ca*cb,mat[11],
        mat[12],mat[13],mat[14],mat[15]
        );
  }

  void draw(){


    if(APPLIED){

      pushMatrix();
      origin = new PVector(0,0,0);
      relPoint = new PVector(target.x,target.y,target.z);
      applyMatrix(matrix);

      noFill();
      stroke(255,ALPHA);
      rectMode(CENTER);



      strokeWeight(1);

      rect(0,0,W,W);

      stroke(#ff0000,ALPHA);
      line(0,0,0,W/2,0,0);

      stroke(#00ff00,ALPHA);
      line(0,0,0,0,W/2,0);

      stroke(#0000ff,ALPHA);
      line(0,0,0,0,0,W/2);

      popMatrix();

      origin = absolutePoint(0,0,0);
      relPoint = absolutePoint(target.x,target.y,target.z);
      strokeWeight(2);

      stroke(#ff0000,ALPHA);
      line(relPoint.x-S,relPoint.y,relPoint.z,relPoint.x+S,relPoint.y,relPoint.z);
      stroke(#00ff00,ALPHA);
      line(relPoint.x,relPoint.y-S,relPoint.z,relPoint.x,relPoint.y+S,relPoint.z);
      stroke(#0000ff,ALPHA);
      line(relPoint.x,relPoint.y,relPoint.z-S,relPoint.x,relPoint.y,relPoint.z+S);

      strokeWeight(10);
      stroke(#ffff00,ALPHA);
      line(origin.x,origin.y,origin.z,relPoint.x,relPoint.y,relPoint.z);

      addTrail();

    }
  }
  void addTrail(){

    trail.add(new PVector(relPoint.x,relPoint.y,relPoint.z));
    if(trail.size()>TRAIL_LENGTH)
      trail.remove(0);


  }

  void drawTrail(){
    strokeWeight(1);
    if(trail.size()>=1)
      for(int i = 1 ; i < trail.size();i+=1){
        PVector t1 = (PVector)trail.get(i-1);
        PVector t2 = (PVector)trail.get(i);
        stroke(255,map(i,0,trail.size(),0,TRAIL_ALPHA));
        line(t1.x,t1.y,t1.z,t2.x,t2.y,t2.z);
      }


  }


}



