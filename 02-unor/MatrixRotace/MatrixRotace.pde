
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

  p.rotateX(mouseX);
  p.rotateY(mouseY);
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

  void inherit(){

    matrix = new PMatrix3D(base);
    

    //matrix.mult(parent.relPoint);



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
        mat[0],mat[1],mat[2],mat[3],
        mat[4] * c + mat[8] * s ,mat[5] * c + mat[9] * s ,mat[6] * c + mat[10] * s , mat[7] * c + mat[11] * s,
        mat[8] * c - mat[4] * s ,mat[9] * c - mat[5] * s ,mat[10] * c - mat[6] * s, mat[11] * c - mat[7] * s,
        mat[12],mat[13],mat[14],mat[15]
        );




  }

  void rotateY(float rad){
    rad = radians(rad);

    float c = cos(rad);
    float s = sin(rad);
    float[] mat = new float[16];
    matrix = new PMatrix3D(base);
    matrix.get(mat);

    matrix = new PMatrix3D(
        mat[0] * c + mat[8] * s ,mat[1] * c + mat[9] * s ,mat[2] * c + mat[10] * s , mat[3] * c + mat[11] * s,
        mat[4],mat[5],mat[6],mat[7],
        mat[8] * c - mat[0] * s ,mat[9] * c - mat[1] * s ,mat[10] * c - mat[2] * s, mat[11] * c - mat[3] * s,
        mat[12],mat[13],mat[14],mat[15]
        );

  }

  void rotateZ(float rad){
    rad = radians(rad);

    float c = cos(rad);
    float s = sin(rad);
    float[] mat = new float[16];
    matrix = new PMatrix3D(base);
    matrix.get(mat);

    matrix = new PMatrix3D(
        mat[0] * c + mat[4] * s ,mat[1] * c + mat[5] * s ,mat[2] * c + mat[6] * s , mat[3] * c + mat[7] * s,
        mat[4] * c - mat[0] * s ,mat[5] * c - mat[1] * s ,mat[6] * c - mat[2] * s, mat[7] * c - mat[3] * s,
        mat[8],mat[9],mat[10],mat[11],
        mat[12],mat[13],mat[14],mat[15]
        );


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
    applyMatrix(matrix);

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




