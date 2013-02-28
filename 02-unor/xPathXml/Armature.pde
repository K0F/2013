
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

    bones = new ArrayList();
    bones.add(new Bone((String)names.get(0),(PMatrix3D)matrices.get(0)));
    
    for(int i = 1 ; i < names.size();i++){
    bones.add(new Bone((Bone)bones.get(i-1),(String)names.get(i),(PMatrix3D)matrices.get(i)));
      
    }
  }
}

class Bone{

  String name;
  Bone parent;
  PMatrix3D base,matrix;
  PVector origin, target;

  Bone(String _name,PMatrix3D _matrix){
    name = _name+"";
    matrix = new PMatrix3D(_matrix);
    base = new PMatrix3D(_matrix);
  }

  Bone(Bone _parent,String _name,PMatrix3D _matrix){
    parent = _parent;
    name = _name+"";
    matrix = new PMatrix3D(_matrix);
    base = new PMatrix3D(_matrix);
  }

}
