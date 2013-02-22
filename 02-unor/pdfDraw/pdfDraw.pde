import processing.pdf.*;

float DISTANCE = 75.0;
float ALPHA = 10.0;
int MAX_LINES_PER_FRAME = 20;

float X, Y, pX, pY;

Trace trace;

int counter = 0;

void setup() {
  size(1600, 900, P2D); 


  frameRate(120);

  trace = new Trace();

  beginRecord(PDF, "everything.pdf");
  background(255);
  strokeWeight(0.5);
}

void draw() {
  X = mouseX;
  Y = mouseY;
  pX = pmouseX;
  pY = pmouseY;


  stroke(0, ALPHA);


  counter = 0;
  trace.draw();
}

void mouseDragged() {

  trace.paint = true;
}

void mouseReleased() {
  trace.paint = false;
  trace = new Trace();
}

void mousePressed() {
  if (mouseButton==RIGHT) {
    background(255);
  }
}

void keyPressed() {
  endRecord();
  exit();
}


class Trace {
  ArrayList points;
  boolean paint;

  Trace() {
    points = new ArrayList();
    paint = false;
  }

  void add() {
    points.add(new PVector(X, Y));
  }

  void draw() {

    if (paint)
      add();

    for (int i = 0; i < points.size();i++) {
      PVector tmp = (PVector)points.get(i);
      float dist = dist(tmp.x, tmp.y, X, Y);
      float atan = degrees(atan2(tmp.y-Y, tmp.x-X));
      float dir = degrees(atan2(pY-Y, pX-X));

      if (dist < DISTANCE && (dir-atan) < 10 && counter < MAX_LINES_PER_FRAME) {
        stroke(0, abs(atan)/(dist*2.0)*ALPHA);
        line(tmp.x, tmp.y, X, Y);
        counter++;
      }
    }
  }
}

