import jassimp.*;

Jassimp jassimp;
AiScene scene;


void setup(){
  

     // System.loadLibrary("jassimp");
    
  try{
 scene = Jassimp.importFile("test.blend"); 
  }catch(IOException e){
    println("Error loading file dude.");
  }
}
