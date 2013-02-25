
Rovina p;
Rovina p2;
PMatrix3D mmatrix;

void setup(){
  size(800,600,P3D);

  mmatrix = new PMatrix3D(
      1,0,0,0,
      0,1,0,0,
      0,0,1,0,
      0,0,0,1
      );

  printMatrix();


  p = new Rovina(mmatrix);
  p2 = new Rovina(mmatrix,p);

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
  p.rotate(mouseX,mouseY,0);
  //p.rotateY(mouseY);
  //p.rotateZ(mouseX);
  
 
  //p.rotateZ(1);

  pushMatrix();
  translate(width/2,height/2,0);

  pushMatrix();
  rotateX(QUARTER_PI);
  pushMatrix();
  rotateZ(QUARTER_PI);

  p.draw();
  p2.draw();

  popMatrix();
  popMatrix();
  popMatrix();
}


class Rovina{
  PVector x,y,z;
  PMatrix3D matrix,base;

  Rovina parent;

  PVector relPoint;
  PVector origin;

  float s = 5;

  float w = 200;
  float h = 200;




  Rovina(PMatrix3D _mat){
    initialize(_mat);
  }


  Rovina(PMatrix3D _mat,Rovina _parent){
    parent = _parent;
    initialize(_mat);
  }

  void initialize(PMatrix _mat){
    matrix = new PMatrix3D(_mat);
    base = new PMatrix3D(_mat);



    float mat[] = new float[16];
    matrix.get(mat);

    x = new PVector(mat[0],mat[1],mat[2]);
    y = new PVector(mat[4],mat[5],mat[6]);
    z = new PVector(mat[8],mat[9],mat[10]);
    origin = new PVector(mat[12],mat[13],mat[14]);


    relPoint = relativePoint(new PVector(0,0,120));


  }


  PVector relativePoint(PVector pt){

    update();

    PVector answer = new PVector();
    PVector anX,anY,anZ;

    anX = new PVector(x.x,x.y,x.z);
    anY = new PVector(y.x,y.y,y.z);
    anZ = new PVector(z.x,z.y,z.z);

    anX.mult(pt);
    anY.mult(pt);
    anZ.mult(pt);

    return new PVector(
        anX.x+anY.x+anZ.x,
        anX.y+anY.y+anZ.y,
        anX.z+anY.z+anZ.z
        );

  } 
  
  PVector relativePoint(float _x,float _y, float _z){

    update();

    PVector pt = new PVector(_x,_y,_z);
    PVector answer = new PVector();
    PVector anX,anY,anZ;

    anX = new PVector(x.x,x.y,x.z);
    anY = new PVector(y.x,y.y,y.z);
    anZ = new PVector(z.x,z.y,z.z);

    anX.mult(pt);
    anY.mult(pt);
    anZ.mult(pt);

    return new PVector(
        anX.x+anY.x+anZ.x,
        anX.y+anY.y+anZ.y,
        anX.z+anY.z+anZ.z
        );

  }

  void update(){
  
      float mat[] = new float[16];
      matrix.get(mat);

  x = new PVector(mat[0],mat[1],mat[2]);
    y = new PVector(mat[4],mat[5],mat[6]);
    z = new PVector(mat[8],mat[9],mat[10]);
    origin = new PVector(mat[12],mat[13],mat[14]);


  }


  void inherit(){

    matrix = new PMatrix3D(base);
    

    //matrix.mult(parent.relPoint);



  }

  void rotate(float _x, float _y, float _z){
  if(parent!=null)
      inherit();

    float radx = radians(_x);
    float rady = radians(_y);
    float radz = radians(_z);

    float cx = cos(radx);
    float sx = sin(radx);

    float cy = cos(rady);
    float sy = sin(rady);

    float cz = cos(radz);
    float sz = sin(radz);

    float[] mat = new float[16];
    matrix = new PMatrix3D(base);
    matrix.get(mat);

    PVector xaxis = relativePoint(1,0,0);
    matrix.rotate(radx, xaxis.x,xaxis.y,xaxis.z);
    PVector yaxis = relativePoint(0,1,0);
    matrix.rotate(rady, yaxis.x,yaxis.y,yaxis.z);
    PVector zaxis = relativePoint(0,0,1);
    matrix.rotate(radz, zaxis.x,zaxis.y,zaxis.z);

    /*
    matrix = new PMatrix3D(
        0.5 * ((mat[0] * cy + mat[8] * sy) + (mat[0] * cz + mat[4] * sz)),
        0.5 * ((mat[1] * cy + mat[9] * sy) + (mat[1] * cz + mat[5] * sz)),
        0.5 * ((mat[2] * cy + mat[10] * sy) + (mat[2] * cz + mat[6] * sz)),
        0.5 * ((mat[3] * cy + mat[11] * sy) + (mat[3] * cz + mat[7] * sz)),

        0.5 * ((mat[4] * cx + mat[8] * sx) + (mat[4] * cz - mat[0] * sz)),
        0.5 * ((mat[5] * cx + mat[9] * sx) + (mat[5] * cz - mat[1] * sz)),
        0.5 * ((mat[6] * cx + mat[10] * sx) + (mat[6] * cz - mat[2] * sz)),
        0.5 * ((mat[7] * cx + mat[11] * sx) + (mat[7] * cz - mat[3] * sz)),
        
        0.5 * ((mat[8] * cx - mat[4] * sx) + (mat[8] * cy - mat[0] * sy)),
        0.5 * ((mat[9] * cx - mat[5] * sx) + (mat[9] * cy - mat[1] * sy)),
        0.5 * ((mat[10] * cx - mat[6] * sx) + (mat[10] * cy - mat[2] * sy)),
        0.5 * ((mat[11] * cx - mat[7] * sx) + (mat[11] * cy - mat[3] * sy)),

        mat[12],mat[13],mat[14],mat[15]);

        */
  }


  void rotateX(float rad){

    if(parent!=null)
      inherit();

    rad = radians(rad);

    float c = cos(rad);
    float s = sin(rad);
    float[] mat = new float[16];
    matrix = new PMatrix3D(base);
    matrix.get(mat);
    
    matrix = new PMatrix3D(
        mat[0], mat[1], mat[2], mat[3],
        mat[4] * c + mat[8] * s ,mat[5] * c + mat[9] * s ,mat[6] * c + mat[10] * s , mat[7] * c + mat[11] * s,
        mat[8] * c - mat[4] * s ,mat[9] * c - mat[5] * s ,mat[10] * c - mat[6] * s, mat[11] * c - mat[7] * s,
        mat[12], mat[13], mat[14], mat[15]);
  }

  void rotateY(float rad){
    rad = radians(rad);
    float c = cos(rad);
    float s = sin(rad);
    float[] mat = new float[16];
    //matrix = new PMatrix3D(base);
    matrix.get(mat);
    
    matrix = new PMatrix3D(
        mat[0] * c + mat[8] * s ,mat[1] * c + mat[9] * s ,mat[2] * c + mat[10] * s , mat[3] * c + mat[11] * s,
        mat[4], mat[5], mat[6], mat[7],
        mat[8] * c - mat[0] * s ,mat[9] * c - mat[1] * s ,mat[10] * c - mat[2] * s, mat[11] * c - mat[3] * s,
        mat[12], mat[13], mat[14], mat[15]);
  }

  void rotateZ(float rad){
    rad = radians(rad);

    float c = cos(rad);
    float s = sin(rad);
    float[] mat = new float[16];
    //matrix = new PMatrix3D(base);
    matrix.get(mat);

    matrix = new PMatrix3D(
        mat[0] * c + mat[4] * s ,mat[1] * c + mat[5] * s ,mat[2] * c + mat[6] * s , mat[3] * c + mat[7] * s,
        mat[4] * c - mat[0] * s ,mat[5] * c - mat[1] * s ,mat[6] * c - mat[2] * s, mat[7] * c - mat[3] * s,
        mat[8], mat[9], mat[10], mat[11],
        mat[12], mat[13], mat[14], mat[15]);
  }

  void draw(){
    /*
       matrix = new PMatrix3D(
       x.x, x.y, x.z, origin.x,
       y.x, y.y, y.z, origin.y,
       z.x, z.y, z.z, origin.z,
       0,0,0,1
       );
     */

    PVector A,B;
    stroke(255);
    
    // vv ???
    A = new PVector(0,-100,-100);
    B = relativePoint(new PVector(0,100,100));
    
    applyMatrix(matrix);

    beginShape();
    vertex(A.x,A.y,A.z);
    vertex(B.x,B.y,B.z);
    endShape();

    noFill();
    stroke(255);
    rectMode(CENTER);

    rect(0,0,w,h);

    stroke(#ff0000);
    line(0,0,0,w/2,0,0);

    stroke(#00ff00);
    line(0,0,0,0,h/2,0);

    stroke(#0000ff);
    line(0,0,0,0,0,h/2);

    stroke(255);
    line(relPoint.x-s,relPoint.y,relPoint.z,relPoint.x+s,relPoint.y,relPoint.z);
    line(relPoint.x,relPoint.y-s,relPoint.z,relPoint.x,relPoint.y+s,relPoint.z);
    line(relPoint.x,relPoint.y,relPoint.z-s,relPoint.x,relPoint.y,relPoint.z+s);
  }


}




