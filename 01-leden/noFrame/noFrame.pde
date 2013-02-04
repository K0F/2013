void setup(){
  size(200,200);
  background(255);


}


void init(){
  frame.removeNotify();
  frame.setUndecorated(true);
  frame.addNotify(); 
  super.init();
}


void draw(){

  frame.setLocation((int)(noise(frameCount/100.0)*(displayWidth-width)),0);

}
