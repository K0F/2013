

ArrayList machines;
int NUM = 3000;
int DIM = 8;

void setup(){

  size(320,320);
  noSmooth();
  colorMode(HSB,255);

  machines = new ArrayList();

  for(int i = 0 ; i < NUM;i++)
    machines.add(new Machine());

}



void draw(){
  background(0);
  for(int i = 0 ; i < machines.size();i++){
    Machine m = (Machine)machines.get(i);
    m.draw();
  }

}


class Machine{
  PGraphics img;
  color col;
  PVector pos;
  float speed = 10.0;
  int dim = DIM;

  int cycle = 10;
  
  Machine(){
    cycle = (int)random(10,250);
    speed = random(50,2000);
    col = color(random(255),random(255),random(255));
    pos = new PVector(random(width),random(height));
    create();
  }

  void create(){
    img = createGraphics(dim,dim,JAVA2D);
  }

  void draw(){
    update();
    pushMatrix();
    translate((int)pos.x,(int)pos.y);
    rotate(frameCount/speed);
    image(img,0,0);
    popMatrix();
  }

  void update(){

    if(frameCount%cycle==0)
      col = color(random(255),random(255),random(255));

    img.loadPixels();

    for(int y = 0;y<img.height;y++){
      for(int x = 0;x<img.width;x++){
        color c = color(img.pixels[y*img.width+x]);
        img.pixels[y*img.width+x] = lerpColor(c,col,random(10)/100.0);
      }
    }

    img.updatePixels();
    

  }

}
