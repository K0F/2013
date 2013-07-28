float frac = 17;

float slope = 0.80;
float sc = 1.5;
float nx,ny;
PVector one,two,shift;
float TH = 0;
float depth = 1;

void setup(){
  size(720,720,P2D);
}

void draw(){


  one = new PVector(100,height/2);
  two = new PVector(width-100,height/2);



  fill(0,10);
  rect(0,0,width,height);

  nx = noise(frameCount/1000.0,0)*sc;
  ny = noise(0,frameCount/1000.0)*sc;
  stroke(255,20);


  for(int i= 0 ; i < frac;i++){
    TH = frameCount/200.0+i*(TWO_PI/frac);
    pushMatrix();
    translate(width/2,height/2);
    rotate(-TH);
    translate(-width/2,-height/2);

    fractal(one,two,depth);
    popMatrix();
  }
}

void fractal(PVector p1,PVector p2,float depth){

  float d = dist(p1.x,p1.y,p2.x,p2.y);
  if(d>=1){
    float theta = atan2(p2.y-p1.y,p2.x-p1.x)+(frameCount)/((1/depth)*1000.0*depth+depth*depth);



    PVector p3 = 
      new PVector(
          (p1.x+p2.x)/2.0+cos(theta)*nx*d/2.0,
          (p1.y+p2.y)/2.0+sin(theta)*nx*d/2.0);


    stroke(lerpColor(#ffcc00,#00ccff,map(theta,-PI,PI,0,1)),10);
    if(d<50)
    line(p1.x,p1.y,p2.x,p2.y);
    depth *= slope;

    if(depth >= 0.1){
      fractal(p1,p3,depth);
      fractal(p2,p3,depth);
    }
  }

}
