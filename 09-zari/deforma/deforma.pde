
PImage img;

float density = 20.0;

float step,mstep;

float speed = 10.0;
float spread = 100.0;
float amp = 100.0;

void setup(){

  size(720,576,P2D);

  img = loadImage("test.jpg");

  textureMode(NORMAL);

  step = width / density; 
  mstep = 1.0 / density;


}

void draw(){

  background(0);

  noFill();
  noStroke();//stroke(255);

  float X = mouseX;
  float Y = mouseY;

  for(float y = 0 ; y<height ; y+=step){
    for(float x = 0 ; x<width ; x+=step){

      float nx1 = norm(x,0,width);
      float ny1 = norm(y,0,height);
      float nx2 = norm(x+step,0,width);
      float ny2 = norm(y,0,height);
      float nx3 = norm(x+step,0,width);
      float ny3 = norm(y+step,0,height);
      float nx4 = norm(x,0,width);
      float ny4 = norm(y+step,0,height);


      beginShape();
      texture(img);


      PVector a = new PVector((noise((frameCount+nx1*spread)/speed,0)-0.5)*amp,(noise(0,(frameCount+ny1*spread)/speed)-0.5)*amp);
      PVector b = new PVector((noise((frameCount+nx2*spread)/speed,0)-0.5)*amp,(noise(0,(frameCount+ny2*spread)/speed)-0.5)*amp);
      PVector c = new PVector((noise((frameCount+nx3*spread)/speed,0)-0.5)*amp,(noise(0,(frameCount+ny3*spread)/speed)-0.5)*amp);
      PVector d = new PVector((noise((frameCount+nx4*spread)/speed,0)-0.5)*amp,(noise(0,(frameCount+ny4*spread)/speed)-0.5)*amp);


      vertex(nx1*width+a.x,ny1*height+a.y,nx1,ny1);
      vertex(nx2*width+b.x,ny1*height+b.y,nx2,ny2);
      vertex(nx3*width+c.x,ny3*height+c.y,nx3,ny3);
      vertex(nx4*width+d.x,ny4*height+d.y,nx4,ny4);



      endShape();
    }
  }


}
