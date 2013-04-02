# Rp Testing

class RpTesting < Processing::App

  def setup
    size 800,900,P2D


    # hack to not loose focus when watched
    # live session is here!
    frame.removeNotify();
    frame.setLocation(0,0);
    frame.setFocusableWindowState(false);
    #frame.setFocusable(false);
    frame.setTitle("live session");
    frame.addNotify();

    smooth
  end

  def draw
    c = color 0
    background c

    fill(255,50);
    noStroke
    r = 10;

    for i in 0..1000
      x = cos(frameCount/(20.0+i))*(width/3.0*pow(i/100.0,cos((frameCount+i)/200.0)*0.1)-r/2.0)+width/2
      y = sin(frameCount/(20.0+i))*(width/3.0*pow(i/1000.0,sin((frameCount+i)/222.0)*0.1)-r/2.0)+width/2

      ellipse(x,y,r,r);
    end
  end

end



RpTesting.new :title => "Rp Testing"
