# Rp Space


class RpSpace < Processing::App


  def setup
 
    size 640, 480, P2D

    @@alpha = Alpha.new

    # hack to not loose focus when watched
    # live session is here!
    frame.removeNotify();
    frame.setLocation(0,0);
    frame.setFocusableWindowState(false);
    #frame.setFocusable(false);
    frame.setTitle("live session");
    frame.addNotify();
  end
  
  def draw
    background 0
  end
  
end


class Alpha 

  def initialize
    $app.println "created"
  end

end

RpSpace.new :title => "Rp Space"
