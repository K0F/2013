
ArrayList signals;

void setup(){
  size(320,320);

  noSmooth();
  rectMode(CENTER);

  textFont(createFont("Semplice Regular",8,false));

  signals = new ArrayList();
  signals.add(new Signal());
}

void draw(){

  background(255);

  for(int i = 0 ; i < signals.size();i++){
    Signal s = (Signal)signals.get(i);
    s.draw();
  }

}


class Signal{



  PVector pos;

  Signal(){
    pos = new PVector(random(width),random(height));

  }


  void draw(){
    pushMatrix();

    translate((int)pos.x,(int)pos.y);
    fill(0);
    noStroke();
    text(signals.indexOf(this),0,0);
    rect(0,0,5,5);
    popMatrix();

  }


}
