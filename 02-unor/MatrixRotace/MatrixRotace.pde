
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
  p.rotate(mouseX,0,mouseY);
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

    x = new PVector(mat[0],mat[4],mat[8]);
    y = new PVector(mat[1],mat[5],mat[9]);
    z = new PVector(mat[2],mat[6],mat[10]);
    origin = new PVector(mat[3],mat[7],mat[11]);




  }

  PVector relativePoint(float _x,float _y, float _z){

    PVector pt = new PVector(_x,_y,_z);
    PMatrix3D nn = new PMatrix3D(matrix);
    nn.invert();
    nn.mult(pt,pt);
    
    /*
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
        */

    return pt;

  }




  void inherit(){

    //matrix = new PMatrix3D(base);


    PVector rp = parent.relPoint;
    matrix.m30 = rp.x;
    matrix.m31 = rp.y;
    matrix.m32 = rp.z;



  }

  void rotate(float _x, float _y, float _z){
    if(parent!=null)
      inherit();

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

    // working solution
    matrix = new PMatrix3D(
        cb*cg,cg*sa*sb-ca*sg,ca*cg*sb+sa*sg,mat[3],
        cb*sg,ca*cg+sa*sb*sg,-cg*sa+ca*sb*sg,mat[7],
        -sb,cb*sa,ca*cb,mat[11],
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

    PVector A,B;
    stroke(255);
    relPoint = relativePoint(100,100,120);
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
    s = 50;
    line(relPoint.x-s,relPoint.y,relPoint.z,relPoint.x+s,relPoint.y,relPoint.z);
    line(relPoint.x,relPoint.y-s,relPoint.z,relPoint.x,relPoint.y+s,relPoint.z);
    line(relPoint.x,relPoint.y,relPoint.z-s,relPoint.x,relPoint.y,relPoint.z+s);
    line(0,0,0,relPoint.x,relPoint.y,relPoint.z);
  }


}




