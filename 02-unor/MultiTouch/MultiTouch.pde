// multiTouchCore.pde
// Eric Pavey - 2011-01-02
// Code used to get multitouch working in Processing.
// Add to what's in the draw() function to implement the magic.

// It's all about the MotionEvent:
// http://developer.android.com/reference/android/view/MotionEvent.html

//------------------------------
// Setup globals:
import android.view.MotionEvent;
// Define max touch events.  My phone (seems to) support 5.
int maxTouchEvents = 5;
// This array will hold all of our queryable MultiTouch data:
MultiTouch2[] mt;         

//------------------------------
void setup() {
  // Populate our MultiTouch array that will track all of our touch-points:
  mt = new MultiTouch2[maxTouchEvents];
  for(int i=0; i < maxTouchEvents; i++) {
    mt[i] = new MultiTouch2();
  }
  
  background(255);
}

//------------------------------
void draw() {
  stroke(0);
  // If the screen is touched, start querying for MultiTouch events:
  if (mousePressed == true) {
    // ...for each possible touch event...
    for(int i=0; i < maxTouchEvents; i++) {
      // If that event been touched...
      if(mt[i].touched == true) {
        line(mt[i].motionX,mt[i].motionY,mt[i].pmotionX,mt[i].pmotionY);
        // DO SOMETHING WITH IT HERE:
        // Amazing mult-touch graphics implemeneted....
      }
    }
  }
}  

//------------------------------
// Override parent class's surfaceTouchEvent() method to enable multi-touch.
// This is what grabs the Android multitouch data, and feeds our MultiTouch
// classes.  Only executes on touch change (movement across screen, or initial
// touch).

public boolean surfaceTouchEvent(MotionEvent me) {
  // Find number of touch points:
  int pointers = me.getPointerCount();
  // Set all MultiTouch data to "not touched":
  for(int i=0; i < maxTouchEvents; i++) {
    mt[i].touched = false;
  }
  //  Update MultiTouch that 'is touched':
  for(int i=0; i < maxTouchEvents; i++) {
    if(i < pointers) {
      mt[i].update(me, i);
    }
    // Update MultiTouch that 'isn't touched':
    else {
      mt[i].update();
    }
  }

  // If you want the variables for motionX/motionY, mouseX/mouseY etc.
  // to work properly, you'll need to call super.surfaceTouchEvent().
  return super.surfaceTouchEvent(me);
}

//------------------------------
// Class to store our multitouch data per touch event.

class MultiTouch2 {
  // Public attrs that can be queried for each touch point:
  float motionX, motionY;
  float pmotionX, pmotionY;
  float size, psize;
  int id;
  boolean touched = false;

  // Executed when this index has been touched:
  //void update(MotionEvent me, int index, int newId){
  void update(MotionEvent me, int index) {
    // me : The passed in MotionEvent being queried
    // index : the index of the item being queried
    // newId : The id of the pressed item.

    // Tried querying these via' the 'historical' methods,
    // but couldn't get consistent results.
    pmotionX = motionX;
    pmotionY = motionY;
    psize = size; 

    motionX = me.getX(index);
    motionY = me.getY(index);
    size = me.getSize(index);

    id = me.getPointerId(index);
    touched = true;
  }

  // Executed if this index hasn't been touched:
  void update() {
    pmotionX = motionX;
    pmotionY = motionY;
    psize = size;
    touched = false;
  }
}
