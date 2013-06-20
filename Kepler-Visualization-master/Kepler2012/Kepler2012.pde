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
// List of planets for displaying when filtered
ArrayList<ExoPlanet> planets = new ArrayList();
// Conversion constants
float ER = 1;           // Earth Radius, in pixels
float AU = 1500;        // Astronomical Unit, in pixels
float YEAR = 50000;     // One year, in frames
// Max/Min numbers
float globalMaxTemp = 3257;
float globalMinTemp = 3257;
float yMax = 10;
float yMin = 0;
float globalMaxSize = 0;
float globalMinSize = 1000000;
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

boolean pausedVis = true; // if visualisation paused
boolean greyOutPlanets = true;
  float planetMinTemp = 83;
  float planetMaxTemp = 3867;
  float planetMinSize = 0.33;
  float planetMaxSize = 58.06; 
  float planetMinESI = -1;
  float planetMaxESI = 2;
  float planetMinKOI = 1;
  float planetMaxKOI = 2771;
//////////////////////
// Owens Changes
//////////////////////
// Store what mode the visualisation is in ie:ESI 
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
  
  //Set up slider for planet ESIg

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
    if (p.ESIi <0 || p.ESIs <0 || p.ESIg <0) 
    System.out.println("KOI: "+p.KOI+"  ESIi: "+p.ESIi+"  ESIs: "+p.ESIs+"  ESIg: "+p.ESIg);
    allPlanets.add(p);
    globalMaxSize = max(p.radius, globalMaxSize);
    globalMinSize = min(p.radius, globalMinSize);

    // These are two planets from the 2011 data set that I wanted to feature.
    if (p.KOI == 326.01 || p.KOI == 314.02) {
     // p.feature = true;
    //  p.label = p.KOI;
    } 
  }
    for (int i = 0; i < allPlanets.size(); i++)
  {
  planets.add(allPlanets.get(i));
}
}

void updatePlanetColors()
{
  // Calculate overall min/max temps (will include the marker planets this way)
  for (int i = 0; i < allPlanets.size(); i++)
  {
    ExoPlanet p = allPlanets.get(i);
    globalMaxTemp = max(p.temp, globalMaxTemp);
    globalMinTemp = min(abs(p.temp), globalMinTemp);
  }

  colorMode(HSB);
  for (int i = 0; i < allPlanets.size(); i++)
  {
    ExoPlanet p = allPlanets.get(i);

    if (0 < p.temp)
    {
      float h = map(sqrt(p.temp), sqrt(globalMinTemp), sqrt(globalMaxTemp), 200, 0);
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
  mars.label = "Mars";
  mars.ESIs = 0.595;
  mars.ESIi = 0.815;
  mars.ESIg = 0.697;
  mars.corePlanet = true;
  mars.init();
  allPlanets.add(mars);

  ExoPlanet earth = new ExoPlanet(this);
  earth.period = 365;
  earth.radius = 1;
  earth.axis = 1;
  earth.temp = 254;
  earth.ESIs = 1;
  earth.ESIi = 1;
  earth.ESIg = 1;
  earth.label = "Earth";
  earth.corePlanet = true;
  earth.init();
  allPlanets.add(earth);

  ExoPlanet jupiter = new ExoPlanet(this);
  jupiter.period = 4331;
  jupiter.radius = 11.209;
  jupiter.axis = 5.2;
  jupiter.temp = 124;
  jupiter.ESIs = 0.238;
  jupiter.ESIi = 0.360;
  jupiter.ESIg = 0.292;
  jupiter.label = "Jupiter";
  jupiter.corePlanet = true;
  jupiter.init();
  allPlanets.add(jupiter);

  ExoPlanet mercury = new ExoPlanet(this);
  mercury.period = 87.969;
  mercury.radius = 0.3829;
  mercury.axis = 0.387;
  mercury.temp = 434;
  mercury.ESIs = 0.422;
  mercury.ESIi = 0.840;
  mercury.ESIg = 0.596;
  mercury.label = "Mercury";
  mercury.corePlanet = true;
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
  try{
    ExoPlanet p = planets.get(i);
        if(p!=null){
    if (p.vFlag < 4) {
      p.update();
      p.render();
    }
    }
  }
  catch(IndexOutOfBoundsException e){

}

  }    
  

  
}
ControlFrame addControlFrame(String theName, int theWidth, int theHeight) {
  Frame f = new Frame(theName);
  
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
    planets.get(i).tz = map(planets.get(i).radius, planetMinSize, planetMaxSize, 0, 500);
  }
  
}

void sortByTemp() {
      mode = "temp";
  // Raise the planets off of the plane according to their 2temperature

    for (int i = 0; i < planets.size(); i++) {
    planets.get(i).tz = map(planets.get(i).temp, planetMinTemp, planetMaxTemp, 0, 500);
  }

}

void sortByESI() {
  // Raise the planets off of the plane according to their ESI
   for (int i = 0; i < planets.size(); i++) {
    planets.get(i).tz = map(planets.get(i).ESIs, planetMinESI, planetMaxESI, 0, 500);
  }
   mode = "ESI";
}

void unSort() {
  // Put all of the planets back onto the plane
  for (int i = 0; i < planets.size(); i++) {
    planets.get(i).tz = 0;
  }
  mode = "none";
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
    yMax = globalMaxSize;
    yMin = 0;
  } 
  else if (key == '2') {
    sortByTemp(); 
    //trot.x = PI/2;
    yLabel = "Temperature (Kelvin)";
    //toggleFlatness(1);
    xLabel = "Semi-major Axis (Astronomical Units)";
    yMax = globalMaxTemp;
    yMin = globalMinTemp;
 
  } 
  
  else if (key == '0') { 
    // TODO Earth needs to be placed at center of data
    sortByESI(); //Sort data by earth similarity index
    yLabel = "Surface ESI";
    xLabel = "Interior ESI";

    //toggleFlatness(1);
    yMax = 1.0;
    yMin = 0.0;
    mode = "ESI";
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
      selectedPlanet.feature = true;
      selectedPlanet.label = "Selected: KOI- "+selectedPlanet.KOI;
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
      +"\nESIg: \t"+selectedPlanet.ESIg
      +"\nESIi: \t"+selectedPlanet.ESIi
        +"\nESIs: \t"+selectedPlanet.ESIs
      );
          ArrayList<ExoPlanet> toUnFeature = new ArrayList<ExoPlanet>();
            for (int j = 0; j < planets.size(); j++) {
              ExoPlanet p = planets.get(j);
              if (i != j){
             if (p.sun_name!=null && p.sun_name.equals(selectedPlanet.sun_name)){
               p.feature = true;
               p.label = "Same Star: KOI-"+p.KOI;
             }
             else {        
              toUnFeature.add(p);
              }
             }
            }
            for (int j = 0; j < toUnFeature.size(); j++) {
            toUnFeature.get(j).feature = false;
            }
      
      break;
    }
  }
}

