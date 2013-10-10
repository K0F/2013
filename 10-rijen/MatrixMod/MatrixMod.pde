float matrix[][] = {
  {-1,-1,-1},
  {-1, 8,-1},
  {-1,-1,-1},
};


PImage img;

void setup(){

  size(640,480,P2D);

  img = loadImage("test.jpg");
  img.loadPixels();

  for(int y = 0 ; y < img.height;y++){
    for(int x = 0 ; x < img.width;x++){
      float result = 0;
      int idx = y*width+x;

      for(int xx = 0; xx < matrix.length;xx++){
      for(int yy = 0; yy < matrix[xx].length;yy++){

        img.pixels[idx] += (matrix[xx][yy]*pixels[(y+yy)*width+(x+xx)]-img.pixels[idx])/3.0;
      }
      }
      
      img.pixels[idx] = 0;
    }
  }
}


void draw(){
  background(0);

  image(img,0,0);
  


}
