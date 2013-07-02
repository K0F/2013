/*
Coded by Kof @ 
Tue Jul  2 12:27:02 CEST 2013



   ,dPYb,                  ,dPYb,
   IP'`Yb                  IP'`Yb
   I8  8I                  I8  8I
   I8  8bgg,               I8  8'
   I8 dP" "8    ,ggggg,    I8 dP
   I8d8bggP"   dP"  "Y8ggg I8dP
   I8P' "Yb,  i8'    ,8I   I8P
  ,d8    `Yb,,d8,   ,d8'  ,d8b,_
  88P      Y8P"Y8888P"    PI8"8888
                           I8 `8,
                           I8  `8,
                           I8   8I
                           I8   8I
                           I8, ,8'
                            "Y8P'

*/

float tras = 4.0;
float blink = 10.0;

int NUM = 4000;
ArrayList veci;

boolean RENDER = false;

PGraphics frame;

void setup(){

  size(1280,720,P2D);

  veci = new ArrayList();

  for(int i = 0 ; i < NUM; i++)
    veci.add(new Vec(i));

  rectMode(CENTER);

  float uhlopricka = (dist(width/2,height/2,width,height))/2.0; 

  frame = createGraphics(width,height,P2D);
  frame.beginDraw();
  for(int y = 0 ; y<height ; y++){
    for(int x = 0 ; x<width ; x++){
      frame.set(x,y,color(0,map(dist(x,y,width/2,height/2),0,uhlopricka*2.5,0,255)));
    }
  }
  frame.endDraw();


  smooth();
}





void draw(){

  fill(255,noise(frameCount/blink,0)*140);
  rect(width/2,height/2,width,height);

  blink = noise(frameCount/500.0)*100.0;
  tras = noise(frameCount/102.0)*10.0;

  pushMatrix();

  translate(width/2,height/2);
  rotate(-frameCount/1000.0);
  translate(-width/2,-height/2);

  pushMatrix();

  translate( 
      (noise(frameCount/2.0,0)-0.5)*tras + (noise(frameCount/200.0,0)-0.5)*tras*10.0, 
      (noise(0,frameCount/2.0)-0.5)*tras + (noise(0,0,frameCount/200.0)-0.5)*tras*10.0 );

  for(int i = 0 ; i < veci.size();i++){

    Vec t = (Vec)veci.get(i);
    t.draw();

  }
  popMatrix();

  popMatrix();

  tint(255,noise(0,frameCount/blink)*255);
  image(frame,0,0);


  if(RENDER)
    saveFrame("/home/kof/render/trapped/fr#####.tga");

}

//////////////////////////////////////////////////////////

class Vec{

  PVector pos;
  float speed = 10.0;
  int id;
  boolean dir;

  Vec(int _id){
    dir = random(100)>50?true:false;
    id = _id;
    speed = pow(id,0.8)*10.0+1.0;
    pos = new PVector(width/2,height/2);

  }


  void move(){

    if(dir)
      pos.x = sin(frameCount/speed)*width/2+width/2;
    else
      pos.x = (-1.0*sin(frameCount/speed)*width/2)+width/2;

  }

  void draw(){
    move();

    noStroke();
    fill(0,20);

    pushMatrix();
    translate(pos.x,pos.y);
    rotate(id/10.0+frameCount/300.0);

    rect(0,0,2,width*3);

    popMatrix();
  }
}
