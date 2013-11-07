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

  float frac = TWO_PI / 500.0;
  float speed = 500.0;

  noStroke();

  pushMatrix();

  translate(width/2,height/2);
  pushMatrix();
  translate(0,-sin(frameCount/10000.0)*200.0);
  rotate(frameCount/speed);

  fill(B);

  int cntr = 0;
  for(float f = 0 ; f < TWO_PI;f += frac*2){

    //fill((cntr+frameCount)%2==0?A:B);

    cntr++;

    triangle(
        cos(f)*width,sin(f)*width,
        cos(f+frac)*width,sin(f+frac)*width,
        0,0);
  }
  popMatrix();


  pushMatrix();
  translate(0,sin(frameCount/10000.0)*200.0);
  rotate(-frameCount/speed);

  cntr = 0;

  for(float f = 0 ; f < TWO_PI;f += frac*2){

    //fill((cntr+frameCount)%2==0?B:A);

    cntr++;


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
