
class Armature{
  ArrayList bones;
  ArrayList weights;
  ArrayList names;
  ArrayList matrices;
  ArrayList parentsIndex;
  PMatrix3D base;

  Armature(ArrayList _names, ArrayList _matrices, ArrayList _parentsIndex, ArrayList _weights,PMatrix3D _base){
    base = new PMatrix3D(_base);
    names = _names; 
    matrices = _matrices;
    weights = _weights;
    parentsIndex = _parentsIndex;

    for(int i = 0 ; i < matrices.size();i++){
      PMatrix3D matrix = (PMatrix3D)matrices.get(i);
      matrix.invert();
    }

    bones = new ArrayList();
    bones.add(new Bone((String)names.get(0),(PMatrix3D)matrices.get(0),0));

    for(int i = 1 ; i < names.size();i++){
      println("addingBone");
      bones.add(new Bone((Bone)bones.get((Integer)parentsIndex.get(i)),(String)names.get(i),(PMatrix3D)matrices.get(i),i));
    }
  }



  Armature(ArrayList _names, ArrayList _matrices, ArrayList _weights,PMatrix3D _base){
    base = new PMatrix3D(_base);
    names = _names; 
    matrices = _matrices;
    weights = _weights;

    for(int i = 0 ; i < matrices.size();i++){
      PMatrix3D matrix = (PMatrix3D)matrices.get(i);
      matrix.invert();
    }

    bones = new ArrayList();
    bones.add(new Bone((String)names.get(0),(PMatrix3D)matrices.get(0),0));

    for(int i = 1 ; i < names.size();i++){
      bones.add(new Bone((Bone)bones.get(i-1),(String)names.get(i),(PMatrix3D)matrices.get(i),i));
    }
  }

  void draw(){
    applyMatrix(base);
    for(int i = 0 ; i< bones.size();i++){
      Bone tmp = (Bone)bones.get(i);
      tmp.draw();
    }

  }
}

class Bone{
  int id;
  String name;
  Bone parent;
  PMatrix3D base,matrix;
  PVector origin, target;

  Bone(String _name,PMatrix3D _matrix, int _id){
    id = _id;
    name = _name+"";

    matrix = new PMatrix3D(_matrix);
    base = new PMatrix3D(_matrix);

    //base.m03 = _matrix.m03;
    //base.m13 = _matrix.m13;
    //base.m23 = _matrix.m23;
  }

  Bone(Bone _parent,String _name,PMatrix3D _matrix, int _id){
    id = _id;
    parent = _parent;
    name = _name+"";

    PMatrix3D p = new PMatrix3D(parent.matrix);

    base = new PMatrix3D(_matrix);

    //base.m03 = _matrix.m03;//-parent.base.m03;
    //base.m13 = _matrix.m13;//-parent.base.m13;
    //base.m23 = _matrix.m23;//-parent.base.m23;
    matrix = new PMatrix3D(_matrix);
    origin = absolutePoint(0,0,0);
    inherit();

  }

  PVector absolutePoint(float _x,float _y, float _z){
    PVector pt = new PVector(_x,_y,_z);
    PMatrix3D nn = new PMatrix3D(matrix);
    nn.mult(pt,pt);

    return pt;
  }

  void inherit(){
    matrix.preApply(parent.matrix);
  }

  void rotate(float _x, float _y, float _z) {
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

    //working pure hell matrix solution for rotation in X,Y,Z
    matrix = new PMatrix3D(
        cb*cg, cg*sa*sb-ca*sg, ca*cg*sb+sa*sg, mat[3],
        cb*sg, ca*cg+sa*sb*sg, -cg*sa+ca*sb*sg, mat[7],
        -sb, cb*sa, ca*cb, mat[11],
        mat[12], mat[13], mat[14], mat[15]
        );



    //matrix.preApply(rot);

  }



  void draw(){

    rotate(mouseX,mouseY,0);

    if(id!=0)
      inherit();

    //text(matrix.m00+matrix.m01+matrix.m02+matrix.m03,screenX(0,0,0),screenY(0,0,0));


    origin = absolutePoint(0,0,0);

    if(id!=0){
      PVector pre = parent.absolutePoint(0,0,0);
      line(pre.x,pre.y,pre.z,origin.x,origin.y,origin.z);
    }
    /*
       if(id!=0){
       target = parent.absolutePoint(parent.origin.x,parent.origin.y,parent.origin.z);
       fill(#ffcc00);
       line(origin.x,origin.y,origin.z,target.x,target.y,target.z);
       }
     */

    pushMatrix();

    translate(origin.x,origin.y,origin.z);
    float s = 0.2;



    stroke(#ff0000);
    line(s,0,0,-s,0,0);
    stroke(#00ff00);
    line(0,s,0,0,-s,0);
    stroke(#0000ff);
    line(0,0,s,0,0,-s);
    popMatrix();
  }

}
