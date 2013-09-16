import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.jsoup.nodes.Element;
import org.jsoup.select.Elements;


Piece list;

void setup(){

  size(320,240,P2D);

  list = new Piece();
}


void draw(){

  background(0);




}


class Piece(){
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
      System.out.println("title : " + title);

      // get all links
      Elements links = doc.select("div[class$=descriptionBox]");
      for (Element link : links) {

        // get the value from href attribute
        println("text : " + link.text());
        //     println("link : " + link.attr("a[href]"));

      }


    } catch (IOException e) {
      e.printStackTrace();
    }




  }
}
