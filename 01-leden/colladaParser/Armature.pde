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

      //translate(pos[i].x/3.0,pos[i].y/3.0,pos[i].z/3.0);

      //pushMatrix();
      //rotateX(rotX[i].x+rotY[i].x+rotZ[i].x);
      //rotateY(rotX[i].y+rotY[i].y+rotZ[i].y);
      //rotateZ(rotX[i].z+rotY[i].z+rotZ[i].z);
      applyMatrix(mat);

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


