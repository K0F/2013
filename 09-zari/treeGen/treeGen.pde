
Tree tree;

void setup(){

  size(400,320);

  tree = new Tree();

}


void draw(){
  background(255);

  tree.draw();


}

class Tree{
  ArrayList branches;
  PGraphics trunk;
  PVector pos;

  float w = 20;

  Tree(){
    generateTrunk();
  }

  void generateTrunk(){
    
    trunk = createGraphics(100,300,JAVA2D);

    trunk.beginDraw();

    trunk.fill(255);
    trunk.smooth();
    trunk.stroke(0);
    trunk.beginShape();
    
    for(int i = 0 ; i < 30;i++){
      float x = 10-noise(i/5.0,0)*10;
      float y = i*5+10;
      trunk.vertex(x,y);
    }
    for(int i = 29 ; i >= 0;i--){
      trunk.vertex(10+w+noise(0,i/5.0)*10,i*5+10);
    }

    trunk.endShape(CLOSE);
    trunk.endDraw();

  }

  void draw(){
    image(trunk,width/2,height/2);
  }



}
