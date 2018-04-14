import org.gicentre.geomap.*;
import java.util.Map;

float RAND_RANGE = 10.0;
float CIRCLE_R = 18.0;
 
GeoMap geoMap;
HashMap<String, PVector> geoLoc = new HashMap<String, PVector>();
HashMap<String, Float> geoProb = new HashMap<String, Float>();
float geoProbLow = 1000.0;
float geoProbHigh = 0.0;
 
void setup() {
  //size(1250, 700);
  size(1800, 1000);
  
  geoMap = new GeoMap(this);
  geoMap.readFile("110m_cultural/ne_110m_admin_0_countries_lakes");   // Reads shapefile.
  
  //String[] result = loadStrings("result_naive.txt");
  String[] result = loadStrings("result_naive.txt");
  for(String line: result){
    String[] segs = split(line, ": ");
    float oneGeoProb = float(segs[1])*1000;
    geoProb.put(segs[0], oneGeoProb);
    if(oneGeoProb < geoProbLow) {
      geoProbLow = oneGeoProb;
    }
    if(oneGeoProb > geoProbHigh) {
      geoProbHigh = oneGeoProb;
    }
  }
  
  String[] longlat = loadStrings("longlat.csv");
  for(String line: longlat) {
    String[] segs = split(line, ",");
    geoLoc.put(segs[0], geoMap.geoToScreen(float(segs[1]), float(segs[2])));
  }
}
 
void draw() { 
  background(255, 255, 255);  // Ocean colour
  fill(220,220,220);          // Land colour
  stroke(0,40);               // Boundary colour
  geoMap.draw();              // Draw the entire map.
  
  PVector loc;
  for(Map.Entry geoLoc_me: geoLoc.entrySet()) {
    loc = (PVector) geoLoc_me.getValue();
    float red = (Float) geoProb.get(geoLoc_me.getKey());
    red = map(red, geoProbLow, geoProbHigh, 0, 255);
    fill(red, 0, 0, 180);
    ellipse(loc.x+random(RAND_RANGE)-RAND_RANGE/2, loc.y+random(RAND_RANGE)-RAND_RANGE/2, 
      CIRCLE_R, CIRCLE_R);
  }
  
  loc = geoMap.geoToScreen(1, 2);
  
  fill(0, 0, 180, 180);
  ellipse(loc.x, loc.y, CIRCLE_R, CIRCLE_R);
      
  loc = geoMap.geoToScreen(1, 2);
  fill(0, 0, 200, 180);
  ellipse(loc.x, loc.y, CIRCLE_R, CIRCLE_R);
  noLoop();
}
