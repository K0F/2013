class Bone{
  String name;
  
  ArrayList vertices;

  ArrayList trail;
  PVector x,y,z;
  PMatrix3D matrix,base;

  Bone parent;

  PVector relPoint;
  PVector origin;

  PVector target;


  Bone(String _name,PMatrix3D _mat){

    
    name = _name;
    
    
    initialize(_mat);
    trail = new ArrayList();

    println("adding ROOT bone "+name+" -> "+matrix.m03+" "+matrix.m13+" "+matrix.m23);
  }


  Bone(String _name,PMatrix3D _mat,Bone _parent){
    name = _name;
    parent = _parent;
    initialize(_mat);
    trail = new ArrayList();

    updateVertices();
    println("adding CHLDREN bone "+name+" -> "+matrix.m03+" "+matrix.m13+" "+matrix.m23);
  }

  void initialize(PMatrix _mat){
    matrix = new PMatrix3D(_mat);
    base = new PMatrix3D(_mat);

    origin = absolutePoint(0,0,0);
    //relPoint = absolutePoint(target.x,target.y,target.z);
    updateVertices();
  }

  void updateVertices(){
    if(parent!=null)
      inherit();

    origin  = absolutePoint(0,0,0);
    //relPoint = absolutePoint(target.x,target.y,target.z);

    vertices = new ArrayList();
/*
    float step = radians(360.0/(NUM_SEGMENTS+0.0));

    for(float f = 0 ; f < radians(360) ; f += step){
      if(NOISED){
        float shiftX = (noise(f/radians(360),bones.indexOf(this)/10.0+frameCount/80.0))*4.0;
        float shiftY = (noise(bones.indexOf(this)/10.0+frameCount/80.0,f/radians(360)))*4.0;
        vertices.add(absolutePoint(
              cos(f)*V*shiftX,
              sin(f)*V*shiftY,
              0));
      }else{
        vertices.add(absolutePoint(
              cos(f)*V,
              sin(f)*V,
              0));

      }

    }
    */
  }

  PVector relativePoint(float _x,float _y, float _z){
    PVector pt = new PVector(_x,_y,_z);
    PMatrix3D nn = new PMatrix3D(matrix);
    nn.invert();
    nn.mult(pt,pt);

    return pt;
  }

  PVector absolutePoint(float _x,float _y, float _z){
    PVector pt = new PVector(_x,_y,_z);
    PMatrix3D nn = new PMatrix3D(matrix);
    nn.mult(pt,pt);

    return pt;
  }
  void inherit(){
    matrix.preApply(parent.matrix);//new PMatrix3D(base);
  }

  void rotate(float _x, float _y, float _z){
    float radx = radians(_x);
    float rady = radians(_y);
    float radz = radians(_z);

    float ca = cos(radx);
    float sa = sin(radx);

    float cb = cos(rady);
    float sb = sin(rady);

    float cg = cos(radz);
    float sg = sin(radz);

    float[] mat = new float[16];
    matrix = new PMatrix3D(base);
    matrix.get(mat);

    // working X,Y,Z arbitrary solution
    matrix = new PMatrix3D(
        cb*cg,cg*sa*sb-ca*sg,ca*cg*sb+sa*sg,mat[3],
        cb*sg,ca*cg+sa*sb*sg,-cg*sa+ca*sb*sg,mat[7],
        -sb,cb*sa,ca*cb,mat[11],
        mat[12],mat[13],mat[14],mat[15]
        );
  }

  void draw(){


    if(parent!=null)
      inherit();
    rotate(0,0,0);


    float W = 2;

      pushMatrix();
     // origin = new PVector(0,0,0);
     // relPoint = new PVector(target.x,target.y,target.z);
      applyMatrix(matrix);

      noFill();
      stroke(255,ALPHA);
      rectMode(CENTER);



      strokeWeight(1);

      rect(0,0,W,W);

      stroke(#ff0000,ALPHA);
      line(0,0,0,W/2,0,0);

      stroke(#00ff00,ALPHA);
      line(0,0,0,0,W/2,0);

      stroke(#0000ff,ALPHA);
      line(0,0,0,0,0,W/2);

      popMatrix();
      /*
      origin = absolutePoint(0,0,0);
      relPoint = absolutePoint(target.x,target.y,target.z);
      strokeWeight(2);

      stroke(#ff0000,ALPHA);
      line(relPoint.x-S,relPoint.y,relPoint.z,relPoint.x+S,relPoint.y,relPoint.z);
      stroke(#00ff00,ALPHA);
      line(relPoint.x,relPoint.y-S,relPoint.z,relPoint.x,relPoint.y+S,relPoint.z);
      stroke(#0000ff,ALPHA);
      line(relPoint.x,relPoint.y,relPoint.z-S,relPoint.x,relPoint.y,relPoint.z+S);

      strokeWeight(10);
      stroke(#ffff00,ALPHA);
      line(origin.x,origin.y,origin.z,relPoint.x,relPoint.y,relPoint.z);
*/
  //    addTrail();

  }
  void addTrail(){

    trail.add(new PVector(relPoint.x,relPoint.y,relPoint.z));
    if(trail.size()>TRAIL_LENGTH)
      trail.remove(0);


  }

  void drawTrail(){
    strokeWeight(1);
    if(trail.size()>=1)
      for(int i = 1 ; i < trail.size();i+=1){
        PVector t1 = (PVector)trail.get(i-1);
        PVector t2 = (PVector)trail.get(i);
        stroke(255,map(i,0,trail.size(),0,TRAIL_ALPHA));
        line(t1.x,t1.y,t1.z,t2.x,t2.y,t2.z);
      }


  }


}



