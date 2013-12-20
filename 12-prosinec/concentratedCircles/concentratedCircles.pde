void setup(){
  size(720,720,P2D);
  smooth();
  background(0);
}

float y,r;

void draw(){
  background(0);
  noFill();
  pushMatrix();
  translate(width/2,height/2);
  for(int i= 0;i< 3000;i+=10){
    r = (frameCount) / 100.0 + i / 10.0;
    stroke((sin((frameCount+i)/4.0)+1.0)/2.0*width, 30);

    ellipse(cos(r/PI)*r,sin(r/PI)*r,sin(r/PI+r)*r,cos(r/PI+r)*r);

  }
  popMatrix();

}
