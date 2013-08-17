
float sett[] = {1,2,3,3,3,3,3,4,4,4,4,23,2,3};
int id = 0;

void setup(){


  size(720,576,P2D);

  noSmooth();


}


void draw(){

  background(255);

  translate(width/2,height/2);

  stroke(0,15);

  int num = 100;

  if(frameCount%100==0)
    id ++;

  for(int i = 0 ; i < num ; i++){
    pushMatrix();
    recurse(1,400,HALF_PI);
    popMatrix();
    rotate(PI/(float)num);
  }

}




void recurse(int in, int out,float an){

  an += (sett[id%sett.length]*0.1*PI-an)/100000000.0;


  line(0,0,in,0);
  translate(in,0);
  rotate(an);

  if(in++ < out)
    recurse(in,out,an);


}
