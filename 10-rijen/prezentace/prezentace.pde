/*
   Coded by Kof @ 
Fri Oct 18 01:07:28 CEST 2013



   ,dPYb,                  ,dPYb,
   IP'`Yb                  IP'`Yb
   I8  8I                  I8  8I
   I8  8bgg,               I8  8'
   I8 dP" "8    ,ggggg,    I8 dP
   I8d8bggP"   dP"  "Y8ggg I8dP
   I8P' "Yb,  i8'    ,8I   I8P
  ,d8    `Yb,,d8,   ,d8'  ,d8b,_
  88P      Y8P"Y8888P"    PI8"8888
                           I8 `8,
                           I8  `8,
                           I8   8I
                           I8   8I
                           I8, ,8'
                            "Y8P'
*/

import ddf.minim.*;
Minim minim;
AudioInput in;
float sc = 1.5;
int start = 0;

int state = 0;
float h,s,b;
int magicnum;

boolean sndviz = false;
PFont A,B,C;

String txt[] = {
  "",
  "obraz a algoritmus",
  "iluze a princip",
  "technický obraz",
  "fyzikální otisk jevu",
  "vzorkování jevu",
  "kódování / dekódování",
  "*.txt < *.jpg\n*.txt < *.mp4",
  "jazyk = brilantní komprese",
  "popis principu",
  "umělé jazyky",
  "zdrojový kód",
  "program",
  "textový vstup -> výpočet -> textový výstup",
  "textový vstup -> výpočet -> obrazový výstup",
  "processing",
  "svobodný software / svobodná kultura",
  "syntetický obraz",
  "geometrie",
  "limitace stroje",
  "pseudonáhodnost / determinismus",
  "výpočet probíhající v reálném čase",
  "interakce člověka se strojem",
  "live cinema"
};

String src[];

void init(){

  frame.removeNotify();
  frame.setUndecorated(true);
  frame.addNotify();
  super.init();
}

void setup(){
  size(1024,768,OPENGL);
  colorMode(HSB,1024);
  rectMode(CENTER);
  textAlign(CENTER);
  A = createFont("Gentium",36,true);
  B = createFont("Gentium",24,true);
  C = createFont("Gentium",12,true);
  
  src = loadStrings("prezentace.pde");

  frame.setLocation(0,0);

  minim = new Minim(this);
  minim.debugOn();

  noCursor();
  in = minim.getLineIn(Minim.STEREO, (int)(width*sc));
  
  in.mute();
  noSmooth();

}


void draw(){

  magicnum = (millis());
  h = (sin(magicnum/800000.0)+1.0)/2.0*1024.0;
  s = (sin(magicnum/900512.7)+1.0)/2.0*512.0;
  b = (sin(magicnum/100768.3)+1.0)/2.0*1024.0;


  background(h,s,b);

  noStroke();
  pushMatrix();
  translate(width/2,height/2);
  fill(magicnum);
  //ellipse(0,-100,20,20);
  fill(1024-h,s,1024-b);
 
  if(state>txt.length-1 && state < txt.length+1){
  textFont(A);
  textAlign(CENTER);
  text("millis() = "+magicnum,0,-100);
  textFont(B);
  textAlign(LEFT);
  text("(sin("+magicnum+"/800000.0)+1.0)/2.0*1024.0 = hue("+h+")",-260,0);
  text("(sin("+magicnum+"/900512.7)+1.0)/2.0*512.0 = sat("+s+")",-260,30);
  text("(sin("+magicnum+"/100768.3)+1.0)/2.0*1024.0 = val("+b+")",-260,60);
  }else if(state<txt.length){

  textAlign(CENTER);
    textFont(A);
    text(txt[state],0,0);
  }

  popMatrix();

  if(sndviz)
    sndviz();

  stroke(1024-h,s,1024-b);
  
  for(int i = 0 ; i < txt.length ; i++){
    float a = map(i,0,txt.length,0,width);
    line(a,height,a,height-5);
  }
  
  float time = map(millis(),0,1200000,0,width);
  line(time,height,time,height-7);

}

void keyPressed(){
  if(key == ' '){
    state++;
  }else if(key == '1'){
    state = txt.length;
  }else if(key == '2'){
    sndviz=!sndviz;
  }else if(keyCode==RIGHT){
    state++;
  }else if(keyCode==LEFT){
    state--;
  }

  if(state<0)state=txt.length;
  if(state>txt.length)state=0;


}


void sndviz(){


  float trsh = 0.012;
  noStroke();

  start = 0;

  for(int i = 0; i < 200 ; i++)
  {
    if(in.right.get(i)<0.01) {
      if(in.right.get(i+1)<0.01) {

        for(int q = 2;q<100;q++) {
          if(abs(in.right.get(i+q)-0)>trsh) {
            start = i;
            break;
          }
        }
        break;
      }
    }
  }

  for(int i = 0; i < in.bufferSize() - 1; i++)
  {
    stroke(map(in.right.get(int(i)),0.01,.04,0,1024),400);
    pushMatrix();
    translate(-start,0);
    line(i,0,i,height);
    popMatrix();
  }

}

void stop()
{
  in.close();
  minim.stop();

  super.stop();
}

