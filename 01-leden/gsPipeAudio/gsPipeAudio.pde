/**
 * Audio pipeline.
 * By Andres Colubri
 *
 */

import codeanticode.gsvideo.*;

GSPipeline pipeline;

void setup() {
  size(100, 100);
 
 // Linux:
  pipeline = new GSPipeline(this, "playbin uri=file:/home/kof/01.mp3", GSVideo.AUDIO);
 
   pipeline.play();
}

void draw() {
  println(pipeline.time()/pipeline.duration());
  // No need to draw anything on the screen. The audio gets
  // automatically directed to the sound card.
}

