
class Armature{
  ArrayList bones;
  ArrayList weights;
  ArrayList names;
  ArrayList matrices;
  PMatrix3D base;

  Armature(ArrayList _names, ArrayList _matrices, ArrayList _weights,PMatrix3D _base){
    base = new PMatrix3D(_base);
    names = _names; 
    matrices = _matrices;
    weights = _weights;


    for(int i = 0 ; i < matrices.size();i++){
      PMatrix3D matrix = (PMatrix3D)matrices.get(i);
      matrix.preApply(base);
    }

    bones = new ArrayList();
    bones.add(new Bone((String)names.get(0),(PMatrix3D)matrices.get(0),0));

    for(int i = 1 ; i < names.size();i++){
      bones.add(new Bone((Bone)bones.get(i-1),(String)names.get(i),(PMatrix3D)matrices.get(i),i));

    }
  }

  void draw(){
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
  }

  Bone(Bone _parent,String _name,PMatrix3D _matrix, int _id){
    id = _id;
    parent = _parent;
    name = _name+"";
    matrix = new PMatrix3D(_matrix);
    base = new PMatrix3D(_matrix);
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
    if(id!=0)
      inherit();

    rotate(0,0,0);

    origin = absolutePoint(0,0,0);
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
