float frac = 330.0;

void setup(){
  size(400,400,P2D);
  noFill();
  noStroke();
  smooth();
}

void draw(){
  background(0);

  PVector pos = new PVector(noise(frameCount/100.0,0)*width,noise(0,frameCount/100.0)*width);


  float x = width/2;
  float y = height/2;

  frac = (sin(frameCount/2000.0)+1.0)*20.0;

  for(int i = (int)frac ; i > 0; i--){
    fill(i%2==0?color(255):color(0));
    
    x = lerp(pos.x, width/2 , i/frac ) ;
    y = lerp(pos.y, height/2, i/frac ) ;
    
    ellipse(x,y,i*width/frac,i*width/frac);
  }
}
