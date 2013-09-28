int NUM_BONES = 3;
ArrayList bones;

void setup(){

  size(800,600,P3D);

  bones = new ArrayList();
  bones.add(new Bone());

  for(int i = 1 ; i < NUM_BONES;i++){
    Bone p = (Bone)bones.get(i-1);
    bones.add(new Bone(p));
  }

}


void draw(){

  background(255);

}


class Bone{
  Bone parent;
  PMatrix3D mat;

  Bone(){
    mat = new PMatrix3D();
  }

  Bone(){
    parent=_parent;

    Bone p = parent;
    mat = new PMatrix3D(
        p.m00,p.m01,p.m02,p.m03,
        p.m10,p.m11,p.m12,p.m13+length,
        p.m20,p.m21,p.m22,p.m23,
        p.m30,p.m31,p.m32,p.m33
        );
    
  }

  void draw(){
    applyMatrix(mat);
    line(0,0,0,0,length,0);
  }


}
