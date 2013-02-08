boolean DEBUG  = true;

Collada test;
Armature armature;
ArrayList bones;

float SCALE = 30.0;
Runnable runnable;
Thread thread;

PShape zzz;

void setup(){
  size(640,480,OPENGL);

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
  scale(SCALE,SCALE,SCALE);
  pointLight(255,255,255,-5,-5,5);
  rotateX(HALF_PI+radians(frameCount/10.0));
  rotateZ(radians(frameCount/3.0));
  noStroke();//stroke(0);
  fill(255,0,0);

  //shape(zzz,0,0);
  if(test!=null)
    test.drawFaces();
  //test = new Collada("test2.dae");
  //

  if(armature!=null){
    armature.plot();
  }

  if(bones.size()>0){
      pushMatrix();
    for(int i = 0; i < bones.size();i++){
      Bone b = (Bone)bones.get(i);
      PVector t[] = b.getTransform();

      translate(t[3].x,t[3].y,t[3].z);
      //rotateX(t[0].x+t[1].x+t[2].x);
      //rotateY(t[0].y+t[1].y+t[2].y);
      //rotateZ(t[0].z+t[1].z+t[2].z);
      box(1);

    }

      popMatrix();
  }

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
    //parseArmature();
    parseArmatureHierarchy();

  }


  void parseArmatureHierarchy(){
    bones = new ArrayList();


    XML b[] = raw.getChildren("library_visual_scenes");
    XML vs = b[0].getChildren("visual_scene")[0];
    XML arm = vs.getChildren("node")[0];

    println(arm.listChildren());


    xmlAddBoneIteration(arm.getChildren("node")[0]);
    
  }

  void xmlAddBoneIteration(XML start){

    println(start.listAttributes());
    println(start.getName());

    if(start.hasAttribute("name")){
      println("Adding bone: "+start.getString("name"));
      String[] matS = splitTokens(start.getChildren("matrix")[0].getContent()," ");
      float [] m = new float[16];

      for(int i = 0 ; i < m.length;i++)
        m[i] = parseFloat(matS[i]);

      PMatrix3D matrix = new PMatrix3D(
            m[0],m[4],m[8],m[12],
            m[1],m[5],m[9],m[13],
            m[2],m[6],m[10],m[14],
            m[3],m[7],m[11],m[15]
            );
      

      bones.add(new Bone(start.getString("name"),matrix));
      
      String ch[] = start.listChildren();

      boolean hasChild = false;

      for(int i = 0 ; i < ch.length;i++)
      {
        if(ch[i].indexOf("node")>-1){
          hasChild = true;
        }
      }

      if(hasChild){
        xmlAddBoneIteration(start.getChildren("node")[0]);
      }
    }


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

    // apply row-to-col transform here
    PMatrix3D bind_matrix = new PMatrix3D(
        bind[0],bind[4],bind[8],bind[12],
        bind[1],bind[5],bind[9],bind[13],
        bind[2],bind[6],bind[10],bind[14],
        bind[3],bind[7],bind[11],bind[15]
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

      // apply row-to-col transform here
      poses_matrixes.add(new PMatrix3D(
            bind[0],bind[4],bind[8],bind[12],
            bind[1],bind[5],bind[9],bind[13],
            bind[2],bind[6],bind[10],bind[14],
            bind[3],bind[7],bind[11],bind[15]
            ));
    }

    ArrayList weights = new ArrayList();
    for(int i = 0 ; i < sw.length; i++){
      weights.add(parseFloat(sw[i]));
    }

    armature = new Armature(bind_matrix,poses_matrixes,weights);
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
  PMatrix3D base;
  ArrayList bones;
  ArrayList weights;
  ArrayList offsets;
  ArrayList preMult;

  PVector brotX,brotY,brotZ;
  PVector bpos;

  PVector rotX[],rotY[],rotZ[];
  PVector pos[];

  Armature(PMatrix3D _base, ArrayList _offsets, ArrayList _weights){
    base = _base;//rowToColMatrix(_base);
    offsets = _offsets;

    /* 
    // convert to opengl space
    for(int i = 0 ; i < offsets.size();i++){
    PMatrix3D tmp = (PMatrix3D)offsets.get(i);
    PMatrix3D conv = rowToColMatrix(tmp.get());
    offsets.set(i,conv);
    }
     */

    /*
       preMult = new ArrayList();

       for(int i = offsets.size()-1 ; i >= 1;i--){
       PMatrix3D origin1 = (PMatrix3D)offsets.get(i-1);
       PMatrix3D origin2 = (PMatrix3D)offsets.get(i);
       float o1[] = new float[16];
       float o2[] = new float[16];
       float m[] = new float[16];

       origin1.get(o1);
       origin2.get(o2);

       origin1.mult(o2,m);

       preMult.add(new PMatrix3D(
       m[0],m[1],m[2],m[3],
       m[4],m[5],m[6],m[7],
       m[8],m[9],m[10],m[11],
       m[12],m[13],m[14],m[15]
       ));
       }
     */

    weights = _weights;
    collToOpengl(offsets);
    collToOpenglB(base);

    // PMatrix3D mat = (PMatrix3D)offsets.get(0);

  }

  void plot(){

    //rotY[1].y = sin(radians(frameCount/3.0));
    //rotY[0].x = cos(radians(frameCount/3.0));

    pushMatrix();
    //applyMatrix(base);

    translate(bpos.x/3.0,bpos.y/3.0,bpos.z/3.0);

    rotateX((brotX.x+brotY.x+brotZ.x));
    rotateY((brotX.y+brotY.y+brotZ.y));
    rotateZ((brotX.z+brotY.z+brotZ.z));

    // rotateX(rotY[i].x);
    // rotateY(rotY[i].y);
    //rotateZ(rotY[i].z);
    for(int i = 0 ; i < offsets.size();i++){
      PMatrix3D mat = (PMatrix3D)offsets.get(i);

      /*
       *  0  1  2  3
       *  4  5  6  7
       *  8  9 10 11
       * 12 13 14 15
       */

      translate(pos[i].x/3.0,pos[i].y/3.0,pos[i].z/3.0);

      //pushMatrix();
      rotateX(rotX[i].x+rotY[i].x+rotZ[i].x);
      rotateY(rotX[i].y+rotY[i].y+rotZ[i].y);
      rotateZ(rotX[i].z+rotY[i].z+rotZ[i].z);
      //applyMatrix(mat);

      box(1);
      //popMatrix();
      //printMatrix();
    }
    popMatrix();

  }

  /*
  //this converts collada space to opengl
  PMatrix3D rowToColMatrix(PMatrix3D mat){
  float m[] = new float[16];
  mat.get(m);

  return new PMatrix3D(
  m[0]/SCALE,m[4]/SCALE,m[8]/SCALE,m[12]/SCALE,
  m[1]/SCALE,m[5]/SCALE,m[9]/SCALE,m[13]/SCALE,
  m[2]/SCALE,m[6]/SCALE,m[10]/SCALE,m[14]/SCALE,
  m[3]/SCALE,m[7]/SCALE,m[11]/SCALE,m[15]/SCALE);
  }
   */


  void collToOpengl(ArrayList matrices){
    rotX = new PVector[matrices.size()];   
    rotY = new PVector[matrices.size()];   
    rotZ = new PVector[matrices.size()];   
    pos = new PVector[matrices.size()];   

    for(int i = 0 ; i < matrices.size();i++){
      PMatrix3D mat = (PMatrix3D)matrices.get(i);
      float m[] = new float[16];
      mat.get(m);


      rotX[i] = new PVector(m[0]*m[3],m[1]*m[3],m[2]*m[3]);
      rotY[i] = new PVector(m[4]*m[7],m[5]*m[7],m[6]*m[7]);
      rotZ[i] = new PVector(m[8]*m[11],m[9]*m[11],m[10]*m[11]);
      pos[i] = new PVector(m[12]*m[15],m[13]*m[15],-m[14]*m[15]);
    }
  }

  void collToOpenglB(PMatrix3D mat){

    float m[] = new float[16];
    mat.get(m);

    brotX = new PVector(m[0]*m[3],m[1]*m[3],m[2]*m[3]);
    brotY = new PVector(m[4]*m[7],m[5]*m[7],m[6]*m[7]);
    brotZ = new PVector(m[8]*m[11],m[9]*m[11],m[10]*m[11]);
    bpos = new PVector(m[12]*m[15],m[13]*m[15],m[14]*m[15]);
    /*    
          brotX = new PVector(m[0],m[1],m[2]);
          brotY = new PVector(m[4],m[5],m[6]);
          brotZ = new PVector(m[8],m[9],m[10]);
          bpos = new PVector(m[12],m[13],m[14]);
     */
  }
}

class Bone{
  PMatrix3D matrix;
  PVector base,target;
  Bone parent;
  String name;

  Bone(String _name, PMatrix3D _matrix){
    name = _name;
    matrix = _matrix;
  }

  Bone(Bone _parent, PMatrix3D _matrix){
    parent = _parent;
    matrix = _matrix;
  }

  PVector[] getTransform(){
    float m[] = new float[16];
    matrix.get(m);

      PVector rotX = new PVector(m[0],m[1],m[2]);
      PVector rotY = new PVector(m[4],m[5],m[6]);
      PVector rotZ = new PVector(m[8],m[9],m[10]);
      PVector pos = new PVector(m[12],m[13],-m[14]);

      return new PVector[]{rotX,rotY,rotZ,pos};

  }
}
