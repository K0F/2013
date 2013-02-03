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

  //shape(zzz,0,0);
  if(test!=null)
    test.drawFaces();
  //test = new Collada("test2.dae");

  popMatrix();
}

// avoid using main thread to load data

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
    //parseGeometry();
    parseArmature();

  }

  ///////////////////////////////////////////////////

  /* todo: 
   * parse armature geometry
   * parse matrixes
   * get vetricles weights
   * construct particular bones
   * construct complete armature object
   */

  void parseArmature(){
    Armature armature;
    ArrayList bones;

    XML b[] = raw.getChildren("library_controllers");
    XML props = b[0].getChildren("controller")[0];
    XML armGeom = props.getChildren("skin")[0];

    //hradcoded names?
    String bind_shape_matrix = armGeom.getChildren("bind_shape_matrix")[0].getContent();
    String joints_names = armGeom.getChildren("source")[0].getContent();
    String bind_poses = armGeom.getChildren("source")[1].getContent();
    String skin_weights = armGeom.getChildren("source")[2].getContent();

    String bsm[] = splitTokens(bind_shape_matrix," \n");
    String jn[] = splitTokens(joints_names," \n");
    String bp[] = splitTokens(bind_poses," \n");
    String sw[] = splitTokens(skin_weights," \n");


    if(DEBUG){
      println(bsm.length);
      println(jn.length);
      println(bp.length);
      println(sw.length);
    }

    /*
       The bind shape matrix describes how to transform the pCylinderShape1 geometry into the right
       coordinate system for use with the joints.  In this case we do an +90 Y transform because
       the pCylinderShape1 geometry was initially a 180 unit long cylinder with 0,0,0 at it's center.
       This moves it so 0,0,0 is at the base of the cylinder.
     */

    float[] bind = new float[16];
    for(int i = 0 ; i < 16; i++){
      bind[i] = (parseFloat(bsm[i]));
    }

    PMatrix3D bind_matrix = new PMatrix3D(
        bind[0],bind[1],bind[2],bind[3],
        bind[4],bind[5],bind[6],bind[7],
        bind[8],bind[9],bind[10],bind[11],
        bind[12],bind[13],bind[14],bind[15]
        );


    ArrayList names = new ArrayList();
    for(int i = 0 ; i < jn.length; i++){
      names.add(jn[i]+"");
    }

    /*
       This source defines the inverse bind matrix for each joint, these are used to bring 
       coordinates being skinned into the same space as each joint.  Note that in this case the
       joints begin at 0,0,0 and move up 30 units for each joint, so the inverse bind matrices
       are the opposite of that.
     */

    ArrayList poses_matrixes = new ArrayList();
    for(int i = 0 ; i < names.size(); i++){
      float [] mat = new float[16];
      for(int m = 0;m<16;m++){
        mat[m] = parseFloat(bp[16*i+m]);

      }
      poses_matrixes.add(new PMatrix3D(
            mat[0],mat[1],mat[2],mat[3],
            mat[4],mat[5],mat[6],mat[7],
            mat[8],mat[9],mat[10],mat[11],
            mat[12],mat[13],mat[14],mat[15]
            ));
    }

    ArrayList weights = new ArrayList();
    for(int i = 0 ; i < sw.length; i++){
      weights.add(parseFloat(sw[i]));
    }
  }

  //////////////////////////////////////////////

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

    for(int i = 2 ; i < p.length ; i += 3){
      PVector tmp = new PVector(
          parseFloat(p[i-2]),parseFloat(p[i-1]),parseFloat(p[i])
          );

      norm.add(tmp);
    }
    /////////////////////

    p = splitTokens((String)data.get(2)+""," ");

    for(int i = 0 ; i < p.length ; i += 1){
      int tmp = parseInt(p[i]);

      vcount.add(tmp);
    }

    /////////////////////

    p = splitTokens((String)data.get(3)+""," ");

    int offset = 8;
    for(int f = offset; f < p.length+1 ;f += 8){
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

      //  zzz.beginContour();
      // beginShape();
      zzz.normal(na.x*SCALE,na.y*SCALE,na.z*SCALE);
      zzz.vertex(a.x*SCALE,a.y*SCALE,a.z*SCALE);
      zzz.normal(nb.x*SCALE,nb.y*SCALE,nb.z*SCALE);
      zzz.vertex(b.x*SCALE,b.y*SCALE,b.z*SCALE);
      zzz.normal(nc.x*SCALE,nc.y*SCALE,nc.z*SCALE);
      zzz.vertex(c.x*SCALE,c.y*SCALE,c.z*SCALE);
      zzz.normal(nd.x*SCALE,nd.y*SCALE,nd.z*SCALE);
      zzz.vertex(d.x*SCALE,d.y*SCALE,d.z*SCALE);
      // zzz.endContour();

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

class Armature{
  PMatrix3D space;
  ArrayList bones;
  ArrayList weights;
  ArrayList offsets;

  Armature(PMatrix3D _space){

  }
}

class Bone{
  PMatrix3D offset;
  PVector base,target;
  Bone parent;

  Bone(Bone _parent, PMatrix3D _offset){
    parent = _parent;
    offset = _offset;
  }
}
