import ddf.minim.spi.*;
import ddf.minim.signals.*;
import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.ugens.*;
import ddf.minim.effects.*;

Minim minim;
AudioOutput out;
Oscil       oscil,oscil2;
ADSR env;
Delay delay;

void setup(){
  size(512,440,P2D);

  minim= new Minim(this);
  out = minim.getLineOut();

  env = new ADSR(0.9,0.01, 1.2);

  delay = new Delay(0.02,0.3,true);
  oscil = new Oscil( 440, 0.4f, Waves.SINE );
  oscil2 = new Oscil( 440, 0.5f, Waves.SINE );


  oscil.patch( oscil2 ).patch( env ).patch( delay ).patch( out );

  rectMode(CENTER);

  
}


float midi2hz(int sel){
  float midi[] = new float[127];
  int a = 440; // a is 440 hz...
  for (int x = 0; x < 127; x++){
    midi[x] = (a / 32.0) * (pow((((x - 9.0) / 12.0)),2));
  }
  return midi[sel];
}


void draw(){
  background(0);
  fill(255);
  noStroke();

  if(frameCount%15==0){
    int a = (int)random(width-200)+100;

    rect(a,height/2,100,100);
    gen((int)map(a,0,width,30,44));

  }
 
  delay.setDelTime(noise(frameCount/10000.0));
  oscil2.setFrequency( midi2hz( (int)(noise(frameCount/100.0)*127) ));

}
void mousePressed(){
  }

void gen(int a){

  oscil.setFrequency(midi2hz(a));
  env.noteOn();

}

void stop(){
  minim.stop();
  super.stop();

}
