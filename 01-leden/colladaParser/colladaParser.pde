boolean DEBUG  = true;

Collada test;

float SCALE = 150.0;
Runnable runnable;
Thread thread;

PShape zzz;

void setup(){

  size(640,480,P3D);

  zzz = createShape();

  noSmooth();
  runnable = new Collada("test2.dae");
  thread = new Thread(runnable);
  thread.start();
}


void draw(){

  background(255);

  pushMatrix();
  translate(width/2,height/2);
  scale(SCALE);
  pointLight(255,255,255,-5,-5,5);
  rotateX(HALF_PI);
  rotateZ(radians(frameCount/3.0));
  noStroke();//stroke(0);
  fill(255,0,0);

//  shape(zzz,0,0);
  if(test!=null)
    test.drawFaces();
  //
  //test = new Collada("test2.dae");

  popMatrix();

}

class Collada implements Runnable{
  String filename;
  XML raw;

  boolean loaded = false;

  ArrayList pos;
  ArrayList norm;
  ArrayList vcount;
  ArrayList faces;


  Collada(ArrayList _pos,ArrayList _norm,ArrayList _vcount, ArrayList _faces){
      pos = _pos;
      norm = _norm;
      vcount = _vcount;
      faces = _faces;
  }

  Collada(String _filename){
    filename = _filename;
  }

  void run(){
    raw = loadXML(filename);

    parseGeometry();


  }

  void parseGeometry(){
    pos = new ArrayList();
    norm = new ArrayList();
    vcount = new ArrayList();
    faces = new ArrayList();

    XML g[] = raw.getChildren("library_geometries");
    XML mesh = new XML("mesh");
    //////////////////////////////
    int idx = 0;

    for(int i = 0 ; i< g.length;i++){
      for(int q = 0; q < g[i].getChildCount();q++){
        XML tmp = g[i].getChildren()[q];
        if(tmp.getChildCount()>0){
          mesh = tmp.getChildren()[q];
        }
      }
    }

    String s = mesh.getContent();
    String lines [] = splitTokens(s,"\n\t");


    ArrayList data = new ArrayList();


    for(int i = 0; i < lines.length;i++){
      if(splitTokens(lines[i]," ").length > 0){
        data.add(lines[i]+"");
      }
    }
    ///////////////////

    String p[] = splitTokens((String)data.get(0)+""," ");

    for(int i = 2 ; i < p.length ; i+=3){
      PVector tmp = new PVector(
          parseFloat(p[i-2]),parseFloat(p[i-1]),parseFloat(p[i])
          );

      pos.add(tmp);
    }
    ///////////////////

    p = splitTokens((String)data.get(1)+""," ");

    for(int i = 2 ; i < p.length ; i+=3){
      PVector tmp = new PVector(
          parseFloat(p[i-2]),parseFloat(p[i-1]),parseFloat(p[i])
          );

      norm.add(tmp);
    }
    /////////////////////
    //
    //

    p = splitTokens((String)data.get(2)+""," ");

    for(int i = 0 ; i < p.length ; i+=1){
      int tmp = parseInt(p[i]);

      vcount.add(tmp);
    }
    /////////////////////

    p = splitTokens((String)data.get(3)+""," ");

    int offset = 8;
    for(int f = offset; f < p.length+1 ;f+=8){
      int a = parseInt(p[f-8]);
      int b = parseInt(p[f-6]);
      int c = parseInt(p[f-4]);
      int d = parseInt(p[f-2]);
     
      int na = parseInt(p[f-7]);
      int nb = parseInt(p[f-5]);
      int nc = parseInt(p[f-3]);
      int nd = parseInt(p[f-1]);
       
      Face tmp = new Face(a,b,c,d,na,nb,nc,nd);

      faces.add(tmp);

    }
    /////////////////////



    //loaded = true;
    //createShape();
    test = new Collada(pos,norm,vcount,faces);
    //createShape();
    println("JOB DONE!");

    println("got "+pos.size()+" verticles");
    println("got "+norm.size()+" normals");
    println("got "+vcount.size()+" faces");
    println("got "+faces.size()+" f+n");
  }

  public boolean loaded(){
    return loaded;
  }

  void createShape(){
     for(int i = 0 ; i < faces.size();i++){
      Face f = (Face)faces.get(i);
      PVector a = (PVector)pos.get(f.idx[0]);
      PVector b = (PVector)pos.get(f.idx[1]);
      PVector c = (PVector)pos.get(f.idx[2]);
      PVector d = (PVector)pos.get(f.idx[3]);

      PVector na,nb,nc,nd;
      //try{
      na = (PVector)norm.get(f.idx[4]);
      nb = (PVector)norm.get(f.idx[5]);
      nc = (PVector)norm.get(f.idx[6]);
      nd = (PVector)norm.get(f.idx[7]);


//      zzz.beginContour();
     // beginShape();
      zzz.normal(na.x*SCALE,na.y*SCALE,na.z*SCALE);
      zzz.vertex(a.x*SCALE,a.y*SCALE,a.z*SCALE);
      zzz.normal(nb.x*SCALE,nb.y*SCALE,nb.z*SCALE);
      zzz.vertex(b.x*SCALE,b.y*SCALE,b.z*SCALE);
      zzz.normal(nc.x*SCALE,nc.y*SCALE,nc.z*SCALE);
      zzz.vertex(c.x*SCALE,c.y*SCALE,c.z*SCALE);
      zzz.normal(nd.x*SCALE,nd.y*SCALE,nd.z*SCALE);
      zzz.vertex(d.x*SCALE,d.y*SCALE,d.z*SCALE);
  //    zzz.endContour();

      println(zzz.getVertexCount());
      //endShape();
      //}catch(Exception e){;}
    }

 

  }


  void plot(){
    for(int i = 0 ; i < pos.size();i++){
      PVector tmp = (PVector)pos.get(i);
      line(tmp.x+1,tmp.y,tmp.z,tmp.x-1,tmp.y,tmp.z);
      line(tmp.x,tmp.y+1,tmp.z,tmp.x,tmp.y-1,tmp.z);
      line(tmp.x,tmp.y,tmp.z+1,tmp.x,tmp.y,tmp.z-1);
    }
  }

  void drawFaces(){
    for(int i = 0 ; i < faces.size();i++){
      Face f = (Face)faces.get(i);
      PVector a = (PVector)pos.get(f.idx[0]);
      PVector b = (PVector)pos.get(f.idx[1]);
      PVector c = (PVector)pos.get(f.idx[2]);
      PVector d = (PVector)pos.get(f.idx[3]);

      PVector na,nb,nc,nd;
      //try{
      na = (PVector)norm.get(f.idx[4]);
      nb = (PVector)norm.get(f.idx[5]);
      nc = (PVector)norm.get(f.idx[6]);
      nd = (PVector)norm.get(f.idx[7]);



      beginShape();
      normal(na.x,na.y,na.z);
      vertex(a.x,a.y,a.z);
      normal(nb.x,nb.y,nb.z);
      vertex(b.x,b.y,b.z);
      normal(nc.x,nc.y,nc.z);
      vertex(c.x,c.y,c.z);
      normal(nd.x,nd.y,nd.z);
      vertex(d.x,d.y,d.z);
      endShape();
      //}catch(Exception e){;}
    }

  }


}

class Face{
  int idx[];

  Face(int a,int b,int c, int d){
    idx = new int[4];
    idx[0] = a;
    idx[1] = b;
    idx[2] = c;
    idx[3] = d;
  }

  Face(int a,int b,int c, int d,int na, int nb, int nc, int nd){
    idx = new int[8];
    idx[0] = a;
    idx[1] = b;
    idx[2] = c;
    idx[3] = d;
    idx[4] = na;
    idx[5] = nb;
    idx[6] = nc;
    idx[7] = nd;
  }

}
