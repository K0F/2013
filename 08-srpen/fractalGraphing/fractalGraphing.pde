
PVector a,b;

void setup(){

  size(320,240,P2D);


  a = new PVector(0,height/2);
  b = new PVector(width,height/2);
}

void draw(){
  background(0);

  stroke(255);


  fractal(a,b,map(mouseX,0,width,0,1));


}



void fractal(PVector a,PVector b, float pos){

  pos = constrain(pos,0.1,0.9);
  PVector center = (new PVector(lerp(a.x,b.x,pos),lerp(a.y,b.y,pos)));
  

  float d = dist(a.x,a.y,b.x,b.y);
  float theta = atan2(b.y-a.y,b.x-a.x)+HALF_PI;
  PVector offset = new PVector(cos(theta)*d/2.+center.x,sin(theta)*d/2.+center.y);

  line(a.x,a.y,offset.x,offset.y);
  line(b.x,b.y,offset.x,offset.y);

  if(d>1){
  fractal(a,offset,pos);
  fractal(b,offset,pos);
  }
}
