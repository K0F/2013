String filename = "";

ColladaParser parser;
Armature armature;

void setup() {

  parser = new ColladaParser("test.dae");

  //armature = new Armature();

}

class ColladaParser{


  ColladaParser(String _filename){
    filename = dataPath(_filename);
    parseArmature();
  }

  void parseArmature(){
    ArrayList names = getNodeContent("//library_controllers/controller/skin//Name_array",0);
    for(int i  = 0 ; i < names.size();i++){
      String a = (String)names.get(i);
      println(a);
    }

    PMatrix3D bind_shape_matrix = getMatrix("//library_controllers/controller/skin//bind_shape_matrix");


    ArrayList vals = getNodeContent("//library_controllers/controller/skin//source[2]",2);
    for(int i = 0 ; i < vals.size();i++){
      float a = (Float)vals.get(i);
      println(a);
    }

    ArrayList weights = getNodeContent("//library_controllers/controller/skin//source[3]",2);
    for(int i = 0 ; i < vals.size();i++){
      float a = (Float)vals.get(i);
      println(a);
    }  
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

}


