float [] pix;

void setup(){


  size(320,240);

  background(100);
  loadPixels();

  int len = pixels.length;
  pix = new float[len];
  for(int i = 0 ; i < len;i++)
    pix[i] = color(random(255));

  updatePixels();
}



void draw(){
  tint(255,5);
  image(g,10,0);
  
  loadPixels();

  int len = pixels.length;
  for(int i = 0 ; i < len;i++)
    pix[i] = pix[(i^(frameCount/10.0))%len] ;

  for(int i = 0 ; i < len;i++)
    pixels[i] = (int)pix[i];

  updatePixels();

//  filter(BLUR,2);
  filter(GRAY);
}
