

int num = 10000;

void setup(){

  size(512,512,P2D);

  smooth();
}





void draw(){


  background(0);
  stroke(255,5);

  for(int i = 0 ; i < num ;i++){
  
    dline(cos((i*frameCount)/1000000.0)*width/2+width/2,sin((i*frameCount)/1000123.0)*height/2+height/2,width/2,height/2,noise(i+frameCount/100.0)*100.0);
  }

  fill(0);
  noStroke();
  ellipse(width/2,height/2,200,200);

}

void dline(float x1, float y1, float x2, float y2,float _step){

  float step = 1.0/(dist(x1,y1,x2,y2)/_step);

  for(float f = 0 ; f < 1.0; f += step*2)
    line(
        lerp(x1,x2,f),lerp(y1,y2,f),
        lerp(x1,x2,f+step),lerp(y1,y2,f+step)
        );

}
