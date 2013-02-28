import java.io.IOException;  
import org.w3c.dom.*;  
import org.xml.sax.SAXException;  
import javax.xml.parsers.*;  
import javax.xml.xpath.*;  

ArrayList getNodeContent(String _expr, int mode){

  ArrayList result = new ArrayList();

  NodeList list = query(_expr);
  for (int i = 0; i < list.getLength(); i++){
    String it[] = splitTokens(list.item(i).getTextContent()," \t\n");
    for(int q = 0 ; q < it.length;q++){
      switch(mode){
        case 0:
        result.add(it[q]+"");
        break;
        case 1:
        result.add((Integer)parseInt(it[q]));
        break;
        case 2:
        result.add((Float)parseFloat(it[q]));
        break;
      }

    }
  }
  return result;
}

NodeList getNode(String _expr){
  NodeList list = query(_expr);
  return list;
}


NodeList query(String _expr){
  NodeList nodes = null;

  try{
    // Standard of reading a XML file
    DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
    factory.setNamespaceAware(true);
    Document doc = DocumentBuilderFactory.newInstance().newDocumentBuilder().parse(filename);

    // Create a XPathFactory
    XPathFactory xFactory = XPathFactory.newInstance();

    // Create a XPath object
    XPath xpath = xFactory.newXPath();

    // Compile the XPath expression
    XPathExpression expr = xpath.compile(_expr);
    // Run the query and get a nodeset
    Object result = expr.evaluate(doc, XPathConstants.NODESET);

    // Cast the result to a DOM NodeList
    nodes = (NodeList) result;
    /*
       for (int i = 0; i < nodes.getLength(); i++) {
       println(nodes.item(i).getTextContent());
       }
     */


    /*

    // New XPath expression to get the number of people with name lars
    expr = xpath.compile("count(//person[firstname='Lars'])");
    // Run the query and get the number of nodes
    int number = ((Double) expr.evaluate(doc, XPathConstants.NUMBER)).intValue();
    println("Number of people named Iars: " + number);

    // Do we have more then 2 people with name lars?
    expr = xpath.compile("count(//person[firstname='Lars']) >2");
    // Run the query and get the number of nodes
    Boolean check = (Boolean) expr.evaluate(doc, XPathConstants.BOOLEAN);
    println("More than two? " + check);
     */
  }catch(Exception e){
    println("got some mistake "+e);
  }
  return nodes;
}
