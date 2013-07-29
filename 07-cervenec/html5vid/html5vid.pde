

var ctx;

final int cameraWidth = 640;
final int cameraHeight = 480;

void setup() { 
    size(640,480);
    ctx = externals.context;    
}

void draw() { 
    
    if (!video.available) return;
   
    float tras = noise(frameCount/5.0)*10.0;
    
    pushMatrix();
    
    translate(width,0);
    
    scale(-1,1);
    
    translate(random(-tras,tras),random(-tras,tras));
    
    ctx.drawImage(video, 0, 0, cameraWidth, cameraHeight);
    
    
    popMatrix();
    
    noFill();
    stroke(0);
    strokeWeight(3);
    rect(0,0,width-1,height-1);
    
}

