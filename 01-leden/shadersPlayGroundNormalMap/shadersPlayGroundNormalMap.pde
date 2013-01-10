PShape ball;
PShader mat;
PImage diff, norm;

float rx, ry;
float scale = 30.0;

void INIT_SHADER() {


   mat.set("NR_Ammount", 0.0005);
 
  mat.set("AmbientColour", 0.2, 0.2, 0.2);
  mat.set("DiffuseColour", 0.8, 0.8, 0.8);
  mat.set("SpecularColour", 0.8, 0.8, 0.8);
  mat.set("AmbientIntensity", 0.4);
  mat.set("DiffuseIntensity", 0.9);
  mat.set("SpecularIntensity", 0.7);
  mat.set("Roughness", 0.2);
  mat.set("Sharpness", 0.01);

  mat.set("diffuseTexture", diff);
  mat.set("normalTexture", norm);

  // mat.set("inTexcoord", 300,300);
}

void setup() {

  size(800, 600, P3D);  



  mat = loadShader("frag.glsl", "vert.glsl");


  diff = loadImage("female_child_muscle.png");
  norm = loadImage("female_child_muscle_normal.png");
  //diff = loadImage("checker.png");


  ball = loadShape("woman.obj");
  ball.scale(scale, -scale, scale);
  //ball.texture(diff);
  // mat.set("lightVec",new PVector(100,100,100));s
  INIT_SHADER();
}

void draw() {

  shader(mat);

  //lights();

  background(0);

  pushMatrix();
  translate(width/2, height/2);
  pointLight(250, 250, 250, (sin(frameCount/300.0))*1000, 1000, 1000);

  rotateY(frameCount/85.0);


  shape(ball);
  popMatrix();
  resetShader();
}

void mouseDragged() {
  ry += ((mouseX-pmouseX)-ry)/300.0; 
  rx -= ((mouseY-pmouseY)-rx)/300.0;
}

void keyPressed() {
  try {
    println("---------------------------------");
    println("reloading shader");
    //resetShader();
    mat = loadShader("frag.glsl", "vert.glsl");
    INIT_SHADER();
    shader(mat);
    println("---------------------------------");
  } 
  catch(Exception e) {
    println(e);
  }
}

