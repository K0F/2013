float step = 5;
float W = 3;

boolean inverse = false;
int kadence = 3;
PGraphics projection;
PImage running;


public void setup(){
  size(1280,720);
  strokeCap(SQUARE);
  smooth();

  running = loadImage("muybridge.jpg");
  running.filter(INVERT);

  generate();
}

int shiftx = 0;
int shifty = 0;

void generate(){


  projection = createGraphics(width,height,JAVA2D);
  projection.beginDraw();
  projection.image(running,shiftx,shifty,running.width*4,running.height*4);
  projection.endDraw();

  projection.updatePixels();
  projection.loadPixels();
  

  shiftx-=158*4;
  
  if(shiftx<=-running.width*4 && shifty==0){
    shiftx = 0 ;
    shifty = (int)(-146*3.8);

  }else if(shiftx<=-running.width*4 && shifty==(int)(-146*3.8)){
shiftx = 0 ;
    shifty = 0;


  }

}


void draw(){
   // inverse=!inverse;
   //
  
  if(frameCount%3==0)
    generate();

  float mX = width/2+cos(frameCount/5.0)*width/4.0;
  float mY = height/2+sin(frameCount/5.0)*width/4.0;

  //background(inverse?0xff0266FE:0xffD2D202);
  background(0);

  //translate((noise(frameCount/100.0f,0)-0.5f)*20.0f,(noise(0,frameCount/100.0f)-0.5f)*40.0f);

  pushMatrix();
  translate(width/2,height/2);
  rotate(-frameCount/10.33f);

  translate(-width/2,-height/2);


  for(float y = -240 ; y < height+240; y+=step){
    for(float x = -240 ; x < width+240; x+=step){
      
      float X = x;
      float Y = y;

      float XX = x+sin(frameCount/1000.0f+x/800.33f)*10.0f;
      float YY = y+cos(frameCount/1000.0f+(x+y/100.0f)/30.33f)*50.0f;
      float D = map(dist(XX,YY,mX,mY),0,sqrt(sq(width)+sq(height)),1.2,0.2);
  
      int idx = ((int)screenY(XX,YY)*projection.width+(int)screenX(XX,YY));

      
      boolean red_dot = false;
      color c = color(0);

      try{
        c = projection.pixels[idx];
//      println(XX+" "+YY);
      //fill(projection.pixels[(int)YY*width+(int)XX]);
      //rect(XX,YY,10,10);


if(brightness(c)>200)
{
  noStroke();
  fill(255);
  ellipse(XX,YY,W,W);
}
  /*
  ellipse2(
          XX,
          YY,
          W*D,
          1.0,
          D,
          (atan2(mY-screenY(XX,YY),mX-screenX(XX,YY)))+HALF_PI,
          red_dot,
          c
          );

*/


      }catch(Exception e){;}
       }

  }

  //image(projection,0,0);

  popMatrix();

  saveFrame("/home/kof/render/horse/horse#####.tga");

}

void mousePressed(){
  println(mouseX);
  inverse = !inverse;

}








void ellipse2(float x,float y,float w,float ww,float hh,float _theta,boolean red_dot,color c){

  float theta = _theta;//radians(_theta);
  pushMatrix();
  translate(x,y);

  strokeWeight(5);
  pushMatrix();
  rotate(theta);
  stroke(0);
  //stroke(inverse?255:0);
  arc(0,0,ww*w,hh*w,0,PI);
  //stroke(inverse?0:255);
  stroke(255);
  arc(0,0,ww*w,hh*w,PI,TWO_PI);
  noStroke();
  if(red_dot){
  fill(255,0,0);
  }else{
  fill(c);//inverse?0xffD2D202:0xff0266FE);
  }
  ellipse(0,0,ww*w,hh*w);
  popMatrix();
  popMatrix();


}

