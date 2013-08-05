
PVector a,b;
float ITERATIONS = 4;
float num = 1;


void setup(){
  size(800,800,P2D);

  a = new PVector(200,height/2);
  b = new PVector(width-200,height/2);
}

void draw(){
  background(0);

  stroke(255,20);

  num += 0.05;

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

  float n = noise(frameCount/1000.0)*0.5;

  float d = dist(a.x,a.y,b.x,b.y);
  float theta = atan2(b.y-a.y,b.x-a.x)*n+n;
 
  PVector center = (new PVector(lerp(a.x,b.x,0.5)+cos(theta)*it*10.0,lerp(a.y,b.y,0.5)+sin(theta)*it*10.0));

  PVector offset = new PVector(cos(theta)*(d*n)/20.0+center.x,n*sin(theta)*(d*n)/2.0+center.y);

  if(d<100){
  line(a.x,a.y,offset.x,offset.y);
  line(b.x,b.y,offset.x,offset.y);

  pushMatrix();
  translate((a.x+b.x)/2.0+noise(it/10.0+frameCount/11.123)*100.0,(a.y+b.y)/2.0);
  rotate(-theta);
  line(d*n,0,sin(frameCount/10.0)*sin(frameCount/33.33)*10.0,n);
  popMatrix();
  }
  if(it > 0){
    fractal(a,offset,pos,it);
    fractal(b,offset,pos,it);
  }
}
