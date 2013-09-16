import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.jsoup.nodes.Element;
import org.jsoup.select.Elements;


Piece list;

void init(){



  frame.removeNotify();

  frame.setUndecorated(true);

  frame.addNotify();

  super.init();
}

void setup(){

  size(320,900,P2D);

  frame.setLocation(0,0);
  list = new Piece();

  textFont(createFont("Semplice Regular",8,false));
}


void draw(){
  background(0);
  fill(255);
  list.draw();
}


class Piece{
  Document doc;

  Piece(){
    get();
  }

  void get(){

    try {

      // need http protocol
      File input = new File(sketchPath+"/data/test.txt");

      doc = Jsoup.parse(input,"UTF-8");
      //connect("http://www.openprocessing.org/user/3942").get();

      // get page title
      String title = doc.title();
      //System.out.println("title : " + title);

    } catch (IOException e) {
      e.printStackTrace();
    }

  }

  void draw(){
    int i = 0 ;
    // get all links
    Elements links = doc.select("div[class$=descriptionBox]");
    for (Element link : links) {

      noStroke();
      fill(32*noise(i+frameCount/10.0));
      rect(0,i*12-12,width,12);
      fill(#ffcc00);
      text(link.text(),10,i*12-3);
      i++;
    }
  }
}
