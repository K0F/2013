import codeanticode.gsvideo.*;

// Stipple Cam  Jim Bumgardner
//
// v1.0 11/30/2011 jbum
// V1.1 12/1/2011 jbum - optimized the particle interactions frame rate for 2364 particles increased from 14 to 21

GSPipeline pipeline;


boolean captureMovie = false;
String outputPrefix = "stipplecamtest";

// Play with these...
float ditherFactor = 10.0; // smaller numbers = more dots, slower frame rate
float dotDensity = .5; // higher ratios = more dots


// Probably don't need to play with these as much...
float  damping = 0.7;
float  kRadiusFactor = 0.5;
float  kSpeed = 3.0;
float  minDistFactor = 2.5; // area of influence - smaller numbers make rendering go faster
int  nbrParticles;
int maxParticles;


PImage img;
PGraphics dg; // for dithering initialilzation...

// for 20,000 dots, use 1-3.5 with smaller dots
// for 5000 dots, use 1-1

class Particle
{
  float  x,y,vx,vy,rad;
  float  fx,fy,wt;

  Particle(float _x, float _y)
  {
    vx = 0;
    vy = 0;
    x = _x;
    y = _y;
    rad = 1;
  }
}

Particle[] particles;

float minRadius,maxRadius,medRadius;

void setup()
{
  size(800,600);


  int dwidth = (int) (width / ditherFactor);
  int dheight = (int) (height / ditherFactor);

  pipeline = new GSPipeline(this, "v4l2src");  

  maxParticles = dwidth*dheight;
  particles = new Particle[maxParticles];
  nbrParticles = 0;
  for (int dy = 0; dy < dheight; ++dy) {
    for (int dx = 0; dx < dwidth; ++dx) {
      // int v = (int) red(dg.pixels[ dy*dwidth + dx ]);
      if (random(1) < dotDensity) {
        particles[nbrParticles++] = new Particle(dx*ditherFactor, dy*ditherFactor);
      }
    }
  }

  frameRate(24);
  // noLoop();
  smooth();
  noStroke();

  float medArea = (width*height)/nbrParticles;
  medRadius = sqrt(medArea/PI);
  minRadius = medRadius; // using medRadius > 1 improves black areas
  maxRadius = medRadius*medRadius;
  println("nbrParticles = " + nbrParticles);
  println("medrad = " + medRadius);
  println("min-max = " + minRadius + " --> " + maxRadius);
  
   pipeline = new GSPipeline(this, "v4l2src");  
    pipeline.play();

}


void doPhysics()
{
  // println("sc = " + sc);
  
    if (pipeline.available()) {
    pipeline.read();
    image(pipeline, 0, 0);
  }

  for (int i = 0; i < nbrParticles; ++i) {
    int px = (int) (particles[i].x / ditherFactor);
    int py = (int) (particles[i].y / ditherFactor);
    if (px >= 0 && px < pipeline.width && py >= 0 && py < pipeline.height) {
      int v = (int) red(pipeline.pixels[ py*pipeline.width + px ]);
      particles[i].rad = map(v/255.0,0,1,minRadius,maxRadius);
    }
  }
  

  for (int i = 0; i < nbrParticles; ++i) {
    Particle p = particles[i];
    p.fx = p.fy = p.wt = 0;

    p.vx *= damping;
    p.vy *= damping;

  }

  // Particle -> particle interactions
  for (int i = 0; i < nbrParticles-1; ++i) {
    Particle p = particles[i];
    for (int j = i+1; j < nbrParticles; ++j) {
      Particle pj = particles[j];
      if (i== j || Math.abs(pj.x - p.x) > p.rad*minDistFactor ||
          Math.abs(pj.y - p.y) > p.rad*minDistFactor)
          continue;

      double  dx = p.x - pj.x;
      double  dy = p.y - pj.y;
      double  distance = Math.sqrt(dx*dx+dy*dy);
      
      double  maxDist = (p.rad + pj.rad);
      double  diff = maxDist - distance;
      if (diff > 0) {
        double scle = diff/maxDist;
        scle = scle*scle;
        p.wt += scle;
        pj.wt += scle;
        scle = scle*kSpeed/distance;
        p.fx += dx*scle;
        p.fy += dy*scle;
        pj.fx -= dx*scle;
        pj.fy -= dy*scle;
      }
    }
  }
  
  for (int i = 0; i < nbrParticles; ++i) {
    Particle p = particles[i];

       // keep within edges
    double dx,dy,distance,scle,diff;
    double maxDist = p.rad;
    // left edge  
    distance = dx = p.x - 0;    dy = 0;
    diff = maxDist - distance;
    if (diff > 0) {
	scle = diff/maxDist;
	scle = scle*scle;
	p.wt += scle;
	scle = scle*kSpeed/distance;
        p.fx += dx*scle;
        p.fy += dy*scle;
    }
    // right edge  
    dx = p.x - width;    dy = 0;
    distance = -dx;
    diff = maxDist - distance;
    if (diff > 0) {
	scle = diff/maxDist;
	scle = scle*scle;
	p.wt += scle;
	scle = scle*kSpeed/distance;
        p.fx += dx*scle;
        p.fy += dy*scle;
    }
    // top edge
    distance = dy = p.y - 0;    dx = 0;
    diff = maxDist - distance;
    if (diff > 0) {
	scle = diff/maxDist;
	scle = scle*scle;
	p.wt += scle;
	scle = scle*kSpeed/distance;
        p.fx += dx*scle;
        p.fy += dy*scle;
    }
    // bot edge  
    dy = p.y - height;    dx = 0;
    distance = -dy;
    diff = maxDist - distance;
    if (diff > 0) {
	scle = diff/maxDist;
	scle = scle*scle;
	p.wt += scle;
	scle = scle*kSpeed/distance;
        p.fx += dx*scle;
        p.fy += dy*scle;
    }
    if (p.wt > 0) {
      p.vx += p.fx/p.wt;
      p.vy += p.fy/p.wt;
    }
    p.x += p.vx;
    p.y += p.vy;
  }
}

int passes;

void draw()
{
  doPhysics();
  background(255);
  stroke(0);
  strokeWeight(medRadius*1.5);
  for (int i = 0; i < nbrParticles; ++i) {
    point(particles[i].x, particles[i].y);
  }
  // println(passes++);
  if (frameCount % 60 == 0)
    println("fps = " + frameRate);

  
}

void keyPressed() {
  if (key == 's') {
    println("SNAP");
    saveFrame(outputPrefix +"_####.png");
  }
  else if (key == ' ' && captureMovie) {
   // mm.finish();
    // Quit running the sketch once the file is written
    exit();
  }
}

