
float phase;

void setup(){
  size(320,320,P3D);
  phase = pow(cos(moonPhase() / 100.0-1),-1.0);
}

void draw(){
  background(0);
  translate(width/2,height/2,0);
  pointLight(255,255,255,cos(phase)*200,0.01,sin(phase)*200);

  noStroke();
  fill(255);
  sphere(100);

}

float moonPhase(){
  int day = day();
  int month = month();
  int year = year();

  int [] ages = {18, 0, 11, 22, 3, 14, 25, 6, 17, 28, 9, 20, 1, 12, 23, 4, 15, 26, 7};
  int [] offsets = {-1, 1, 0, 1, 2, 3, 4, 5, 7, 7, 9, 9};
  String [] description = {"new (totally dark)",
    "waxing crescent (increasing to full)",
    "in its first quarter (increasing to full)",
    "waxing gibbous (increasing to full)",
    "full (full light)",
    "waning gibbous (decreasing from full)",
    "in its last quarter (decreasing from full)",
    "waning crescent (decreasing from full)"};
  String [] months = {"Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"};

  if(day == 31)
    day = 1;

  int days_into_phase = ((ages[(year + 1) % 19] + ((day + offsets[month-1]) % 30) + (year)) % 30);
  int index = (int)((days_into_phase + 2) * 16/59.0);
  if (index > 7)
    index = 7;

  String status = description[index];

  // light should be 100% 15 days into phase
  float light = (2 * days_into_phase * 100/29.0);

  if (light > 100)
    light = abs(light - 200);

  println(day+" "+months[month-1]+" "+year+" "+status+" "+light);

  return light;
}
