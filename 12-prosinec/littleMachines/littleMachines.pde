
void setup(){


}



void draw(){


}


class Machine(){
  PGraphics img;
  PVector pos;
  int dim = 16;

  Machine(){
    pos = new PVector(random(width),random(height));
    create();
  }

  void create(){
    img = createGraphics(dim,dim,JAVA2D);
  }

  void draw(){
    image(img,(int)pos.x,(int)pos.y);
  }

  void update(){

    for(int y = 0;y<img.height;y++){
      for(int x = 0;x<img.width;x++){

      }
    }


  }

}
