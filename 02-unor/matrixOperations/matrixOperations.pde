PMatrix3D matrix;
float m[];

void setup(){

  size(400,400,P3D);

  m = new float[16];
  matrix = new PMatrix3D();
}

float c = 0;

void draw(){

  float x = mouseX/width;
  float y = mouseY;
  c += 0.1;

  matrix = new PMatrix3D(
        1,  0,  0, 10,
        0,  1,  0, 10,
        0,  0,  1, 10,
        0,  0,  0, 1
      );

  background(255);

  pushMatrix();
  translate(width/2,height/2,0);
  lights();

  for(int i = 0 ; i < 10;i++){
  applyMatrix(matrix);
  fill(#ffcc00);

  box(10);
  }

  popMatrix();

}
