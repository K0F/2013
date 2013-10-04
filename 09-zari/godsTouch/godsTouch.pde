PImage bck,human,god;

void setup(){

  bck = loadImage("background.png");
  human = loadImage("human.png");
  god = loadImage("god.png");

  size(bck.width,bck.height,P2D);


}


void draw(){

  image(bck,0,0);
  pushMatrix();
  translate(714,291);
  rotate(radians(noise(frameCount/30.0)*10.0));
  translate(-714,-291);
  image(human,0,0);//(noise(frameCount/100.0,0)-0.5)*20,(noise(0,frameCount/100.0)-0.5)*20);

  popMatrix();

  pushMatrix();
  translate(800,120);
  pushMatrix();
  translate(0,150);
  rotate(radians(noise(frameCount/30.0)*10.0));
  translate(-0,-150);
  image(god,0,0);
  popMatrix();
  popMatrix();

  println(mouseX+" "+mouseY);

}
