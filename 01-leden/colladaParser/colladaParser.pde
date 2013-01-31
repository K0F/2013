boolean DEBUG  = true;

Collada test;

float SCALE = 50.0;

void setup(){

  size(640,480,P3D);

  test = new Collada("test.dae");


}


void draw(){

  background(255);

  pushMatrix();
  translate(width/2,height/2);
  test.plot();
  popMatrix();

}

class Collada{
  String filename;
  XML raw;

  ArrayList pos;




  Collada(String _filename){
    filename = _filename;
    raw = loadXML(filename);

    parseGeometry();

  }

  void parseGeometry(){
    pos = new ArrayList();


    XML g[] = raw.getChildren("library_geometries");
    XML mesh = new XML("mesh");

    int idx = 0;

    for(int i = 0 ; i< g.length;i++){
      for(int q = 0; q < g[i].getChildCount();q++){
        XML tmp = g[i].getChildren()[q];
        if(tmp.getChildCount()>0){
          mesh = tmp.getChildren()[q];
        }
      }
    }

    String s = mesh.getContent();
    String lines [] = splitTokens(s,"\n\t");


    ArrayList data = new ArrayList();


    for(int i = 0; i < lines.length;i++){
      if(splitTokens(lines[i]," ").length > 0){
        data.add(lines[i]+"");
      }
    }

    String p[] = splitTokens((String)data.get(0)+""," ");

    for(int i = 2 ; i < p.length ; i+=3){
      PVector tmp = new PVector(
          parseFloat(p[i-2]),parseFloat(p[i-1]),parseFloat(p[i])
          );

      pos.add(tmp);
    }
  }

  void plot(){
    for(int i = 0 ; i < pos.size();i++){
      PVector tmp = (PVector)pos.get(i);
      line(tmp.x*SCALE+1,tmp.y*SCALE,tmp.z*SCALE,tmp.x*SCALE-1,tmp.y*SCALE,tmp.z*SCALE);
      line(tmp.x*SCALE,tmp.y*SCALE+1,tmp.z*SCALE,tmp.x*SCALE,tmp.y*SCALE-1,tmp.z*SCALE);
      line(tmp.x*SCALE,tmp.y*SCALE,tmp.z*SCALE+1,tmp.x*SCALE,tmp.y*SCALE,tmp.z*SCALE-1);

    }


  }








}
