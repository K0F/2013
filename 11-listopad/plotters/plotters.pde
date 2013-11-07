/**

Coded by Kof @ 
Thu Nov  7 14:17:37 CET 2013



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

ArrayList plotters;

int TRAIL_LENGTH = 300;
int NUM = 20;
float FRICTION = 0.64;
float SHAKE = 5.0;

int ROZPAL = 72/2;
PGraphics ram;

void setup(){
  size(512,512,P2D);

  noiseSeed(hour());

  textFont(createFont("Semplice Regular",6,false));

  plotters = new ArrayList();
  for(int i = 0 ; i < NUM ; i++)
    plotters.add(new Plotter());

  generateRam();

  background(0);
}


void draw(){



  fill(0,random(80,120));
  rect(0,0,width,height);
  pushMatrix();

  fill(255,20);
  translate((noise(frameCount,0)-.5)*SHAKE,(noise(0,frameCount)-.5)*SHAKE);

  for(int i = 0 ; i < plotters.size();i++){
    Plotter tmp = (Plotter)plotters.get(i);
    tmp.draw();
  }

  translate((noise(frameCount,0)-.5)*SHAKE*-.5,(noise(0,frameCount)-.5)*SHAKE*-.5);

  image(ram,0,0);

  popMatrix();


  pushStyle();
  stroke(0);
  noFill();
  strokeWeight(4);
  rect(0,0,width,height);
  popStyle();

  fill(255,100);
  text("noiseSeed("+nf(hour(),2)+""+nf(minute(),2)+");",width-120,height-10);
  noiseSeed(hour()+minute());

}

class Plotter{
  PVector pos,vel,acc;
  ArrayList trail;

  Plotter(){
    pos = new PVector(random(width),random(height));
    vel = new PVector(0,0);
    acc = new PVector(0,0);

    trail = new ArrayList();
  }

  void draw(){

    move();

    addTrail();
  }

  void move(){
    pos.add(vel);
    acc.add(new PVector(random(-10,10)/10.0,random(-10,10)/10.0));
    vel.add(acc);

    acc = new PVector(mouseX-pos.x,mouseY-pos.y);
    acc.mult(0.05);

    vel.mult(FRICTION);
    repulse(3);

  }

  void repulse(int num){
    for(int i = 0 ; i < num;i++){
      int idx = (int)random(plotters.size());
      Plotter tmp = (Plotter)plotters.get(i);
      PVector rep = new PVector(tmp.pos.x-pos.x,tmp.pos.y-pos.y);
      rep.mult(0.0304);
      acc.add(rep);
      vel.add(rep);
    }
  }

  void addTrail(){
    trail.add(new PVector(pos.x,pos.y));

    if(trail.size()>TRAIL_LENGTH)
      trail.remove(0);

    noFill();
    stroke(255,15);
    beginShape();
    for(int i = 1 ; i < trail.size();i++){
      PVector tmp1 = (PVector)trail.get(i-1);
      PVector tmp = (PVector)trail.get(i);

      //mmm..
      stroke(
          lerpColor(
            lerpColor(
              color(
                noise((frameCount+i)/10.0,0,0)*255,
                noise(0,(frameCount+i)/10.0,0)*255,
                noise(0,0,(frameCount+i)/10.0)*255),
              color(dist(tmp.x,tmp.y,tmp1.x,tmp1.y)*100),
              noise(frameCount/3.0+i/30.0))
            ,#ffcc00,
            map(atan2(tmp1.y-tmp.y,tmp1.x-tmp.x),-PI,PI,0,1))
          ,map(i,0,trail.size(),0.0,15.0));

      vertex(tmp.x,tmp.y);
    }
    endShape();

    if(trail.size()>1)
      for(int i = 1 ; i < trail.size();i++){
        PVector tmp1 = (PVector)trail.get(i);
        PVector tmp2 = (PVector)trail.get(i-1);
        tmp2.x -= cos((i/20.0+frameCount/10.1)/2.12+i/3.0) * 0.002 * i;
        tmp2.y -= sin((i/20.0+frameCount/10.1)/2.12+i/3.0) * 0.002 * i;
        tmp2.x -= (tmp1.x-tmp2.x)/50.1;
        tmp2.y -= (tmp1.y-tmp2.y)/50.1;


      }
  }
}


void generateRam(){

  ram = createGraphics(width,height,JAVA2D);

  ram.beginDraw();
  ram.strokeWeight(1);
  ram.stroke(255,40);
  for(int y = 0 ; y < height;y+=ROZPAL){
    for(int x = 0 ; x < width;x+=ROZPAL){
      ram.line(x-2.5,y,x+2.5,y);
      ram.line(x,y-2.5,x,y+2.5);
    }
  } 

  ram.stroke(0,100);
  ram.noFill();
  ram.strokeWeight(100);
  ram.rect(0,0,ram.width,ram.height);
  ram.filter(BLUR,10);

  ram.strokeWeight(1);
  ram.stroke(255,8);
  for(int y = 0 ; y < height;y+=ROZPAL){
    for(int x = 0 ; x < width;x+=ROZPAL){
      ram.line(x-3,y,x+3,y);
      ram.line(x,y-3,x,y+3);
    }
  }
  ram.endDraw();


}
