PShape cube;
PShader lineShader;
float angle;

float weight = 20;

void setup() {
  size(640, 360, P3D);

  reload();  

  hint(DISABLE_DEPTH_MASK);
}

void reload(){

  lineShader = loadShader("linefrag.glsl", "linevert.glsl");
  lineShader.set("weight", weight);

  cube = createShape(BOX, 150);
  cube.setFill(false);
  cube.setStroke(color(255));
  cube.setStrokeWeight(weight);

}

void keyPressed(){
  reload();
}

void draw() {
  background(0);
  lineShader.set("time", frameCount/10.0);

  translate(width/2, height/2);
  rotateX(angle);
  rotateY(angle);

  shader(lineShader, LINES);
  shape(cube);

  angle += 0.01;  
}
