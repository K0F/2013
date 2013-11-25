/**
Coded by Kof @ 
Wed Nov 20 16:13:14 CET 2013



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


import processing.core.*;
import processing.serial.*;
import java.nio.ByteBuffer;
import org.apache.commons.collections.buffer.CircularFifoBuffer;


boolean BROADCAST =  true;


float SMOOTHING = 50.0;

boolean debug = false;

float [][] vals;

eegPort eeg;
Serial serialPort;
String portName = "/dev/rfcomm0";
PFont font;


float val[];
float maxval = 1;
float smaxval = 1;

import oscP5.*;
import netP5.*;

int appState = 0;

OscP5 oscP5;


void setup() {
  size(320,240,P2D);

  val = new float[8];
  vals = new float[8][width];


  for(int i = 0 ; i < val.length;i++)
    val[i] = 0;


  oscP5 = new OscP5(this,"255.255.255.255",5003);
  
  connect();

}

void connect(){

  try{
    serialPort = new Serial(this, portName, 57600);
    eeg = new eegPort(this,serialPort);
    delay(500);
    eeg.refresh();
  }catch(Exception e){
    println("ERROR PRI CONNECTU:"+e);
  }


}


void serialEvent(Serial p) {

  println("incoming data!");

  while (p.available() > 0) {
    int inByte = p.read();
    println(inByte);
    eeg.serialByte(inByte);
    if (inByte == 170 && appState < 1) {
      println("Connected");
      appState = 1;
    }
  }
}

/**

  /m/raw -32000. az 32000 

  /m/meditation 0 az 100
  /m/focus 0 az 100
  /m/alfa 0 az 100
  ..
  ...
  /m/delta ....

 */

/*
void sendData(){

  OscMessage med = new OscMessage("/m/meditation");
  med.add(brain.meditation);
  oscP5.send(med);

  OscMessage att = new OscMessage("/m/attention");
  att.add(brain.attention);
  oscP5.send(att);

  OscMessage sig_quality = new OscMessage("/m/sig_quality");
  sig_quality.add(brain.signalQuality);
  oscP5.send(med);

  String names[] = {"delta","theta","lowAlpha","highAlpha","lowBeta","highBeta","lowGamma","highGamma"};

  OscMessage tmp; 
  for(int i = 0 ; i < names.length;i++){
    tmp = new OscMessage("/m/"+names[i]);
    tmp.add(val[i]);
    oscP5.send(tmp);
  }

}
*/

void draw() {

  try{
  eeg.refresh();
  //println(eeg.meditation);
  }catch(Exception e){
    println("ERROR: "+e);
  }
  /*
  brain.read();

  if( frameCount%4==0 &&  BROADCAST)
    sendData();

  int l = 8;
  float w = width / (8.0);

  background(0);

  for(int i = 0 ; i < l;i++){
    maxval = max(maxval,brain.eegPower[i]) ;    
  }

  smaxval += (maxval-smaxval) / 100.0;


  for(int i = 0 ; i < l;i++){
    val[i] += (map(brain.eegPower[i],0,smaxval,0,100)-val[i]) / SMOOTHING;


    vals[i][frameCount%(width-1)] = val[i];

    if(debug)
      print(val[i]+",");
    noStroke();
    fill(255,127,0,70);
    rect(w*i,height,w,map(val[i],0,100,0,-height));

  }

  noFill();
  stroke(255,120);
  for(int i = 0 ; i < l;i++){
    beginShape();
    for(int q = 0 ; q < vals[i].length;q++){
      vertex(q,map(vals[i][q],100,0,0,height));
    }
    endShape();
  }
  if(debug)
    println();
    */
}

