


void setup(){


  size(720,576,P2D);

  noSmooth();


}


void draw(){

  background(255);

  translate(width/2,height/2);

  stroke(0,15);

  int num = 3;

  for(int i = 0 ; i < num ; i++){
    pushMatrix();
    recurse(1,400,HALF_PI);
    popMatrix();
    rotate(PI/(float)num);
  }

}




void recurse(int in, int out,float an){

  an += 0.0000001*mouseX;

  line(0,0,in,0);
  translate(in,0);
  rotate(an);

  if(in++ < out)
    recurse(in,out,an);


}
