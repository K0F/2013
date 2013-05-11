Editor editor;
Compiler compiler;
PShader shader;

void setup(){
  size(1280,720,OPENGL);
  textFont(createFont("Monaco",11,false));
  editor = new Editor();
  compiler = new Compiler(this);

}

void recompile(){
Runnable runnable = new Compiler(this);
Thread thread = new Thread(runnable);
    
// Start the thread
 thread.start();
}

void draw(){
  background(0);


  try{
    shader(shader);
    rect(0,0,width,height);
  }catch(Exception e){;}

  resetShader();
  editor.draw();
}

class Editor{
  ArrayList lines;
  int currline = 0;
  int carret = 0;

  Editor(){
    lines = new ArrayList();
    lines.add("");
  }

  void draw(){
    fill(255,0,0,255 * (sin(frameCount/2.25)+1.0) );
    noStroke();
    rect(textWidth((String)lines.get(currline))+22,currline*12+2,8,12);
    fill(255);


    for(int i = 0 ; i < lines.size();i++){
      String tmp = (String)lines.get(i);
      fill(#ffcc00);
      text(i+1,5,i*12+12);
      fill(#ffffff);
      text(tmp,20,i*12+12);
    }

  }

  void addText(char _a){
    String line = (String)lines.get(currline);
    line += _a;
    lines.set(currline,line);
  }

  void addText(String _a){
    String line = (String)lines.get(currline);
    line += _a;
    lines.set(currline,line);
  }


}



class Compiler implements Runnable{

  PApplet parent;

  Compiler(PApplet _parent){
    parent = _parent;
    shader = loadShader("tmp/start.glsl");
    //shader.compileFragmentShader();
  }


  void run(){
    eatCode(editor.lines);
    shader = compile();
  }

  void eatCode(ArrayList _in){
    ArrayList in = _in;
    String string[] = new String[_in.size()];

    String plain = "";
    for(int i= 0; i < in.size();i++){
      String ln =  (String)in.get(i);
      string[i] = ln+"";
      plain += ln+"\n";

      println(string[i]);
    }

    saveStrings("tmp/test.glsl",string);

/*
    PShader tmp = new PShader(parent);

    try{
    shader = new PShader(parent);
    shader.setFragmentShader("tmp/start.glsl");
    //shader.compileFragmentShader();
    }catch(RuntimeException e){
      println("Error while compiling shader!");
    }

    shader = tmp;
    */
  }

  PShader compile(){
    PShader tmp = loadShader("tmp/test.glsl");
    return tmp;
  }

}

void keyPressed(){
  if((int)key >= 32 && (int)key <= 126){
    editor.addText(key);
    editor.carret++;
  } else if(keyCode==ENTER){
    editor.lines.add("");
    editor.currline++;
    editor.carret = 0;
  } else if(keyCode==BACKSPACE){
    String tmp = (String)editor.lines.get(editor.currline);
    if(tmp.length() >= 1){
      editor.lines.set(editor.currline,tmp.substring(0,tmp.length()-1) );
      editor.carret--;
    }else{
      if(editor.lines.size()>=1){
        editor.lines.remove(editor.lines.size()-1);
        editor.currline--;
        editor.carret = 0;
      }
    }
  }else if(keyCode==116){
    println("######################################");
    println("## COMPILING");
    println("######################################");
    recompile();
  }else if(keyCode==UP){
    editor.currline--;
    editor.currline = constrain(editor.currline,0,editor.lines.size()-1);
  }else if(keyCode==DOWN){
    editor.currline++;
    editor.currline = constrain(editor.currline,0,editor.lines.size()-1);
  }else if(keyCode==TAB){
    //   editor.addText("    ");
    //   editor.carret+=4;
  }else{
    println(keyCode);
  }
}
