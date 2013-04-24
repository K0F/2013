
Editor editor;

void setup(){
  size(1600,900,OPENGL);
  textFont(createFont("Monaco",11,false));

  editor = new Editor();
}


void draw(){
  background(0);

  editor.draw();

}

class Editor{
  ArrayList lines;
  int currline = 0;

  Editor(){
    lines.add("");
  }

  void draw(){
    fill(255);
    for(int i = 0 ; i < lines.size();i++){
      String tmp = (String)lines.get(i);
      text(i,5,i*12);
      text(tmp,20,i*12);
    }
  }

  void addText(char _a){
    String line = (String)lines.get(currline);
    line += _a;
    lines.set(currline,line);
  }
}

void keyPressed(){
    if(key > 'a' && key < 'z'){
      editor.addText(key);
    }
}
