

PMatrix3D a,b,c;

void setup(){

  size(640,640,P3D);


  a = new PMatrix3D(
      1,0,0,0,
      0,1,0,0,
      0,0,1,0,
      0,0,0,1
      );
  b = new PMatrix3D(
      1,0,0,0,
      0,1,0,0,
      0,0,1,0,
      0,0,0,1
      );
  c = new PMatrix3D(
      1,0,0,0,
      0,1,0,0,
      0,0,1,0,
      0,0,0,1
      );
}



void draw(){

  background(0);

  applyMatrix(a);
  box(10);
  applyMatrix(b);
  box(10);
  applyMatrix(c);
  box(10);
}

