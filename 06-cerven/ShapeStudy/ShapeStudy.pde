void setup(){

  size(640,640,OPENGL);

}


void draw(){


  background(0);

  translate(width/2,height/2);
  rotateX(frameCount/100.0);
  ellipse(screenX(-100,-100,-100),screenY(-100,-100,100),10,10);


}
