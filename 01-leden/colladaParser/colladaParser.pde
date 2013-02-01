boolean DEBUG  = true;

Collada test;

float SCALE = 160.0;

void setup(){

  size(640,480,P3D);

  test = new Collada("test2.dae");


}


void draw(){

  background(255);

  pointLight(255,255,255,-5*SCALE,-5*SCALE,-5*SCALE);
  pushMatrix();
  translate(width/2,height/2);
  rotateX(HALF_PI);
  rotateZ(radians(frameCount/10.0));
  noStroke();
  fill(255,0,0);
  test.drawFaces();
  popMatrix();

}

class Collada{
  String filename;
  XML raw;

  ArrayList pos;
  ArrayList norm;
  ArrayList vcount;
  ArrayList faces;



  Collada(String _filename){
    filename = _filename;
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

    int offset = 6;
    for(int f = 0; f < vcount.size();f++){
      int a = (Integer)vcount.get(f)*2;

      for(int i = offset ; i < p.length ; i+=a){
        Face tmp = new Face(
            parseInt(p[i-6]),parseInt(p[i-4]),parseInt(p[i-2]),parseInt(p[i]),
            parseInt(p[i-5]),parseInt(p[i-3]),parseInt(p[i-1]),parseInt(p[i+1])

            );

        faces.add(tmp);
      }
      offset += a;
    }
    /////////////////////




  }


  void plot(){
    for(int i = 0 ; i < pos.size();i++){
      PVector tmp = (PVector)pos.get(i);
      line(tmp.x*SCALE+1,tmp.y*SCALE,tmp.z*SCALE,tmp.x*SCALE-1,tmp.y*SCALE,tmp.z*SCALE);
      line(tmp.x*SCALE,tmp.y*SCALE+1,tmp.z*SCALE,tmp.x*SCALE,tmp.y*SCALE-1,tmp.z*SCALE);
      line(tmp.x*SCALE,tmp.y*SCALE,tmp.z*SCALE+1,tmp.x*SCALE,tmp.y*SCALE,tmp.z*SCALE-1);
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
        normal(na.x*SCALE,na.y*SCALE,na.z*SCALE);
        vertex(a.x*SCALE,a.y*SCALE,a.z*SCALE);
        normal(nb.x*SCALE,nb.y*SCALE,nb.z*SCALE);
        vertex(b.x*SCALE,b.y*SCALE,b.z*SCALE);
        normal(nc.x*SCALE,nc.y*SCALE,nc.z*SCALE);
        vertex(c.x*SCALE,c.y*SCALE,c.z*SCALE);
        normal(nd.x*SCALE,nd.y*SCALE,nd.z*SCALE);
        vertex(d.x*SCALE,d.y*SCALE,d.z*SCALE);
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
