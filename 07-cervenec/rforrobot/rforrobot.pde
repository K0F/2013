ArrayList robots;

void setup(){

  size(320,240,P3D);

  robots = new ArrayList();

  robots.add(new Robot());

}



void draw(){

  background(0);


  pushMatrix();
  translate(width/2,height/2,0);
  for(int i = 0 ; i < robots.size();i++){
    Robot tmp = (Robot)robots.get(i);
    tmp.draw();

  }

  popMatrix();





}

class Robot{

  PMatrix3D pos;

  Robot(){
    pos = new PMatrix3D();
    pos.reset();
    pos.print();
  }

  void draw(){
    move();
    pushMatrix();
    applyMatrix(pos);
    fill(255);
    box(100);
    popMatrix();
  }

  void move(){
      pos = rotate(0,0,frameCount);
      pos.m03 += 0.1;
  }

  PMatrix3D rotate(float _x, float _y, float _z) {
    float radx = radians(_x);
    float rady = radians(_y);
    float radz = radians(_z);

    float ca = cos(radx);
    float sa = sin(radx);

    float cb = cos(rady);
    float sb = sin(rady);

    float cg = cos(radz);
    float sg = sin(radz);

    PMatrix3D matrix = new PMatrix3D(pos);
    float[] mat = new float[16];

    PMatrix3D tmp = new PMatrix3D();
    tmp.reset();

    matrix = new PMatrix3D(pos);
    matrix.get(mat);

    // working pure hell matrix solution for rotation in X,Y,Z
    matrix = new PMatrix3D(
        cb*cg, cg*sa*sb-ca*sg, ca*cg*sb+sa*sg, pos.m03,
        cb*sg, ca*cg+sa*sb*sg, -cg*sa+ca*sb*sg, pos.m13,
        -sb, cb*sa, ca*cb, pos.m23,
        mat[12], mat[13], mat[14], mat[15]
        );
    
    return matrix;
  }

}
