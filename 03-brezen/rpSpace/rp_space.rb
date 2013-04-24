# Rp Space


class RpSpace < Processing::App


  def setup
 
    size 800, 870, P2D

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
   
    @@alpha.draw

    
  end
  
end


class Alpha 

  def initialize
    $app.println `date`
    @x = $app.width / 2
    @y = $app.height / 2
    @d = 20
  end

  def move
    @x += ($app.noise($app.frameCount/10.0,0)-0.5)*5
    @y += ($app.noise(0,$app.frameCount/10.0)-0.5)*5
  end

  def draw
    move
    $app.fill 255
    $app.noStroke
    $app.ellipse @x,@y,@d,@d

  end


end

RpSpace.new :title => "Rp Space"
