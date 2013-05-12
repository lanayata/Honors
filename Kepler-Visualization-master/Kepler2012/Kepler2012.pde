/*

 Kepler Visualization
 2011 - new data added in 2012
 blprnt@blprnt.com
 
 You can toggle between view modes with the keys 4,3,2,1,` 
 */

// Import libraries
import napplet.*;
import processing.opengl.*;
import controlP5.*;
import java.awt.Frame;

// Set up font
PFont label = createFont("Arial", 96);
// Here's the big list that will hold all of our planets
ArrayList<ExoPlanet> allPlanets = new ArrayList();
ArrayList<ExoPlanet> planets = new ArrayList();
// Conversion constants
float ER = 1;           // Earth Radius, in pixels
float AU = 1500;        // Astronomical Unit, in pixels
float YEAR = 50000;     // One year, in frames
// Max/Min numbers
float maxTemp = 3257;
float minTemp = 3257;
float yMax = 10;
float yMin = 0;
float maxSize = 0;
float minSize = 1000000;
// Axis labels
String xLabel = "Semi-major Axis (Astronomical Units)";
String yLabel = "Temperature (Kelvin)";
// Rotation Vectors - control the main 3D space
PVector rot = new PVector();
PVector trot = new PVector();
// Master zoom
float zoom = 0;
float tzoom = 0.3;
// This is a zero-one weight that controls whether the planets are flat on the
// plane (0) or not (1)
float flatness = 0;
float tflatness = 0;
// add controls (e.g. zoom, sort selection)
Controls controls; 
int showControls;
boolean draggingZoomSlider = false;


//////////////////////
// Owens Changes
//////////////////////
// Store what mode the visualisation is in ie:ESL 
String mode = "none";
// Store what layout the visualisation is in (orbital or graph)
String layout = "orbital";
// Selected planet that was last clicked on
ExoPlanet selectedPlanet = null;
// Set up second window
Textarea textArea;
ControlFrame cf;
//NAppletManager nappletManager;
//
ControlP5 cp5;

void setup() {
  size(displayWidth, displayHeight-300, OPENGL);
  background(0);
  smooth();  
  textFont(label, 96);
  // Because NASA released their data from 2011 and 2012 in somewhat
  // different formats, there are two functions to load the data and populate
  // the 'galaxy'.
  getPlanets(sketchPath + "/data/KeplerData.csv", false);
  getPlanets(sketchPath + "/data/planets2012_2.csv", true);
  addMarkerPlanets();
  updatePlanetColors();
  cp5 = new ControlP5(this);
  controls = new Controls();
  showControls = 1;

////////
//Owens Changes
////////
  
  cf = addControlFrame("Exoplanet Controls", displayWidth,250);
  
  //Set up slider for planet ESLg

  //
 /////////////// 
}

void getPlanets(String url, boolean is2012) {
  // Here, the data is loaded and a planet is made from each line.
  String[] pArray = loadStrings(url);
  int start = is2012 ? 0 : 1; // skip header on 2011 data
  for (int i = start; i < pArray.length; i++) {
    ExoPlanet p;
    if (is2012) {
      p = new ExoPlanet(this).fromCSV2012(split(pArray[i], ",")).init();
    } 
    else {
      p = new ExoPlanet(this).fromCSV(split(pArray[i], ",")).init();
    }
    allPlanets.add(p);
    maxSize = max(p.radius, maxSize);
    minSize = min(p.radius, minSize);

    // These are two planets from the 2011 data set that I wanted to feature.
    if (p.KOI.equals("326.01") || p.KOI.equals("314.02")) {
      p.feature = true;
      p.label = p.KOI;
    } 
  }
  planets = allPlanets;
}

void updatePlanetColors()
{
  // Calculate overall min/max temps (will include the marker planets this way)
  for (int i = 0; i < allPlanets.size(); i++)
  {
    ExoPlanet p = allPlanets.get(i);
    maxTemp = max(p.temp, maxTemp);
    minTemp = min(abs(p.temp), minTemp);
  }

  colorMode(HSB);
  for (int i = 0; i < allPlanets.size(); i++)
  {
    ExoPlanet p = allPlanets.get(i);

    if (0 < p.temp)
    {
      float h = map(sqrt(p.temp), sqrt(minTemp), sqrt(maxTemp), 200, 0);
      p.col = color(h, 255, 255);
    }
    else
    {
      // What should we do with planets that have a negative temp in kelvin?
      p.col = color(200, 255, 255);
    }
  }
  colorMode(RGB);
}


void addMarkerPlanets() {
  // Now, add the solar system planets
  ExoPlanet mars = new ExoPlanet(this);
  mars.period = 686;
  mars.radius = 0.533;
  mars.axis = 1.523;
  mars.temp = 212;
  mars.feature = true;
  mars.label = "Mars";
  mars.ESLs = 0.595;
  mars.ESLi = 0.815;
  mars.ESLg = 0.697;
  mars.init();
  allPlanets.add(mars);

  ExoPlanet earth = new ExoPlanet(this);
  earth.period = 365;
  earth.radius = 1;
  earth.axis = 1;
  earth.temp = 254;
  earth.ESLs = 1;
  earth.ESLi = 1;
  earth.ESLg = 1;
  earth.feature = true;
  earth.label = "Earth";
  earth.init();
  allPlanets.add(earth);

  ExoPlanet jupiter = new ExoPlanet(this);
  jupiter.period = 4331;
  jupiter.radius = 11.209;
  jupiter.axis = 5.2;
  jupiter.temp = 124;
  jupiter.ESLs = 0.238;
  jupiter.ESLi = 0.360;
  jupiter.ESLg = 0.292;
  jupiter.feature = true;
  jupiter.label = "Jupiter";
  jupiter.init();
  allPlanets.add(jupiter);

  ExoPlanet mercury = new ExoPlanet(this);
  mercury.period = 87.969;
  mercury.radius = 0.3829;
  mercury.axis = 0.387;
  mercury.temp = 434;
  mercury.ESLs = 0.422;
  mercury.ESLi = 0.840;
  mercury.ESLg = 0.596;
  mercury.feature = true;
  mercury.label = "Mercury";
  mercury.init();
  allPlanets.add(mercury);
}

void draw() {
  // Ease rotation vectors, zoom
  zoom += (tzoom - zoom) * 0.01;     
  if (zoom < 0)  {
     zoom = 0;
  } else if (zoom > 3.0) {
     zoom = 3.0;
  }
  controls.updateZoomSlider(zoom);  
  rot.x += (trot.x - rot.x) * 0.1;
  rot.y += (trot.y - rot.y) * 0.1;
  rot.z += (trot.z - rot.z) * 0.1;

  // Ease the flatness weight
  flatness += (tflatness - flatness) * 0.1;

  // MousePress - Controls Handling 
  if (mousePressed) {
     if((showControls == 1) && controls.isZoomSliderEvent(mouseX, mouseY)) {
        draggingZoomSlider = true;
        zoom = controls.getZoomValue(mouseY);        
        tzoom = zoom;
     } 
     
     // MousePress - Rotation Adjustment
     else if (!draggingZoomSlider) {
       trot.x += (pmouseY - mouseY) * 0.01;
       trot.z += (pmouseX - mouseX) * 0.01;
     }
     
  }



  background(10);
  
  // show controls
  if (showControls == 1) {
     controls.render(); 

  }
    
  // We want the center to be in the middle and slightly down when flat, and to the left and down when raised
  translate(width/2 - (width * flatness * 0.2), height/2 + (160 * rot.x));
  rotateX(rot.x);
  rotateZ(rot.z);
  scale(zoom);

  // Draw the sun
  fill(255 - (255 * flatness));
  noStroke();
  ellipse(0, 0, 10, 10);

  // Draw Rings:
  strokeWeight(2);
  noFill();

  // Draw a 2 AU ring
  stroke(255, 100 - (90 * flatness));
  ellipse(0, 0, AU * 2, AU * 2);

  // Draw a 1 AU ring
  stroke(255, 50 - (40 * flatness));
  ellipse(0, 0, AU, AU);

  // Draw a 10 AU ring
  ellipse(0, 0, AU * 10, AU * 10);

  // Draw the Y Axis
  stroke(255, 100);
  pushMatrix();
  rotateY(-PI/2);
  line(0, 0, 500 * flatness, 0);

  // Draw Y Axis max/min
  pushMatrix();
  fill(255, 100 * flatness);
  rotateZ(PI/2);
  textFont(label);
  textSize(12);
  text(round(yMin), -textWidth(str(yMin)), 0);
  text(round(yMax), -textWidth(str(yMax)), -500);
  popMatrix();

  // Draw Y Axis Label
  fill(255, flatness * 255);
  text(yLabel, 250 * flatness, -10);

  popMatrix();

  // Draw the X Axis if we are not flat
  pushMatrix();
  rotateZ(PI/2);
  line(0, 0, 1500 * flatness, 0);

  if (flatness > 0.5) {
    pushMatrix();
    rotateX(PI/2);
    line(AU * 1.06, -10, AU * 1.064, 10); 
    line(AU * 1.064, -10, AU * 1.068, 10);   
    popMatrix();
  }

  // Draw X Axis Label
  fill(255, flatness * 255);
  rotateX(-PI/2);
  text(xLabel, 50 * flatness, 17);

  // Draw X Axis min/max
  fill(255, 100 * flatness);
  text(1, AU, 17);
  text("0.5", AU/2, 17);

  popMatrix();

  // Render the planets
  for (int i = 0; i < planets.size(); i++) {
    ExoPlanet p = planets.get(i);
    if (p.vFlag < 4) {
      p.update();
      p.render();
    }
  }    
  

  
}
ControlFrame addControlFrame(String theName, int theWidth, int theHeight) {
  Frame f = new Frame(theName);
  System.out.println("jere"+f);
  ControlFrame p = new ControlFrame(this, theWidth, theHeight);
  f.add(p);
  p.init();
  f.setTitle(theName);
  f.setSize(p.w, p.h);
  f.setLocation(100, 100);
  f.setResizable(false);
  f.setVisible(true);
  return p;
}
void sortBySize() {
        mode = "size";
  // Raise the planets off of the plane according to their size
  for (int i = 0; i < planets.size(); i++) {
    planets.get(i).tz = map(planets.get(i).radius, 0, maxSize, 0, 500);
  }
   for (int i = 0; i < allPlanets.size(); i++) {
    allPlanets.get(i).tz = map(allPlanets.get(i).radius, 0, maxSize, 0, 500);
  }
}

void sortByTemp() {
      mode = "temp";
  // Raise the planets off of the plane according to their temperature
  for (int i = 0; i < planets.size(); i++) {
    planets.get(i).tz = map(planets.get(i).temp, minTemp, maxTemp, 0, 500);
  }
    for (int i = 0; i < allPlanets.size(); i++) {
    allPlanets.get(i).tz = map(allPlanets.get(i).temp, minTemp, maxTemp, 0, 500);
  }
}

void sortByESL() {
  // Raise the planets off of the plane according to their ESL
  for (int i = 0; i < planets.size(); i++) {
    planets.get(i).tz = map(planets.get(i).ESLs, 0, 1, 0, 500);
  }
   for (int i = 0; i < allPlanets.size(); i++) {
    allPlanets.get(i).tz = map(allPlanets.get(i).ESLs, 0, 1, 0, 500);
  }
   mode = "ESL";
}

void unSort() {
  // Put all of the planets back onto the plane
  for (int i = 0; i < planets.size(); i++) {
    planets.get(i).tz = 0;
  }
    for (int i = 0; i < allPlanets.size(); i++) {
    allPlanets.get(i).tz = 0;
  }
}

void keyPressed() {
  String timeStamp = hour() + "_"  + minute() + "_" + second();
  if (key == 's') {
    save("out/Kepler" + timeStamp + ".png");
  } else if (key == 'c'){
     showControls = -1 * showControls;
  }

  if (keyCode == UP) {
    tzoom += 0.025;
  } 
  else if (keyCode == DOWN) {
    tzoom -= 0.025;
  }

  if (key == '1') {
    sortBySize(); 
    //toggleFlatness(1);
    yLabel = "Planet Size (Earth Radii)";
    xLabel = "Semi-major Axis (Astronomical Units)";
    yMax = maxSize;
    yMin = 0;
  } 
  else if (key == '2') {
    sortByTemp(); 
    //trot.x = PI/2;
    yLabel = "Temperature (Kelvin)";
    //toggleFlatness(1);
    xLabel = "Semi-major Axis (Astronomical Units)";
    yMax = maxTemp;
    yMin = minTemp;
 
  } 
  
  else if (key == '0') { 
    // TODO Earth needs to be placed at center of data
    sortByESL(); //Sort data by earth similarity index
    yLabel = "Surface ESL";
    xLabel = "Interior ESL";

    //toggleFlatness(1);
    yMax = 1.0;
    yMin = 0.0;
    mode = "ESL";
  } 
  
  else if (key == '`') {
    unSort(); 
    toggleFlatness(0);
  }
  else if (key == '3') {
    trot.x = 1.5;
  }
  else if (key == '4') {
    tzoom = 1;
  }

  if (key == 'f') {
    tflatness = (tflatness == 1) ? (0):(1);
    toggleFlatness(tflatness);
  }
}

void toggleFlatness(float f) {
  tflatness = f;
  if (layout.equals("orbital")){
  layout = "graph";
  }
  else {
  layout = "orbital";
  }
  if (tflatness == 1) {
    trot.x = PI/2;
    trot.z = -PI/2;
  }
  else {
    trot.x = 1;
  }
}

void mouseReleased() {
   draggingZoomSlider = false;
}

void mousePressed(){
       for (int i = 0; i < planets.size(); i++) {
    if(planets.get(i).overPlanet()){
      selectedPlanet = planets.get(i);
      textArea.setText(
      "Kepler Plantary Index (KOI): \t"+selectedPlanet.KOI 
      +"\nTemperature: \t"+selectedPlanet.temp
      +"\nGravity: \t"+selectedPlanet.KOI
      +"\nZone Class: \t"+selectedPlanet.zone_class
      +"\nMass Class: \t"+selectedPlanet.mass_class
      +"\nComposition Class: \t"+selectedPlanet.composition_class
      +"\nHabitable Class: \t"+selectedPlanet.habitable_class
      +"\nAtmosphere Class: \t"+selectedPlanet.atmosphere_class
      +"\nTechnology Discovered By: \t"+selectedPlanet.disc_tech
      +"\nYear Discovered: \t"+selectedPlanet.disc_year
      +"\nESLg: \t"+selectedPlanet.ESLg
      +"\nESLi: \t"+selectedPlanet.ESLi
        +"\nESLs: \t"+selectedPlanet.ESLs
      );
      break;
    }
  }
}

//public class MeanWindow extends NApplet {   
// 
//  public void setup() {    size(250, 250);    nappletCloseable = false; 
//// Not actually necessary, false by default.  
//  }  
//public void draw() {    background(100, 0, 0);    stroke(255);    fill(255);        }  
//
//} 
