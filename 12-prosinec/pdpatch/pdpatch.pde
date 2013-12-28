/*
Coded by Kof @ 
Sat Dec 28 19:42:34 CET 2013



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

import org.puredata.processing.PureData;
PureData pd;
PdReader n;


float tempo = 0.25;
float SEQ[] = {60,60*4,60*7,60*8,60*9};
boolean bang[] = new boolean[SEQ.length];
float fade[] = new float[SEQ.length];

void setup(){



  size(800,600,P2D);
textFont(createFont("SempliceRegular",9,false));

  pd = new PureData(this, 44100, 0, 2);

  pd.openPatch("test.pd");
  pd.start();

}

void init(){

   n = new PdReader("test.pd");

   super.init();

  

}

void draw() {


  for(int i = 0 ; i < bang.length;i++){
    if(fade[i] < 0){
      bang[i] = true;
      fade[i] = SEQ[i]*tempo;
    }

    fade[i]-=1;
  }

  pd.sendFloat("volume", 0.75);
  background(0);
  ellipseMode(CENTER);
  rectMode(CENTER);

  noStroke();

  float p = noise(frameCount/100.0)*22+66;
  pd.sendFloat("p", p); // Send float message to symbol "pitch" in Pd.
  
  for(int i = 0 ; i < bang.length;i++){
  
  fill(255,map(fade[i],0,SEQ[i],0,255));
  rect(map(i,0,bang.length-1,100,width-100), height/2.0, 100, 100);

    if(bang[i]){
      pd.sendBang("bng"+i);
      bang[i] = false;
    }
  }

  n.run();
}




void mouseReleased(){

  for(int i = 0;i<n.drag.length;i++){

    n.drag[i] = false;

  }

}
