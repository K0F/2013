String filename = "";

ColladaParser parser;
Armature armature;

float SCALE = 60.0;
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

    NodeList node = getNode("//library_visual_scenes/visual_scene/node[@id='Armature']//node");


  //  ArrayList matrices = new ArrayList();
    ArrayList parentsIndex = new ArrayList();

    for(int i = 0 ; i < node.getLength();i++){
      String boneName = (node.item(i).getAttributes().getNamedItem("id").getNodeValue().toString());
      String boneParentName = (node.item(i).getParentNode().getAttributes().getNamedItem("id").getNodeValue().toString());
    /*  String matrix[] = splitTokens(node.item(i).getChildNodes().item(1).getFirstChild().getNodeValue()," ");
      float m[] = new float[16];

      for(int q = 0 ; q < m.length;q++)
        m[q] = parseFloat(matrix[q]);

      PMatrix construct = new PMatrix3D(
            m[0],m[1],m[2],m[3],
            m[4],m[5],m[6],m[7],
            m[8],m[9],m[10],m[11],
            m[12],m[13],m[14],m[15]
            );

//      construct.transpose();

      matrices.add(construct);
*/
      
//      println(boneName + " -> "+ boneParentName + " ... "+matrix);
//      println(getBoneId(boneName,names) + " -> "+ getBoneId(boneParentName,names) );
      parentsIndex.add((Integer)getBoneId(boneParentName,names));

    }

    return new Armature(names,matrices,parentsIndex,weights,bind_shape_matrix);
  }

  int getBoneId(String _name, ArrayList names){
    int result = -1;
    for(int i = 0 ; i < names.size();i++){
      String name = (String)names.get(i);
      if(_name.equals(name)){
        result = i;
        break;
      }
    }

    return result;
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


