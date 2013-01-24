
boolean render = false;

PShape character,jeans;
PShader mat;
PImage diff, norm, p5;

float rx, ry;
float scale = 60.0;
float time = 0.0;

void INIT_SHADER() {


  mat.set("NR_Ammount", 0.0002);

  mat.set("AmbientColour", 0.01, 0.01, 0.01);
  mat.set("DiffuseColour", 0.8, 0.8, 0.8);
  mat.set("SpecularColour", 0.9, 0.9, 0.9);
  mat.set("AmbientIntensity", 0.0);
  mat.set("DiffuseIntensity", 1.0);
  mat.set("SpecularIntensity", 1.0);
  mat.set("Roughness", 0.2);
  mat.set("Sharpness", 0.1);

  //mat.set("diffuseTexture", diff);
  mat.set("normalTexture", norm);

  // mat.set("time", time);


  // mat.set("inTexcoord", 300,300);
}

void setup() {

 size(displayWidth, displayHeight, P3D);  



  imageMode(CENTER);
  mat = loadShader("frag.glsl", "vert.glsl");


  diff = loadImage("bake_full_tata6.png");
  norm = loadImage("bake_tata6_normal.png");
  //diff = loadImage("checker.png");


  character = loadShape("tata.obj");


  character.scale(scale, -scale, scale);
  // character.translate(0,1,0);
  //character.texture(diff);
  // mat.set("lightVec",new PVector(100,100,100));
  INIT_SHADER();
}

void draw() {

  time+=0.1;
  mat.set("time", time);


  character.rotateY(0.003);

  shader(mat);


  pointLight(255, 255, 255, 1000,1000,1000);
  ambientLight(250, 250, 250, -100,  200, 200);

  //lights();

  background(0);

  pushMatrix();
  translate(width/2, height/2+30);




  shape(character);

  resetShader();
  //rotateX(radians(-15));
  translate(0,-20,39);
  //image(p5,0,0,50,50);

  popMatrix();

  if(render){
    saveFrame("/home/kof/render/man/fr#####.tga");

    println(frameCount+" "+(frameCount/25.0));
  }
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

