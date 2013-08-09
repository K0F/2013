
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
  float theta = atan2(b.y-a.y,b.x-a.x)+it;
 
  PVector center = (new PVector(lerp(a.x,b.x,n)+cos(theta)*it*10.0,lerp(a.y,b.y,n)+sin(theta)*it*10.0));
  PVector offset = new PVector(cos(theta)*10.0+center.x,sin(theta)*10.0+center.y);
  pushMatrix();
  translate((a.x+b.x)/2.0+noise(it/10.0+frameCount/100.123)*1000.0,(a.y+b.y)/2.0);
  rotate(-theta*it*n);
  line(-d*n,n*10.0,d*n,n*10.0);
  popMatrix();
  if(it > 0){
    fractal(a,offset,pos,it);
    fractal(b,offset,pos,it);
  }

}
