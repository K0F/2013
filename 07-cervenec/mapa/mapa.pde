/* @pjs font="SempliceRegular-8.vlw";
*/

PImage mapa;
ArrayList mista;

int shiftx = 100;
int shifty = 50;




String L = "12°5'50.46\"E";
String T = "51°0'27.75\"N";
String B = "48°31'55.93\"N";
String R = "18°49'38.02\"E";



void setup() {
  size(1000, 600, P2D); 

  frameRate(25);


  mapa = loadImage("mapa.png");
  // mapa.disableStyle();



  rectMode(CENTER);
  textFont(createFont("Semplice Regular",8,false));
  textAlign(CENTER);

  mista = new ArrayList();

  mista.add(new Misto("Plzen", "49 44 50.91", "13 22 39.39"));
  mista.add(new Misto("Ostrava", "49°49'5.69", "18°15'41.34"));


  mista.add(new Misto("Ostrava", " 50°57'8.29\"N", " 14°27'41.14\"E"));

  mista.add(new Misto("test", "49°31'53.05\"N", "18°47'46.77\"E"));
}





void draw() {

  background(255);

  stroke(0, 10);
  noFill();


  translate(shiftx, shifty);
  pushMatrix();

  image(mapa, 0, 0);
  popMatrix();


  for (int i = 0 ; i < mista.size();i++) {
    Misto tmp = (Misto)mista.get(i);
    tmp.draw();
  }
}

class Misto {
  PVector pos;
  String name;

  Misto( String _name, String _lat, String _lon) {
    pos = coordToXY(_lat, _lon);
    name = _name;
  }

  void draw() {


    noStroke();
    fill(0);  

    rect(pos.x, pos.y, 5, 5);

    if (over())
      text(name, pos.x, pos.y-7);
  }

  boolean over() {
    return dist(mouseX, mouseY, pos.x+shiftx, pos.y+shifty) < 100;
  }




  PVector coordToXY(String lat, String lon) {

    float correctedLat = parseFloat(lat) + 90;
    float correctedLon = parseFloat(lon) + 90;
    float x = (float)(correctedLat * (height / 180) );
    float y = (float)(correctedLon * (width / 180) );



    String lonX = splitTokens(lon, " \"'°ENVS");
    String latY = splitTokens(lat, " \"'°ENVS");

    float dx = parseFloat(lonX[0]);
    float mx = parseFloat(lonX[1]);
    float sx = parseFloat(lonX[2]);


    float dy = parseFloat(latY[0]);
    float my = parseFloat(latY[1]);
    float sy = parseFloat(latY[2]);

    PVector calc = new PVector(
    map(
    dx + mx / 60.0 + sx / 3600.0, 
    12.0 +  5.0 / 60.0 + 50.46 / 3600.0, 
    18.0 + 49.0 / 60.0 + 38.02 / 3600.0, 
    0, 807), 

    map(
    dy + my / 60.0 + sy / 3600.0, 
    48.0 + 31.0 / 60.0 + 55.93 / 3600.0, 
    51.0 + 0.0 + 27.75 / 3600.0, 
    465.0, 0)
      );

    return calc;
  }
}

