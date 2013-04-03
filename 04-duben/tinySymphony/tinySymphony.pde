
import ddf.minim.*;
import ddf.minim.ugens.*;
import ddf.minim.signals.*;

Minim minim;
AudioOutput out;

void setup(){

  size(320,240);
  frameRate(25);

  minim = new Minim(this);
  out = minim.getLineOut(Minim.STEREO, 1024);
  

}


void draw(){
  background(0);
}

void keyPressed(){

  try{
 
  String [] not = {"A","C","D","F"};

  String tmp = not[(int)random(0,not.length)]+""+(int)random(2,6);

  out.playNote( 0.0 , 2.0 , new Tone( tmp , 0.2 , 2.0 , out ) );

  }catch(Exception e){println("Oops top leve!");}
}

void stop(){
  minim.stop();
  super.stop();
}

class Tone implements Instrument
{
ADSR env;
Oscil osc;
Frequency freq;
Delay delay;
Summer sum;
AudioOutput out;

Tone(String f, float att,float decay,AudioOutput output){
  out = output;
  sum = new Summer();
  delay = new Delay(random(0.4,3.5));
  freq = Frequency.ofPitch(f);
  osc = new Oscil( freq.asHz(), 0.8 );
  env = new ADSR(0.8,att,decay);
  
  try{
    osc.patch(env).patch(delay).patch(sum);
    sum.patch(out);
  }catch(Exception e){println("Oops!");}

}

void noteOn( float dur )
{
  env.noteOn();
}

void noteOff()
{
//  delay.unpatch(out);
//  osc.unpatch(out);
//  env.unpatch(out);
}

}
