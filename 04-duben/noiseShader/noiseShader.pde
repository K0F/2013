PShader noise;
PImage test;

void setup(){
size(1600,900,P2D);
  noise = loadShader("noise.glsl");

}

void draw(){
  noise.set("time",frameCount);
  shader(noise);
  rect(0,0,width,height);
}
