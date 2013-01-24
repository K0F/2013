
PShader monjori;

void setup() {
  size(800, 600, P2D);
  noStroke();
 
  monjori = loadShader("monjori.glsl");
  monjori.set("resolution", float(width), float(height));   
}

void draw() {
  monjori.set("time", millis() / 1000.0);
   monjori.set("x", float(mouseX/width));
   monjori.set("y", float(mouseY/height));
  
  shader(monjori);
  // This kind of effects are entirely implemented in the
  // fragment shader, they only need a quad covering the  
  // entire view area so every pixel is pushed through the 
  // shader.   
  rect(0, 0, width, height);  
}

