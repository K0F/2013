import java.awt.Robot.*;
import java.awt.Color;
import java.awt.Rectangle;
import java.awt.image.BufferedImage;
import java.awt.MouseInfo;

java.awt.Robot robot;

void setup(){
  size(640,480);
  background(255);

  noSmooth();

  try{
    robot = new java.awt.Robot();
  }catch(Exception e){;}

  loadPixels();
}

String in;

void selectInput(String prompt, String callback){
  callback = in;
}


void init(){
  frame.removeNotify();
  frame.setUndecorated(true);
  frame.addNotify(); 
  super.init();
}


void draw(){


  //println(MouseInfo.getPointerInfo());

  int x = MouseInfo.getPointerInfo().getLocation().x;
  int y = MouseInfo.getPointerInfo().getLocation().y;

/*
  int x = (int)(noise(frameCount/100.0,0)*(displayWidth-width));
  int y = (int)(noise(0,frameCount/100.0)*(displayHeight-height));
*/

  if(frameCount<10)
  frame.setLocation(0,0);

  loadPixels();

  int r = 100;

  java.awt.Rectangle rct = new java.awt.Rectangle(x-width/2,y-height/2,width,height);
  java.awt.image.BufferedImage bf = robot.createScreenCapture(rct);

  /*
  for(int Y = 0 ; Y < height;Y++){
    for(int X = 0 ; X < width;X++){
      java.awt.Color c = robot.getPixelColor(X,Y);
      stroke(color(c.getRed(),c.getGreen(),c.getBlue()));
      point(X,Y);
    }
  }

  updatePixels();
  */


  PImage img = new PImage(bf);
  image(img,0,0,width,height);

  stroke(#ff0000);
  line(width/2,height/2-5,width/2,height/2+5);
  line(width/2-5,height/2,width/2+5,height/2);
}
