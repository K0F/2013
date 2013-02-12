/**
 *   Separate Blur Shader
 *    
 *   This blur shader works by applying two successive passes, one horizontal
 *   and the other vertical.
 *      
 *   Press the mouse to switch between the custom and default shader.
 *        */

PShader blur;
PGraphics src;
PGraphics pass1, pass2;

PImage img;

void setup() {
  size(1024, 768, P2D);

  img = loadImage("1947.jpg");

  blur = loadShader("frag.glsl");
  blur.set("blurSize", 10);
  blur.set("sigma", 5.0f);  

  src = createGraphics(width, height, P2D); 

  pass1 = createGraphics(width, height, P2D);
  pass1.noSmooth();  

  pass2 = createGraphics(width, height, P2D);
  pass2.noSmooth();

  
  src.beginDraw();
  src.background(255);
  src.imageMode(CENTER);
  src.image(img,width/2,height/2,img.width/3,img.height/3);
  src.endDraw();

}

void draw() {

int am = (int)(noise(frameCount/30.0)*100);
float sigma = (noise(frameCount/30.0)*50);

  blur.set("blurSize", am);
  blur.set("sigma", sigma);  
  // Applying the blur shader along the vertical direction   
  blur.set("horizontalPass", 0);
  pass1.beginDraw();            
  pass1.shader(blur);  
  pass1.image(src, 0, 0);
  pass1.endDraw();

  // Applying the blur shader along the horizontal direction      
  blur.set("horizontalPass", 1);
  pass2.beginDraw();            
  pass2.shader(blur);  
  pass2.image(pass1, 0, 0);
  pass2.endDraw();    

  image(pass2, ((noise(frameCount/9.0,0)-0.5)*3.0), ((noise(0,frameCount/9.0)-0.5)*3.0));   
}

void keyPressed() {
  if (key == '9') {
    blur.set("blurSize", 9);
    blur.set("sigma", 5.0);
  } else if (key == '7') {
    blur.set("blurSize", 7);
    blur.set("sigma", 3.0);
  } else if (key == '5') {
    blur.set("blurSize", 5);
    blur.set("sigma", 2.0);  
  } else if (key == '3') {
    blur.set("blurSize", 5);
    blur.set("sigma", 1.0);  
  }  
} 
