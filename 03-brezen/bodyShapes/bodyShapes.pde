import saito.objloader.*;

int num = 200;
ArrayList seekers;

OBJModel s;
ArrayList vertices,normals;
String fileName = "torsoid.obj";

boolean debug = true;
int TRAIL_LENGTH = 30;
int SKIP = 1;

float SCALE = 50.0;

void setup() {
  size(640, 480, P3D);


noSmooth();
strokeWeight(1);
  stroke(0,120);

  s = new OBJModel(this, fileName);;

  s.scale(SCALE);


  normals = new ArrayList();
  vertices = new ArrayList();

  for (int j = 0; j < s.getSegmentCount(); j++) {

    Segment segment = s.getSegment(j);
    Face[] faces = segment.getFaces();

    noFill();


    for(int i = 0; i < faces.length; i ++)
    {
      PVector[] vs = faces[i].getVertices();
      PVector[] ns = faces[i].getNormals();
      for(int k = 0 ; k < vs.length;k++){
        vertices.add(vs[k]);
      }

      for(int k = 0 ; k < ns.length;k++){
        normals.add(ns[k]);
      }
    }


  }

  if(debug)
    println("Yup, got "+fileName+" with "+vertices.size()+" vertices.");

  seekers = new ArrayList();

  for(int i = 0 ; i < num;i++)
    seekers.add(new Seeker());
}


void draw(){

  pushMatrix();

  translate(width/2,height/2,0);
  rotateY(frameCount/100.0);
  //scale(SCALE);
  background(255);
 /* 
  for(int i = 0 ; i < vertices.size();i++){
    PVector tmp = (PVector)vertices.get(i);
    line(tmp.x,tmp.y,tmp.z,tmp.x,tmp.y+2,tmp.z);
  }
  */

  for(int i = 0 ; i< seekers.size();i++){
    Seeker tmp = (Seeker)seekers.get(i);
    tmp.draw();
  } 


  popMatrix();

}

class Seeker{
  PVector pos;
  PVector dir;
  PVector target;
  ArrayList trail;
  int tar;

  float speed;

  Seeker(){
    pos = new PVector(random(-100,100),random(-100,100),random(-100,100));
    tar = (int)random(vertices.size());
    target = (PVector)vertices.get(tar);
    dir = getDirectionTo(target.x,target.y,target.z);
    trail = new ArrayList();
    speed = 0.5;
    
  }

  PVector getDirectionTo(PVector in){
    PVector tmp =  new PVector(in.x - pos.x, in.y - pos.y, in.z - pos.z);
    tmp.normalize();
    tmp.mult(speed);
    return tmp;
  }

  PVector getDirectionTo(float inx, float iny, float inz){
    PVector tmp = new PVector(inx - pos.x, iny - pos.y, inz - pos.z);
    tmp.normalize();
    tmp.mult(speed);
    return tmp;
  }


  void move(){

    dir = getDirectionTo(target.x,target.y,target.z);
    pos.add(dir);

  }

  void changeTarget(){

    float mm = 1000;
    int chosen = 0;
    boolean hassome = false;

    int lasttar = tar;
    for(int i = 0 ; i < vertices.size() ; i++){
      if(i!=tar && i!=lasttar){  
      PVector tmp = (PVector)vertices.get((int)random(vertices.size()));
        float d = dist(pos.x,pos.y,pos.z,tmp.x,tmp.y,tmp.z);

        if(d<mm){
          chosen = i;
          hassome = true;
          tar = chosen;
        }

        mm = min(mm,d);

      }
    }

    if(!hassome)
      return;


    target = (PVector)vertices.get(chosen);
    

  }

  void draw(){
    move();
    //line(pos.x,pos.y,pos.z,pos.x,pos.y-2,pos.z);

    if(dist(pos.x,pos.y,pos.z,target.x,target.y,target.z)<0.6)
      changeTarget();

    leaveTrail();
    drawTrail();
  }

  void drawTrail(){
    for(int i = SKIP ; i < trail.size();i+=SKIP){

      PVector first = (PVector)trail.get(i-SKIP);
      PVector second = (PVector)trail.get(i);

      line(first.x,first.y,first.z,second.x,second.y,second.z);
    }

  }

  void leaveTrail(){
    trail.add(new PVector(pos.x,pos.y,pos.z));
    if(trail.size()>TRAIL_LENGTH)
      trail.remove(0);
  }

}
