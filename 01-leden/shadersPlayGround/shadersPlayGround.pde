PShape ball;
PShader mat;
PImage diff, norm;

float rx, ry;

//PeasyCam cam;



void INIT_SHADER() {


  mat.set("AmbientColour", 0.2, 0.2, 0.2);
  mat.set("DiffuseColour", 0.8, 0.8, 0.8);
  mat.set("SpecularColour", 1.0, 1.0, 1.0);
  mat.set("AmbientIntensity", 0.9);
  mat.set("DiffuseIntensity", 0.9);
  mat.set("SpecularIntensity", 0.7);
  mat.set("Roughness", 0.3);
  mat.set("Sharpness", 0.001);

  mat.set("diffuseTexture", diff);
  mat.set("normalTexture", norm);
  
 // mat.set("inTexcoord", 300,300);
}

void setup() {

  size(640, 640, P3D);  
  
  

  mat = loadShader("GlossyFrag.glsl","GlossyVert.glsl");


  diff = loadImage("female_child_muscle.png");
  norm = loadImage("female_child_muscle_normal.png");
  //diff = loadImage("checker.png");


  ball = loadShape("woman.obj");
  ball.scale(30, -30, 30);
  //ball.texture(diff);
  // mat.set("lightVec",new PVector(100,100,100));s
  INIT_SHADER();


  shader(mat);
 

}

void draw() {



  //image(diff,0,0);
  background(15);
 // lights(); 
  pushMatrix();
  translate(width/2, height/2);
  pointLight(204, 204, 204, (sin(frameCount/300.0))*1000, 1000, 1000);

  //rotateX(frameCount/100.0);
  rotateY(frameCount/75.0);


  //shape(ball);
  //image(diff,0,0);
  shape(ball);
  popMatrix();
  
 
}

void mouseDragged() {
  ry += ((mouseX-pmouseX)-ry)/300.0; 
  rx -= ((mouseY-pmouseY)-rx)/300.0;
}

void keyPressed() {
  try {
    println("---------------------------------");
    println("reloading shader");
    resetShader();
    mat = loadShader("GlossyFrag.glsl", "GlossyVert.glsl");
    INIT_SHADER();
    shader(mat);
    println("---------------------------------");
    
  } 
  catch(Exception e) {
    println(e);
  }
}

