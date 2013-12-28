class PdReader{
  String [] pd;
  String filename;
  boolean drag[];
  
  int mainResX,mainResY;
  
  int tempx,tempy;

  Objekt o[] = new Objekt[0];  
  Drat d[] = new Drat[0];

  int objCntr = 0;

  PdReader(String _filename){
    filename=_filename+"";
    pd = loadStrings(filename);
    analyze();

    drag = new boolean[o.length];
    for(int i = 0;i<drag.length;i++){
      drag[i] = false; 
    }
    
    String[] mainn = splitTokens(pd[0]," ;");
    mainResX = parseInt(mainn[4]);
    mainResY = parseInt(mainn[5]);

    println(objCntr+" PD objects loaded");
  }

  void analyze(){

    for(int i = 0;i<pd.length;i++){

      String singleline = pd[i]+"";
      String[] tokens = splitTokens(singleline," ;");
      if(tokens.length>1){
        if(tokens[1].equals("obj")||tokens[1].equals("msg")||
          tokens[1].equals("floatatom")||tokens[1].equals("text")||
          tokens[1].equals("symbolatom")){
          int x = parseInt(tokens[2]);
          int y = parseInt(tokens[3]);
          String name = "";
          for(int z = 4 ;z < tokens.length; z++){
           if(!tokens[z].equals("empty") && !tokens[4].equals("bng"))
           name += tokens[z]+" ";          
           }
          //println("debug: "+name);
          createObjekt(x,y,name,objCntr);
          objCntr++;
        }



        if(tokens.length>1&&tokens[1].equals("connect")){
          //println(tokens[q]);
          int x = parseInt(tokens[2]);
          int y = parseInt(tokens[3]); 
          int x2 = parseInt(tokens[4]);
          int y2 = parseInt(tokens[5]); 

          createDrat(x,y,x2,y2);         
        }      
      }
    } 
  } 

  void createObjekt(int x,int y,String _name,int id){
    o = (Objekt[])expand(o,o.length+1);
    o[o.length-1]=new Objekt(x,y,_name,id,this); 
  }

  void createDrat(int father,int posF,int son,int posS){
    d = (Drat[])expand(d,d.length+1);
    d[d.length-1]=new Drat(father,posF,son,posS,this); 
  }

  void run(){
    for(int i = 0;i<d.length;i++){
      d[i].draw();    
    }
    
    for(int i = 0;i<o.length;i++){
      o[i].draw();    
    }
    move();
  }

  void move(){ 
    for(int i = 0;i<o.length;i++){
      if(drag[i]){
        o[i].x=mouseX+tempx;
        o[i].y=mouseY+tempy;
        break;
      }      
    }

    if(mousePressed){
      for(int i = 0;i<o.length;i++){
        if(o[i].over()){
          tempx=o[i].x-mouseX;
          tempy=o[i].y-mouseY;
          drag[i] = true;
        }
      }
    }   
  }

}

class Objekt{
  PdReader parent;
  int x,y;
  String name;
  int id;
  int delka;
  int posunY = 10;

  Objekt(int _x,int _y,String _name,int _id,PdReader _parent){
    parent=_parent;
    x = _x;
    y = _y;
    name = _name+"";
    id=_id;

    delka = (int)textWidth(name)+3;

  }

  void draw(){
    if(over()||parent.drag[id])fill(#FFCC00);else fill(120);  
    stroke(0);
    pushMatrix();
    translate(0,posunY);
    rectMode(CORNER);
    rect(x-3,y,delka,-10);
    noStroke();
    fill(255);
    rect(x-3,y+1,delka,2);
    rect(x-3,y-11,delka,2);
    text(name,x,y);
    popMatrix();
  }

  boolean over(){
    boolean ovr = false;
    if(mouseX>x-3&&mouseX<x-3+delka&&mouseY<y+posunY&&mouseY>y-10+posunY){
      ovr=true;
    } 
    return ovr;
  }


}

class Drat{
  PdReader parent;
  int father, son, posF, posS;
  float x,y,x2,y2;

  Drat(int _father,int _posF,int _son,int _posS,PdReader _parent){
    parent=_parent;
    father=_father;
    son=_son;
    posF=_posF;
    posS=_posS;      
  } 

  void setup(){
    x = parent.o[father].x;
    y = parent.o[father].y+10;
    x2 = parent.o[son].x;
    y2 = parent.o[son].y;
  }

  void draw(){
    setup();
    stroke(255,30);
    line(x,y,x2,y2);
  }


}

