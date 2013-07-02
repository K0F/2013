

PMatrix3D am,bm,cm;

void setup(){

  size(640,640,P3D);


  am = new PMatrix3D(
      1,0,0,0,
      0,1,0,0,
      0,0,1,0,
      0,0,0,1
      );
  bm = new PMatrix3D(
      1,0,0,0,
      0,1,0,0,
      0,0,1,0,
      0,0,0,1
      );
  cm = new PMatrix3D(
      1,0,0,0,
      0,1,0,0,
      0,0,1,0,
      0,0,0,1
      );
}



void draw(){

  background(0);
  applyMatrix(am);
  box(10);
  applyMatrix(bm);
  box(10);
  applyMatrix(cm);
  box(10);
}

