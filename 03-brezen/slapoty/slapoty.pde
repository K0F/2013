

PImage stopy[];

void setup(){
  size((int)(16500/10.0*3),(int)(1500/10.0*3));


  stopy = new PImage[6];
  for(int i = 1 ; i < stopy.length;i++){
    stopy[i] = loadImage(i+".png");
  }


  float sc = 20.0;
  imageMode(CENTER);

  background(255);

  for(int i = 0 ; i < (int)(width/25.0);i++){
    int ran = (int)random(stopy.length-1)+1;
   
    sc = random(5/3.0,50/3.0);
    pushMatrix();
    translate(random(width),random(height));
    rotate(random(TWO_PI));
    image(stopy[ran],0,0,stopy[ran].width/sc,stopy[ran].height/sc);
    popMatrix();
  }

  save("4slapotyB.png");

  //exit();
}
