

int MUTATE_RATE = 200;
int TRAIL_LENGTH = 400;

int num = 30;
ArrayList bot;

int fs = 9;

PVector cam;
float follow = 900.1;

void setup(){
  size(900,900,P2D);

  textFont(createFont("Monaco",fs,false));

  cam = new PVector(0,0);

  rectMode(CENTER);

  bot = new ArrayList();
  for(int i = 0 ; i< num ;i ++)
    bot.add(new Bot());
}

void draw(){
  background(0);


  pushMatrix();
  translate(-cam.x+width/2.0,-cam.y+height/2.0);
  rect(cam.x,cam.y,10,10);
  for(int i = 0 ; i< num ;i ++){
    Bot tmp = (Bot)bot.get(i);
    cam.x += (tmp.pos.x-cam.x) / follow ; 
    cam.y += (tmp.pos.y-cam.y) / follow ; 
    tmp.display();
  }
  popMatrix();

}


class Bot{
  String code;
  PVector pos;
  int num_var = 9;
  float [] thetas;
  PVector direction;
  float speed = 0.001;
  ArrayList vari;
  ArrayList trace;

  int w = 3;
  float smooth = 100.0;

  Bot(){
    code = generateCode(num_var);
    //pos = new PVector(random(width),random(height));
    pos = new PVector(width/2,height/2);

    speed= 3.0;

    thetas = new float[num_var];



    vari = new ArrayList();
    for(int i = 0 ; i < num_var;i++)
      vari.add((int)random(0,9));

    for(int i = 0; i < num_var;i++){
      int a = (Integer)vari.get(i);
      thetas[i] = (parseInt(code.charAt(a)));
    }

    trace = new ArrayList();

  }

  String generateCode(int siz){

    String result = "";

    for(int i = 0 ; i < 9;i++){
      result += (int)random(9);
    }

    return result;
  }


  void display(){


    pushMatrix();


    translate(pos.x,pos.y);

    fill(0);
    stroke(255);

    for(int i = 8 ; i >= 0;i--){

      pushMatrix();
      int a = (Integer)vari.get(i);
      thetas[i] += (((parseInt(code.charAt( (a+code.charAt(a)+code.charAt(i))%(code.length()-1) ))))-thetas[i])/smooth;
      rotate(thetas[i]);
      line(0,0,w*fs+(fs/2.0)*i,0);
      rect(w*fs+(fs/2.0)*i,0,5,5);
      rect(0,0,w*fs+(fs/2.0)*i,w*fs+(fs/2.0)*i);
      popMatrix();

    }

    direction = new PVector(0,0);
    for(int i = 0 ; i < thetas.length;i++){
      direction.add(new PVector(cos(thetas[i]),sin(thetas[i])));
    }
    direction.normalize();
    direction.mult(speed);
    pos.add(direction);

    translate(-w/2.0*fs,-w/2.0*fs);
    fill(255);
    int x = 0, y=0;
    for(int i = 0 ; i < code.length();i++){
      text(code.charAt(i),x*fs+fs/4.0,y*fs+fs-fs/4.0);

      x++;
      if(x==w){
        x=0;y++;
      }

    }

    popMatrix();

    if(frameCount%MUTATE_RATE==0)
      mutate();

    trace.add(new PVector(pos.x,pos.y));

    if(trace.size()>TRAIL_LENGTH)
      trace.remove(0);

    noFill();
    for(int i = 1 ; i< trace.size();i++){
      PVector tmp1 = (PVector)trace.get(i-1);
      PVector tmp2 = (PVector)trace.get(i);
      
      stroke(255,map(i,0,trace.size(),255,0));
      if(dist(tmp1.x,tmp1.y,tmp2.x,tmp2.y)<100)
        line(tmp1.x,tmp1.y,tmp2.x,tmp2.y);
    }

    border();
  }

  void mutate(){

    String base = code;

    int idx = (int)random(base.length());
    int ran = (int)random(0,10);
    code = code.substring(0,idx)+""+ran+""+code.substring(idx+1,base.length());

  }

  void border(){
    if(pos.x>cam.x+width/2+100)pos.x=cam.x-width/2-100;
    if(pos.x<cam.x-width/2-100)pos.x=cam.x+width/2+100;
    if(pos.y>cam.y+height/2+100)pos.y=cam.y-height/2-100;
    if(pos.y<cam.y-height/2-100)pos.y=cam.y+height/2+100;
  }

}


