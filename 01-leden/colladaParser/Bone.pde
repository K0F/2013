class Bone{
  PMatrix3D matrix;
  PVector base,target;
  Bone parent;
  String name;
  boolean branching = false;
  ArrayList history;

  Bone(String _name, PMatrix3D _matrix){
    parent = this;
    name = _name;
    matrix = _matrix;
    history = getHistory();
  }

  Bone(Bone _parent, String _name, PMatrix3D _matrix){
    name = _name;
    matrix = _matrix;
    parent = _parent;
    history = getHistory();
  }

  Bone(String _name, PMatrix3D _matrix,Bone _parent){
   name = _name;
    parent = _parent;
    matrix = _matrix;
    history = getHistory();
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

  ArrayList getHistory(){
    ArrayList n = new ArrayList();
    Bone p = parent;
  
    n.add(parent.matrix);

    println("getting history for bone: "+name);

    while(p.parent!=p){
      n.add(p.matrix);
      p = p.parent;
      print(p.name + " --> ");
    }

    println();

    return n;
  }

  void plot(){

      pushMatrix();
    
    for(int i = history.size()-1; i >= 0;i--){
      PMatrix3D tmp = (PMatrix3D)history.get(i);
      applyMatrix(tmp);
    }

    box(0.25);

    popMatrix();

  }
}
