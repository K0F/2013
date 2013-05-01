Editor editor;
Compiler compiler;

void setup(){
  size(1600,900,OPENGL);
  textFont(createFont("Monaco",11,false));
  editor = new Editor();
  compiler = new Compiler(this);

}


void draw(){
  background(0);


  shader(compiler.shader);
  rect(0,0,width,height);

  resetShader();
  editor.draw();
}

class Editor{
  ArrayList lines;
  int currline = 0;

  Editor(){
    lines = new ArrayList();
    lines.add("");
  }

  void draw(){
    fill(255);
    String lastline = "";

    for(int i = 0 ; i < lines.size();i++){
      String tmp = (String)lines.get(i);
      fill(#ffcc00);
      text(i+1,5,i*12+12);
      fill(#ffffff);
      text(tmp,20,i*12+12);
      lastline = tmp;
    }

    fill(255,0,0,255 * (sin(frameCount/2.25)+1.0) );
    noStroke();
    rect(textWidth(lastline)+22,currline*12+2,8,12);

  }

  void addText(char _a){
    String line = (String)lines.get(currline);
    line += _a;
    lines.set(currline,line);
  }

}

class Compiler{
  PShader shader;

  PApplet parent;

  Compiler(PApplet _parent){
    parent = _parent;
    shader = new PShader(_parent);
    shader = loadShader("tmp/start.glsl");
  }

  void eatCode(ArrayList _in){
    ArrayList in = _in;
    String string[] = new String[_in.size()];

    for(int i= 0; i < in.size();i++){
      String ln =  (String)in.get(i);
      string[i] = ln+"";
      println(string[i]);
    }

    saveStrings("tmp/test.glsl",string);


    try{
      shader = compile();
    }catch(Exception e){println("Error while compiling shader!");}
  }

  PShader compile(){
    PShader tmp = loadShader("tmp/test.glsl");
    return tmp;
  }

}

void keyPressed(){
  if((int)key >= 32 && (int)key <= 126){
    editor.addText(key);
  } else if(keyCode==ENTER){
    editor.lines.add("");
    editor.currline++;
  } else if(keyCode==BACKSPACE){
    String tmp = (String)editor.lines.get(editor.currline);
    if(tmp.length() >= 1){
      editor.lines.set(editor.currline,tmp.substring(0,tmp.length()-1) );
    }else{
      editor.lines.remove(editor.lines.size()-1);
      editor.currline--;
    }
  }else if(keyCode==116){
    println("######################################");
    println("## COMPILING");
    println("######################################");
    compiler.eatCode(editor.lines);

  }else{
    println(keyCode);
  }
}
