
int num = 4;

float SPREAD = 10.0;
float SPEED = 100.0;
float ANGLE = 90.0;

boolean APPLIED = true;

float W = 40;
float S = 10;
float L = 40;
float V = 50;

ArrayList bones;
PMatrix3D clean;

PVector target = new PVector(0,0,L);

void setup(){
  size(800,600,P3D);

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

  strokeWeight(2);

  smooth();
}



void draw(){
  background(0);
  /*
     p.rotateX(noise(frameCount/200.0,0,0)*90.0);
     p.rotateY(noise(0,frameCount/200.0,0)*90.0);
     p.rotateZ(noise(0,0,frameCount/200.0)*90.0);
   */
 
 for(int i = 0 ; i < bones.size();i++){
    Rovina r = (Rovina)bones.get(i);
     r.rotate(
     (noise(i*SPREAD+frameCount/SPEED,0,0)-0.5)*ANGLE,
     (noise(0,i*SPREAD+frameCount/SPEED,0)-0.5)*ANGLE,
     (noise(0,0,i*SPREAD+frameCount/SPEED)-0.5)*ANGLE
     );
  }

 
  
  pushMatrix();
  translate(width/2,height/2,0);
  rotateX(QUARTER_PI);
  rotateZ(QUARTER_PI);

  for(int i = 0 ; i < bones.size();i++){
    Rovina r = (Rovina)bones.get(i);
    r.draw();
  }

  noStroke();
  fill(127);

  for(int i = 1 ; i < bones.size();i++){
    Rovina r1 = (Rovina)bones.get(i-1);
    ArrayList verts1 = r1.vertices;
    Rovina r2 = (Rovina)bones.get(i);
    ArrayList verts2 = r2.vertices;

    PVector v00,v01,v02,v03,v10,v11,v12,v13;

    v00 = (PVector)verts1.get(0);
    v01 = (PVector)verts1.get(1);
    v02 = (PVector)verts1.get(2);
    v03 = (PVector)verts1.get(3);
    
    v10 = (PVector)verts2.get(0);
    v11 = (PVector)verts2.get(1);
    v12 = (PVector)verts2.get(2);
    v13 = (PVector)verts2.get(3);

    beginShape();
    vertex(v00.x,v00.y,v00.z);
    vertex(v01.x,v01.y,v01.z);
    vertex(v11.x,v11.y,v11.z);
    vertex(v10.x,v10.y,v10.z);
    endShape(CLOSE);
      
    beginShape();
    vertex(v01.x,v01.y,v01.z);
    vertex(v02.x,v02.y,v02.z);
    vertex(v12.x,v12.y,v12.z);
    vertex(v11.x,v11.y,v11.z);
    endShape(CLOSE);

    beginShape();
    vertex(v02.x,v02.y,v02.z);
    vertex(v03.x,v03.y,v03.z);
    vertex(v13.x,v13.y,v13.z);
    vertex(v12.x,v12.y,v12.z);
    endShape(CLOSE);
    
    beginShape();
    vertex(v03.x,v03.y,v03.z);
    vertex(v01.x,v01.y,v01.z);
    vertex(v11.x,v11.y,v11.z);
    vertex(v13.x,v13.y,v13.z);
    endShape(CLOSE);
     
    }



  popMatrix();
}


class Rovina{
  ArrayList vertices;
  
  PVector x,y,z;
  PMatrix3D matrix,base;

  Rovina parent;

  PVector relPoint;
  PVector origin;


  Rovina(PMatrix3D _mat){
    initialize(_mat);
  }


  Rovina(PMatrix3D _mat,Rovina _parent){
    parent = _parent;
    initialize(_mat);

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

    vertices = new ArrayList();
    vertices.add(absolutePoint(-V/2,-V/2,0));
    vertices.add(absolutePoint(V/2,-V/2,0));
    vertices.add(absolutePoint(V/2,V/2,0));
    vertices.add(absolutePoint(-V/2,V/2,0));

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
    if(parent!=null)
      inherit();



    if(APPLIED){

    pushMatrix();
      origin = new PVector(0,0,0);
    relPoint = new PVector(target.x,target.y,target.z);
    applyMatrix(matrix);

    noFill();
    stroke(255);
    rectMode(CENTER);

    rect(0,0,W,W);

    stroke(#ff0000);
    line(0,0,0,W/2,0,0);

    stroke(#00ff00);
    line(0,0,0,0,W/2,0);

    stroke(#0000ff);
    line(0,0,0,0,0,W/2);

    popMatrix();
    
    updateVertices();

    float s =  S;
    origin  = absolutePoint(0,0,0);
    relPoint = absolutePoint(target.x,target.y,target.z);
    stroke(#ff0000);
    line(relPoint.x-s,relPoint.y,relPoint.z,relPoint.x+s,relPoint.y,relPoint.z);
    stroke(#00ff00);
    line(relPoint.x,relPoint.y-s,relPoint.z,relPoint.x,relPoint.y+s,relPoint.z);
    stroke(#0000ff);
    line(relPoint.x,relPoint.y,relPoint.z-s,relPoint.x,relPoint.y,relPoint.z+s);
    stroke(#ffff00);
    line(origin.x,origin.y,origin.z,relPoint.x,relPoint.y,relPoint.z);
  }
  }


}




