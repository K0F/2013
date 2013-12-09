import ComputationalGeometry.*;

IsoSkeleton skeleton;
PVector[] pts = new PVector[50];

void setup(){
  size(800,600,P3D);

  skeleton = new IsoSkeleton(this);

  //Constructing the IsoSkeleton

  // Create points to make the network
  for (int i=0; i<pts.length; i++) {
    pts[i] = new PVector(random(-100, 100), random(-100, 100), random(-100, 100) );
  }  

  // Add edges to IsoSkeleton
  for (int i=0; i<pts.length; i++) {
    for (int j=i+1; j<pts.length; j++) {
      if (pts[i].dist( pts[j] ) < 60) {
        skeleton.addEdge(pts[i], pts[j]);
      }
    }
  }
  frameCount = 10;
}


void draw(){
  background(0);

  float speed = 0.5;

  for (int i=0; i<pts.length; i++) {
    int one = (int)random(pts.length);
    int two = (int)random(pts.length);

    if(i!=one && i!=two){
    float d1 = pts[i].dist(pts[one]);
    float d2 = pts[i].dist(pts[two]);


    pts[i].x += (pts[one].x-pts[i].x)/(speed*d1);
    pts[i].y += (pts[one].y-pts[i].y)/(speed*d1);
    pts[i].z += (pts[one].z-pts[i].z)/(speed*d1);
  
    pts[i].x -= (pts[two].x-pts[i].x)/(speed*d2);
    pts[i].y -= (pts[two].y-pts[i].y)/(speed*d2);
    pts[i].z -= (pts[two].z-pts[i].z)/(speed*d2);
    }
  }  
/*
  skeleton = new IsoSkeleton(this);

 for (int i=0; i<pts.length; i++) {
    for (int j=i+1; j<pts.length; j++) {
      if (pts[i].dist( pts[j] ) < 80) {
        skeleton.addEdge(pts[i], pts[j]);
      }
    }
  }
*/
  noStroke();//stroke(255,60);
  fill(255);
  lights();
  translate(width/2,height/2);
  rotateY(frameCount/40.0);
  // Plotting 
  skeleton.plot(8.5f, 0.25f);  // Thickness as parameter
}


class Point{
  PVector pos,acc,vel;

}
