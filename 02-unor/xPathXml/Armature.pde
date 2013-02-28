
class Armature{
  ArrayList bones;

  Armature(){
    bones = new ArrayList();
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
