
Armature armature;
String filename = "test.dae";

void setup() {
  filename = dataPath(filename);
 
  armature = new Armature();
  
  ArrayList coords = getNodeContent("//library_visual_scene/visual_scene/*",0);

  for(int i  = 0 ; i < coords.size();i++){
    String a = (String)coords.get(i);
    println(a);
  }
}


