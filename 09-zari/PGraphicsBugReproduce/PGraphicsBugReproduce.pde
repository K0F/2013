PGraphics test;

void setup(){
  size(200,200,P2D);
  test = createGraphics(100,100,P2D);
  test.beginDraw();
  test.rect(10,10,20,20);
  test.endDraw();

  background(255);
}

void draw(){
  background(255);
  image(test,-1,-1);
}


