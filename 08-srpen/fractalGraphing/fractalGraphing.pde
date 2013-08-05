
PVector a,b;
float ITERATIONS = 4;
float num = 1;


void setup(){
  size(800,600,P2D);

  a = new PVector(0,height/2);
  b = new PVector(width,height/2);
}

void draw(){
  background(0);

  stroke(255,100);

  num += 0.005;

  for(int i = 0 ; i < num ;i++){
    pushMatrix();
    translate(width/2,height/2);
    rotate(i/(num+0.0)*TWO_PI);
    translate(-width/2,-height/2);
    fractal(a,b,i/(num+0.0)+abs(sin(i+frameCount/10.0)),ITERATIONS);
    popMatrix();
  }


}



void fractal(PVector a,PVector b, float pos,float _ITERATIONS){

  float it = _ITERATIONS-0.5;

  PVector center = (new PVector(lerp(a.x,b.x,0.1),lerp(a.y,b.y,0.1)));

  float n = noise((num+0.0)+frameCount/1000.0)*1.5;

  float d = dist(a.x,a.y,b.x,b.y);
  float theta = atan2(b.y-a.y,b.x-a.x)*n+n;
  PVector offset = new PVector(cos(theta)*(d*n)/20.0+center.x,n*sin(theta)*(d*n)/2.0+center.y);

  //if(it==0.5){
  line(a.x,a.y,offset.x,offset.y);
  line(b.x,b.y,offset.x,offset.y);
  //}
  if(it > 0){
    fractal(a,offset,pos,it);
    fractal(b,offset,pos,it);
  }
}
