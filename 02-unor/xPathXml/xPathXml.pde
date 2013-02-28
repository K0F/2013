String filename = "";

ColladaParser parser;
Armature armature;

float SCALE = 40.0;
PFont font;

void setup() {

  size(800,600,P3D);

font = createFont("Monaco",7,false);
textFont(font,7);

  parser = new ColladaParser("test.dae",armature);


}

void draw(){

    background(0);
    stroke(255);
    strokeWeight(2);


    pushMatrix();
    translate(width/2,height/2,0);
    scale(SCALE,SCALE,SCALE);
    rotateX(HALF_PI);
    rotateZ(frameCount/300.0);
    armature.draw();
    popMatrix();
}

class ColladaParser{


  ColladaParser(String _filename, Armature _armature){
    filename = dataPath(_filename);
    armature = parseArmature();
  }

  Armature parseArmature(){
    ArrayList names = getNodeContent("//library_controllers/controller/skin//Name_array",0);
    PMatrix3D bind_shape_matrix = getMatrix("//library_controllers/controller/skin//bind_shape_matrix");
    ArrayList matrices = getMatrices(names,"//library_controllers/controller/skin//source[2]");
    ArrayList weights = getNodeContent("//library_controllers/controller/skin//source[3]",2);

    return new Armature(names,matrices,weights,bind_shape_matrix);
  }


  PMatrix3D getMatrix(String _query){

    ArrayList tmp = getNodeContent(_query,2);
    float m[] = new float[16];
    for(int i = 0 ; i < tmp.size();i++){
      m[i] = (Float)tmp.get(i);
    }

    return new PMatrix3D(
        m[0],m[1],m[2],m[3],
        m[4],m[5],m[6],m[7],
        m[8],m[9],m[10],m[11],
        m[12],m[13],m[14],m[15]
        );
  }

  ArrayList getMatrices(ArrayList _names,String _query){
    ArrayList matrices = new ArrayList();
    ArrayList vals = getNodeContent(_query,2);

    for(int q = 0 ; q < _names.size() ; q++){
      float m[] = new float[16];
      for(int i = 0 ; i < 16 ; i++){
        m[i] = (Float)vals.get(i+q*16);
      }

      matrices.add(new PMatrix3D(
            m[0],m[1],m[2],m[3],
            m[4],m[5],m[6],m[7],
            m[8],m[9],m[10],m[11],
            m[12],m[13],m[14],m[15]
            ));
    }

    return matrices;
  }

}


