class Bone{
  PMatrix3D matrix;
  PVector base,target;
  Bone parent;
  String name;
  boolean branching = false;


  Bone(String _name, PMatrix3D _matrix, boolean _branching){
    branching = _branching;
    name = _name;
    matrix = _matrix;
  }

  Bone(Bone _parent, String _name, PMatrix3D _matrix){
    name = _name;
    matrix = _matrix;
    parent = _parent;
  }

  Bone(Bone _parent, PMatrix3D _matrix){
    parent = _parent;
    matrix = _matrix;
  }

  PVector[] getTransform(){
    float m[] = new float[16];
    matrix.get(m);

      PVector rotX = new PVector(m[0],m[4],m[8]);
      PVector rotY = new PVector(m[1],m[5],m[9]);
      PVector rotZ = new PVector(m[2],m[6],m[10]);
      PVector pos = new PVector(m[12],m[13],-m[14]);

      return new PVector[]{rotX,rotY,rotZ,pos};

  }
}
