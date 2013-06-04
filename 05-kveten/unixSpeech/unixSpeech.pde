
//////////////////////////////////////

import java.util.LinkedList;

XML xml;
XML title[];

PFont f;

//////////////////////////////////////

String RSS_FEED = "http://rss.cnn.com/rss/cnn_latest.rss";
String FILTR = "channel/item/title";
int LINE_HEIGHT = 16;
int MAX_MSG_CNT = 1000;
int s;


//////////////////////////////////////
//http://rss.cnn.com/rss/cnn_latest.rss
//////////////////////////////////////

LinkedList zpravy,precteneZpravy;


void setup() {
  background (0);
  size(720, 560);
  frameRate(5);
  s = 16;
  f = createFont("Arial", s, true);

  nactiZpravyPoprve();
  //bruteReload();
}

void draw () {
  background(0);

  reload();

  fill(255);


  for(int i = 0;  i < zpravy.size() ; i++){
    String tmp = (String)zpravy.get(i);
    //println( minute() + ":" + second()+ "prvni i " + i);
    text( tmp, 10, i * LINE_HEIGHT + 20 );
    //println (tmp);
  }
}

void keyPressed(){
}

///////////////////////////////////////////////

void bruteReload(){


  xml = loadXML(RSS_FEED);
  title = xml.getChildren(FILTR);

  zpravy = new LinkedList();
  //precteneZpravy = new ArrayList();

  for(int i = 0 ; i < title.length ; i++){
    zpravy.add((String)title[i].getContent()+"");
    //precteneZpravy.add((String)title[i].getContent()+"");
  }


  Kecal k = new Kecal(this,"Number of frames rendered: "+frameCount+".");
  k.start();


}


///////////////////////////////////////////////

void reload(){
  if(frameCount % 60 == 0){
    nactiZpravy();
    //bruteReload();
    println(hour() +":"+ minute() +":"+ second() +"  "+ "reloaded");

  }

  /*
     if(zpravy.size()*LINE_HEIGHT > height){
     precteneZpravy.add((String)zpravy.get(0));
     zpravy.remove(0);
     }

     if(precteneZpravy.size() > MAX_MSG_CNT){
     precteneZpravy.remove(0);
     }
   */
}

///////////////////////////////////////////////

void nactiZpravyPoprve(){
  xml = loadXML(RSS_FEED);
  title = xml.getChildren(FILTR);

  zpravy = new LinkedList();
  precteneZpravy = new LinkedList();

  for(int i = 0 ; i < title.length ; i++){

    zpravy.add((String)title[i].getContent()+"");
    precteneZpravy.add((String)title[i].getContent()+"");
  }
}

///////////////////////////////////////////////

void nactiZpravy(){

  xml = loadXML(RSS_FEED);

  title = xml.getChildren(FILTR);

  boolean uzMam = false;

  int counter = 0;

  println("check ----------------------------v");
  for(int ii = 0 ; ii < title.length; ii++){
    println(title[ii].getContent()+"");

    uzMam = false;
    //println("false 1 ");

    /*
       for (int i = 0 ; i < zpravy.size() ; i++){
       println("druhe i " + i);
       String tmp = (String)zpravy.get(i);
       if(tmp.equals(title[ii].getContent()) && i != ii ){
       uzMam = true;
    //println("true2 ");
    }
    } 
     */

    for(int i = 0 ; i < precteneZpravy.size(); i++){
      String prectene = (String)precteneZpravy.get(i);
      if(prectene.equals(title[ii].getContent()+"") && i != ii ){
        uzMam = true;
      }
    }

    if(!uzMam){

      Kecal k = new Kecal(this,title[ii].getContent()+"");
      k.start();

      zpravy.addFirst((String)title[ii].getContent()+""); //tadz jsem to nahradil
      precteneZpravy.addFirst((String)title[ii].getContent()+""); //tadz jsem to nahradil
      counter++;
      println(hour() +":"+ minute() +":"+ second() +"  "+ "!uzmam");
      uzMam = false; //prepnuti
    }
  }

  println(hour() +":"+ minute() +":"+ second() +"  "+ "Refresh "+ counter + " zprav pridano.");
}



/////////////////////////////////////
/////////////////////////////////////
/////////////////////////////////////

class Kecal implements Runnable{

  String command;
  PApplet parent;

  Thread thread;

  Kecal(PApplet _parent, String _command){
    parent = _parent;
    parent.registerDispose(this);

    command =  _command;

  }


  public void start() {
    thread = new Thread(this);
    thread.start();
  }

  public void run(){

    try{

      String tmp[] = {"espeak","-s 10","-p 90", command};
      Process p = Runtime.getRuntime().exec(tmp); 
      p.waitFor();

    }catch(Exception e){;}

    println("Job done!");
  }

  public void dispose(){
    stop();
  }
}


