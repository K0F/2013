
//import processing.opengl.*;
import javax.media.opengl.GL;


PGraphicsOpenGL pgl; //need to use this to stop screen tearing
GL gl;

float speed1 = 50.0;
float speed2 = 51.0;

boolean render = false;

void setup(){
    size(1280,720);
    smooth();

    frameRate(60);
/*
    pgl = (PGraphicsOpenGL) g; //processing graphics object
    gl = pgl.beginGL(); //begin opengl
    gl.setSwapInterval(1); //set vertical sync on
    pgl.endGL(); //end opengl
*/
    //hint(ENABLE_OPENGL_4X_SMOOTH);

    background(0);
}


void draw(){
    background(0);


    for(int i = 0 ; i< 10;i++){

        pushMatrix();

        translate(noise((frameCount+i)/5.0)*4-2,noise((frameCount+i)/6.0)*4-2);

        noStroke();

        float r1 = (sin(frameCount/speed1)+1.0)*(sin(frameCount/(speed1+1.0))+1.0)*(sin(frameCount/(speed1+1.3713))+1.0)*height/8.0+5;
        float r2 = (sin(frameCount/(speed2+2.33))+1.0)*(sin(frameCount/(speed2+7.033))+1.0)*(sin(frameCount/(speed2+9.371333))+1.0)*height/8.0+5;


        boolean inverse = r1>=r2?true:false;


        if(inverse){
            fill(255,45);

            ellipse(width/2,height/2,r1,r1);


            fill(0);


            ellipse(width/2,height/2,r2,r2);
        }else{

            fill(255,45);

            ellipse(width/2,height/2,r2,r2);


            fill(0);


            ellipse(width/2,height/2,r1,r1);


        }



        popMatrix();


    }


        if(frameCount<=9750){
        
          if(render)
          saveFrame("/home/kof/render/jev_2_3/br#####.png");
        }else{
            exit();
        }


        println("frame "+frameCount);
}
