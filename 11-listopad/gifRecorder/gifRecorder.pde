import gifAnimation.*;

boolean saveit = false;

GifMaker gifExport;
int frames = 0;
int totalFrames = 31;

color A,B;//

public void setup() {
  size(1600, 900,P2D);
  hint(DISABLE_DEPTH_TEST) ;

  A = color(#FFFFFF);
  B = color(#000000);

  frameRate(100);

  if(saveit){
    gifExport = new GifMaker(this, "export.gif", 100);
    gifExport.setRepeat(0); // make it an "endless" animation
  }

  imageMode(CENTER);

  noFill();
  stroke(0);
  strokeWeight(20);
  smooth();
}

void draw() {
  background(255);

  float speed = mouseY/100.0;

  noStroke();

  pushMatrix();

  translate(width/2,height/2);

  rotate(frameCount/1000.0);
  pushMatrix();
  translate(0,-sin(frameCount/10000.0)*200.0);
  rotate(frameCount/speed);

  fill(B);
  
  float frac = PI / (mouseX/2.0);

  for(float f = frac/2 ; f < TWO_PI;f += frac*2){

    triangle(
        cos(f)*width,sin(f)*width,
        cos(f+frac)*width,sin(f+frac)*width,
        0,0);
  }
  popMatrix();


  pushMatrix();
  translate(0,sin(frameCount/10000.0)*200.0);
  rotate(-frameCount/speed);
  
  frac = PI / (mouseX/2.0+10.0);

  for(float f = frac/2 ; f < TWO_PI;f += frac*2){




    triangle(
        cos(f)*width,sin(f)*width,
        cos(f+frac)*width,sin(f+frac)*width,
        0,0);
  }

  popMatrix();
  popMatrix();


  if(saveit)
    export();
}

void export() {
  if(frames < totalFrames) {
    gifExport.setDelay(20);
    gifExport.addFrame();
    frames++;
  } else {
    gifExport.finish();
    frames++;
    println("gif saved");
    exit();
  }
}
