/*
Coded by Kof @ 
Tue Sep 17 20:18:51 CEST 2013



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

color C1 = color(255);
color C2 = color(10);

float FREQUENCY_X = 20.0;
float AMPLITUDE_X = 150.0;

float FREQUENCY_Y = 40.0;
float AMPLITUDE_Y = 25.0;

int LENGTH = 200;
float DENSITY = 40.0;
float RADIUS = 100.0;
float FOLLOW_SPEED = 1.5;
float DIVERSITY = 9.0;

float SHAKE = 2.0;

Creature creature;

void setup(){
  size(820,420,P2D);

  creature = new Creature(LENGTH);

  smooth();

  mouseX=width/2;
  mouseY=height/2;

}

void draw(){
  translate((noise(frameCount,0)-0.5)*SHAKE,(noise(0,frameCount)-0.5)*SHAKE);

  creature.generate();
  creature.follow();
  creature.draw();

  FREQUENCY_X = 20.0-(cos(frameCount/100.0)+1.0)*3.0;
  AMPLITUDE_X = 150+(cos(frameCount/100.0)+1.0)*100.0;

  noStroke();
 
  pushMatrix();

  translate(width/2,height/2);
  rotate(random(10));
  scale(3-random(10)/10.0);
  translate(-width/2,-height/2);


  beginShape();

  fill(C2,247);
  vertex(0,0);
  fill(C2,247);
  vertex(width,0);

  fill(C2,120);
  vertex(width,height);
  fill(C2,120);
  vertex(0,height);

  endShape(CLOSE);

  popMatrix();

}





class Creature{
  ArrayList layers;
  ArrayList points;
  ArrayList pos;

  int num;

  Creature(int _num){

    num = _num;
    pos = new ArrayList();
    for(int i = 0 ; i < num;i++){
      pos.add(new PVector(width/2,height/2));

    }
    generate();
  }

  void generate(){


    layers = new ArrayList();

    for(int i = 0 ; i < num;i++){
      points = new ArrayList();

      for(float f = 0 ; f < TWO_PI ; f += TWO_PI / DENSITY){
        float r = ((sin((i)/(num+0.0)*PI)+1.5)/2.0)*RADIUS*map(i,0,num,0,1)*map(i,0,num,1,0)*4.0;
        points.add(new PVector(
              cos(f)*r*noise(i/DIVERSITY,f,(frameCount+i/DIVERSITY)/100.0),
              sin(f)*r*noise(i/DIVERSITY,f,(frameCount+i/DIVERSITY)/100.0)
              )
            );
      }
      layers.add(points);
    }
  }

  void follow(){
    
    for(int i = 1 ; i < pos.size();i++){
      PVector current = (PVector)pos.get(i);
      PVector previous = (PVector)pos.get(i-1);

      current.x += (previous.x - current.x) / FOLLOW_SPEED;
      current.y += (previous.y - current.y) / FOLLOW_SPEED;
    }

    PVector first = (PVector)pos.get(0);
    first.x += ((mouseX+cos(frameCount/FREQUENCY_X)*AMPLITUDE_X)-first.x)/(FOLLOW_SPEED*20.0);
    first.y += ((mouseY+sin(frameCount/FREQUENCY_Y)*AMPLITUDE_Y)-first.y)/(FOLLOW_SPEED*20.0);
  }

  void draw(){
    for(int i = layers.size()-1; i >= 0;i--){
      ArrayList pnts = (ArrayList)layers.get(i);
      PVector p = (PVector)pos.get(i);

      pushMatrix();
      translate(p.x,p.y);
      rotate(PI);
 
      PVector a = new PVector(0,0);
      color c = color(0);

      beginShape();
      for(int ii = 0 ; ii < pnts.size();ii++){
        PVector tmp = (PVector)pnts.get(ii);
        
        fill(lerpColor(color(#010203),color(0),map(i,0,layers.size(),0,1)));
          
        
        if( ii == ((frameCount-i*0.5)+layers.size()*0.5) % pnts.size()){
          a = new PVector(tmp.x,tmp.y);
        c = color(sin(atan2(tmp.y,tmp.x))*255);
     
        }
       
        stroke(sin(atan2(tmp.y,tmp.x))*255);
        vertex(tmp.x,tmp.y);
      }
      endShape(CLOSE);  
    
      stroke(c);
      
      PVector b = new PVector(a.x,a.y);
      a.mult(0.2);
      translate(b.x,b.y);
      line(0,0,a.x,a.y);
 
      popMatrix();

    }
  }
}
