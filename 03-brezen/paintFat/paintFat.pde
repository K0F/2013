Brush b;

void setup(){
  size(400,400,P2D);

  smooth();
  b = new Brush(100);
}


void draw(){
  background(255);
  b.draw();


}

class Brush{


  PGraphics canv;
  PVector pos,ppos;
  float angle;
  float s;
  float nn = 10.0;
  float density = 0.5;
  float smoothing = 10.0;

  Brush(float _s){
    canv = createGraphics(width,height);
    s=_s;
    pos = new PVector(width/2,height/2);
    ppos = new PVector(width/2,height/2);

    canv.beginDraw();
    canv.background(255);
    canv.endDraw();
  }

  void draw(){
    if(ppos.x!=pos.x&&ppos.y!=pos.y){
      ppos.x = pos.x;
      ppos.y = pos.y;
    }
 
    pos.x = mouseX;
    pos.y = mouseY;
    
    angle = atan2(pos.y-ppos.y,pos.x-ppos.x) ;

    canv.beginDraw();
    canv.pushMatrix();
    canv.translate(pos.x,pos.y);
    canv.rotate(angle-HALF_PI);
    for(float i = -s; i < s;i+=density){
      canv.stroke(0,noise(i/nn)*25);
      canv.line(i,-10,i,10);
    }
    canv.popMatrix();

    canv.endDraw();
    image(canv,0,0);
  }
}
