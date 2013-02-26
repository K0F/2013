class Collada {
  String filename;
  XML raw;

  boolean loaded = false;

  ArrayList pos;
  ArrayList norm;
  ArrayList vcount;
  ArrayList faces;


  ArrayList weights, poses_matrices;
  PMatrix3D bind_matrix;


  Collada(ArrayList _pos,
      ArrayList _norm,
      ArrayList _vcount,
      ArrayList _faces,
      PMatrix3D _bind_matrix,
      ArrayList _weights,
      ArrayList _poses_matrices){

    pos = _pos;
    norm = _norm;
    vcount = _vcount;
    faces = _faces;
    bind_matrix = _bind_matrix;
    weights = _weights;
    poses_matrices = _poses_matrices;
  }

  Collada(String _filename){
    filename = _filename;
    initialize();
  }

  void initialize(){
    raw = loadXML(filename);
    getBindMatrix();
    //parseArmature();
    parseArmatureHierarchy();
    parseGeometry();

  }


  void parseArmatureHierarchy(){
    bones = new ArrayList();

    XML b[] = raw.getChildren("library_visual_scenes");
    XML vs = b[0].getChildren("visual_scene")[0];
    XML arm = vs.getChildren("node")[2];

    xmlAddBoneIteration(arm.getChildren("node")[0],0);

  }

  /* Iterrate through the whole tree beginning of given element
   */

  void xmlAddBoneIteration(XML start,int _id){
    Bone parent;

    //println(start.listAttributes());
    //println(start.getName());

    if(start.hasAttribute("name")){
      String[] matS = splitTokens(start.getChildren("matrix")[0].getContent()," ");
      float [] m = new float[16];

      for(int i = 0 ; i < m.length;i++)
        m[i] = parseFloat(matS[i]);

      PMatrix3D matrix = new PMatrix3D(
          m[0],m[1],m[2],m[3],
          m[4],m[5],m[6],m[7],
          m[8],m[9],m[10],m[11],
          m[12],m[13],m[14],m[15]
          );


      if(_id==0){
        Bone root = new Bone(start.getString("name"),matrix);
        bones.add(root);

      }else{
        parent = (Bone)bones.get(_id);
        bones.add(new Bone(start.getString("name"),matrix,parent));
      }

      int id = bones.size()-1;



      String ch[] = start.listChildren();

      boolean hasChild = false;

      int counter = 0;

      for(int i = 0 ; i < ch.length;i++)
      {
        if(ch[i].indexOf("node")>-1){
          hasChild = true;
          counter++;
        }
      }

      if(hasChild){
        for(int i = 0 ; i < counter;i++)
          xmlAddBoneIteration(start.getChildren("node")[0],id);
      }

    }
  }


  void getBindMatrix(){

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

    bind_matrix = new PMatrix3D(
        bind[0],bind[1],bind[2],bind[3],
        bind[4],bind[5],bind[6],bind[7],
        bind[8],bind[9],bind[10],bind[11],
        bind[12],bind[13],bind[14],bind[15]
        );

    ArrayList names = new ArrayList();
    for(int i = 0 ; i < jn.length; i++){
      names.add(jn[i]+"");
    }

    poses_matrices = new ArrayList();
    for(int i = 0 ; i < names.size(); i++){
      float [] mat = new float[16];
      for(int m = 0;m<16;m++){
        mat[m] = parseFloat(bp[16*i+m]);

      }

      poses_matrices.add(new PMatrix3D(
            mat[0],mat[1],mat[2],mat[3],
            mat[4],mat[5],mat[6],mat[7],
            mat[8],mat[9],mat[10],mat[11],
            mat[12],mat[13],mat[14],mat[15]
            ));
    }

    weights = new ArrayList();
    for(int i = 0 ; i < sw.length; i++){
      weights.add(parseFloat(sw[i]));
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

    //armature = new Armature(bind_matrix,poses_matrixes,weights);
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



    int checksum = 0;
    int cnt = 0;
    for(int i = 0 ; i < p.length ; i += 1){
      int tmp = parseInt(p[i]);
      print(tmp+" ");
      checksum += tmp;
      cnt++;
      vcount.add(tmp);
    }
    println();
    println("checksum -> "+cnt+ " : "+checksum);

    /////////////////////

    p = splitTokens((String)data.get(3)+""," ");

    int counter = 0;

    int vcv = (Integer)vcount.get(0);
    int vcn = (Integer)vcount.get(1);
    int offset = 0;

    println("pointers length -> "+p.length);
    println("offsets length -> "+vcount.size());
    int index = 0;

    for(int i = 0; i < vcount.size() ;i += 1){

      vcv = (Integer)vcount.get(i);

      offset += vcv*2;

      if(vcv == 3){
        int a = parseInt(p[offset-6]);
        int b = parseInt(p[offset-4]);
        int c = parseInt(p[offset-2]);

        int na = parseInt(p[offset-5]);
        int nb = parseInt(p[offset-3]);
        int nc = parseInt(p[offset-1]);

        Face tmp = new Face(a,b,c,na,nb,nc);

        faces.add(tmp);


      }else if(vcv == 4){
        int a = parseInt(p[offset-8]);
        int b = parseInt(p[offset-6]);
        int c = parseInt(p[offset-4]);
        int d = parseInt(p[offset-2]);

        int na = parseInt(p[offset-7]);
        int nb = parseInt(p[offset-5]);
        int nc = parseInt(p[offset-3]);
        int nd = parseInt(p[offset-1]);

        Face tmp = new Face(a,b,c,d,na,nb,nc,nd);

        faces.add(tmp);


      }else{
        println("Wrong number of verticles detected!");
      }



    }

    /////////////////////

    loaded = true;
    test = new Collada(pos,norm,vcount,faces,bind_matrix,weights, poses_matrices);
    println("JOB DONE!");

    println("got "+pos.size()+" verticles");
    println("got "+norm.size()+" normals");
    println("got "+vcount.size()+" faces");
    println("got "+faces.size()+" f+n");
  }

  public boolean loaded(){
    return loaded;
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
    pushMatrix();
    if(bind_matrix!=null)
      applyMatrix(bind_matrix);
    for(int i = 0 ; i < faces.size();i++){
      Face f = (Face)faces.get(i);
      if(f.idx.length==6){

        PVector a = (PVector)pos.get(f.idx[0]);
        PVector b = (PVector)pos.get(f.idx[1]);
        PVector c = (PVector)pos.get(f.idx[2]);

        PVector na,nb,nc;
        na = (PVector)norm.get(f.idx[3]);
        nb = (PVector)norm.get(f.idx[4]);
        nc = (PVector)norm.get(f.idx[5]);

        beginShape();
        normal(na.x,na.y,na.z);
        vertex(a.x,a.y,a.z);
        normal(nb.x,nb.y,nb.z);
        vertex(b.x,b.y,b.z);
        normal(nc.x,nc.y,nc.z);
        vertex(c.x,c.y,c.z);
        endShape();

      }else if(f.idx.length==8){

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
    popMatrix();
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

  Face(int a,int b,int c){
    idx = new int[3];
    idx[0] = a;
    idx[1] = b;
    idx[2] = c;
  }

  Face(int a,int b,int c, int na, int nb, int nc){
    idx = new int[6];
    idx[0] = a;
    idx[1] = b;
    idx[2] = c;
    idx[3] = na;
    idx[4] = nb;
    idx[5] = nc;
  }

}


