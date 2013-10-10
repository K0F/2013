color L,R;

float dist = 100;

void setup(){
  size(1600,900,P3D);
  L = color(#00FFEB);
  R = color(#FF0000);


}


void draw(){

  background(0);

  lights();

  pushMatrix();
  translate(width/2,height/2,0);

  pushMatrix();
  rotateY(frameCount/10.0);


  pushMatrix();
  fill(L);
  translate(-dist,0);
  box(130);
  popMatrix();


  pushMatrix();
  fill(R);
  translate(dist,0);
  box(130);
  popMatrix();

  popMatrix();
  popMatrix();

}

