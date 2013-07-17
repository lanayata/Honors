/*

 Kepler Visualization
 2011 - new data added in 2012
 blprnt@blprnt.com
 
 You can toggle between view modes with the keys 4,3,2,1,` 
 */

// Import libraries
import processing.opengl.*;
import controlP5.*;
import java.awt.Frame;
import processing.opengl.*;
import javax.media.opengl.GL;

PGraphicsOpenGL pgl;
GL gl;

// Set up font
PFont label = createFont("Arial", 96);



// Images
PImage sunImage;
PShape oval;

// ExoPlanets
ArrayList<ExoPlanet> allPlanets = new ArrayList(); // Holds all planets
ArrayList<ExoPlanet> planets = new ArrayList(); // List of planets for displaying when filtered

// Conversion constants
float ER = 1;           // Earth Radius, in pixels
float AU = 1500;        // Astronomical Unit, in pixels
float YEAR = 50000;     // One year, in frames

/////////////////////
// Max/Min numbers //
/////////////////////
//Scale
float yMax = 10;
float yMin = 0;
//Global
float globalMaxTemp = 3257;
float globalMinTemp = 3257;
float globalMaxSize = 0;
float globalMinSize = 1000000;
float globalMinKOI = 1;
float globalMaxKOI = 2771;
float globalMinESI = 0;
float globalMaxESI = 1;
//Planet Specific
float planetMinTemp = 83;
float planetMaxTemp = 3867;
float planetMinSize = 0.33;
float planetMaxSize = 58.06; 
float planetMinESI = 0;
float planetMaxESI = 1;
float planetMinKOI = 1;
float planetMaxKOI = 2771;

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
int max = 1000;
//Visualisation State Variables
boolean pausedVis = true; // if visualisation paused
boolean greyOutPlanets = true; 
String mode = "none"; // Store what mode the visualisation is in ie:ESI 
String layout = "orbital"; // Store what layout the visualisation is in (orbital or graph)
ExoPlanet selectedPlanet = null;// Selected planet that was last clicked on
ExoPlanet selectedPlanetToCompare = null; // Selected planet to compare
boolean compare= false; // Compare button clicked boolean

// Second Control frame window 
ControlP5 cp5; // Library for the control frame
ControlFrame cf; 

// Text areas in control frame
Textarea textArea; // main text area
Textarea textAreaToCompare; // second text area
Textarea compareInfo; // pop up text area informing user how to compare


// Main label of system
String visualisationState="";
String visualisationLayout="Orbital View";
void setup() {

  oval = loadShape("circle.svg");
  oval.disableStyle();
  size(displayWidth-300, displayHeight, P3D);
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

  cf = addControlFrame("Exoplanet Controls", 300, displayHeight);
  sunImage = loadImage("sun3.png");
  pgl = (PGraphicsOpenGL) g; //processing graphics object
  gl = g.beginPGL().gl;
  gl.setSwapInterval(1); //set vertical sync on
  g.endPGL(); //end opengl
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
  background( 255 );
  // Ease rotation vectors, zoom
  zoom += (tzoom - zoom) * 0.01;     
  if (zoom < 0) {
    zoom = 0;
  } 
  else if (zoom > 3.0) {
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
    if ((showControls == 1) && controls.isZoomSliderEvent(mouseX, mouseY)) {
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
  image(sunImage, -10, -10, 20, 20);

    if (layout.equals("orbital") && greyOutPlanets && selectedPlanet != null) {
      pushMatrix();
      stroke(255, 100);
      translate(0, 0, -100);
      fill(255, 0, 0, 50);
      ellipse(0, 0, (int) selectedPlanet.sun_hab_zone_max, (int) selectedPlanet.sun_hab_zone_max);
      fill(0, 255, 0, 100);
      translate(0, 0, 2);
      ellipse(0, 0, (int) (selectedPlanet.sun_hab_zone_max - selectedPlanet.sun_hab_zone_min), (int) (selectedPlanet.sun_hab_zone_max - selectedPlanet.sun_hab_zone_min));
      translate(0, 0, 2);
      fill(0, 0, 0);
      ellipse(0, 0, (int) selectedPlanet.sun_hab_zone_min, (int) selectedPlanet.sun_hab_zone_min); 
      translate(0, 0, 2);
      fill(255, 0, 0, 50);
      ellipse(0, 0, (int) selectedPlanet.sun_hab_zone_min, (int) selectedPlanet.sun_hab_zone_min);       
      popMatrix();
    }

 else if (layout.equals("orbital")) {   

    // Draw Rings:
    strokeWeight(2);
    noFill();

    // Draw a 2 AU ring
    stroke(255, 100);
    //ellipse(0, 0, AU * 2, AU * 2);
    arc(0, 7, AU * 2, AU * 2, PI, TWO_PI);
    arc(0, -7, -AU * 2, -AU * 2, PI, TWO_PI);

    // Draw a 1 AU ring
    stroke(255, 100);
    //ellipse(0, 0, AU, AU);
    arc(0, 7, AU, AU, PI, TWO_PI);
    arc(0, -7, -AU, -AU, PI, TWO_PI);

    // Draw a 10 AU ring
    arc(0, 7, AU * 10, AU * 10, PI, TWO_PI);
    arc(0, -7, -AU * 10, -AU * 10, PI, TWO_PI);


  }
  else {
    if (greyOutPlanets && selectedPlanet != null) {
      pushMatrix();
       rotateY(-PI/2);
      stroke(255, 100);
      translate(0, 0, -100);
      fill(255, 0, 0, 50);
      arc(0, 0, (int) selectedPlanet.sun_hab_zone_max, (int) selectedPlanet.sun_hab_zone_max,radians(0.0),radians(90.0),PIE);
      fill(0, 255, 0, 100);
      translate(0, 0, 2);
      arc(0, 0, (int) (selectedPlanet.sun_hab_zone_max - selectedPlanet.sun_hab_zone_min), (int) (selectedPlanet.sun_hab_zone_max - selectedPlanet.sun_hab_zone_min),radians(0.0),radians(90.0),PIE);
      translate(0, 0, 2);
      fill(0, 0, 0);
      arc(0, 0, (int) selectedPlanet.sun_hab_zone_min, (int) selectedPlanet.sun_hab_zone_min,radians(0.0),radians(90.0),PIE);
      translate(0, 0, 2);
      fill(255, 0, 0, 50);
      arc(0, 0, (int) selectedPlanet.sun_hab_zone_min, (int) selectedPlanet.sun_hab_zone_min,radians(0.0),radians(90.0),PIE);      
      popMatrix();
    }
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
    text(xLabel, 50 * flatness, 40);

    // Draw X Axis min/max
    fill(255, 100 * flatness);
    text(1, AU, 17);
    text("0.5", AU/2, 17);

    popMatrix();
  }

  long mem = (Runtime.getRuntime().totalMemory() - Runtime.getRuntime().freeMemory())/1000000;

  // Render the planets
  for (int i = 0; i < planets.size(); i++) {
    try {
      ExoPlanet p = planets.get(i);
      if (p!=null) {
        p.update();
        p.render();
      }
    }

    catch(IndexOutOfBoundsException e) {
      e.printStackTrace();
    }
  }    
 // println("MEM USE: "+((Runtime.getRuntime().totalMemory() - Runtime.getRuntime().freeMemory())/1000000)+"mb, TOTAL: "+Runtime.getRuntime().totalMemory()/1000000+"mb, FREE: "+Runtime.getRuntime().freeMemory()/1000000);
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

/////////////////////
// SORTING METHODS //
/////////////////////
void sortBySize() {

  mode = "size";
  for (int i = 0; i < planets.size(); i++) {
    planets.get(i).tz = map(planets.get(i).radius, planetMinSize, planetMaxSize, 0, max);
    planets.get(i).difference = 0;
  }
  yLabel = "Planet Size (Earth Radii)";
  xLabel = "Semi-major Axis (Astronomical Units)";
  yMax = globalMaxSize;
  yMin = 0;

  visualisationState = "Planet Size";
}

void sortByTemp() {
  try{
  mode = "temp";

  for (int i = 0; i < planets.size(); i++) {
      float val = map(planets.get(i).temp, planetMinTemp, planetMaxTemp, 0, max);
  if (val < -10000 || val > 10000) continue;
    planets.get(i).tz = map(planets.get(i).temp, planetMinTemp, planetMaxTemp, 0, max);
    planets.get(i).difference = 0;
  }
  yLabel = "Temperature (Kelvin)";
  xLabel = "Semi-major Axis (Astronomical Units)";
  yMax = globalMaxTemp;
  yMin = globalMinTemp;
  visualisationState = "Temperature";
  }
  catch(Exception e){e.printStackTrace();}
}

void sortByESI() {
  mode = "ESI";
  for (int i = 0; i < planets.size(); i++) {
    planets.get(i).tz = map(planets.get(i).ESIs, planetMinESI, planetMaxESI, 0, max);
    planets.get(i).difference = 0;
  }
  yLabel = "Surface Earth Similarity Index";
  xLabel = "Interior Earth Similarity Index";
  yMax = 1.0;
  yMin = 0.0;
  mode = "ESI";
  visualisationState = "Earth Similarity Index";
}
void sortByKOI() {
  for (int i = 0; i < planets.size(); i++) {
    planets.get(i).tz = map(planets.get(i).KOI, planetMinKOI, planetMaxKOI, 0, max);
    planets.get(i).difference = 0;
  }
   yLabel = "Kepler Object of Interest Number";
  xLabel = "Semi-major Axis (Astronomical Units)";
  yMax = globalMaxKOI;
  yMin = globalMinKOI;
  mode = "KOI";

  visualisationState = "Kepler Object of Interest Number";
}

void unSort() {
  for (int i = 0; i < planets.size(); i++) {
    planets.get(i).tz = 0;
    planets.get(i).difference = 0;
  }
   yLabel = "";
  xLabel = "Semi-major Axis (Astronomical Units)";
  yMax = 0;
  yMin = 0;

  visualisationState = "Unordered";
}

void keyPressed() {
  String timeStamp = hour() + "_"  + minute() + "_" + second();
  if (key == 's') {
    save("out/Kepler" + timeStamp + ".png");
  } 
  else if (key == 'c') {
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
  } 
  else if (key == '2') {
    sortByTemp(); 
    //trot.x = PI/2;
  } 

  else if (key == '0') { 
    sortByESI(); //Sort data by earth similarity index
  } 

  else if (key == '`') {
    unSort();
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
  if (layout.equals("orbital")) {
    layout = "graph";
    visualisationLayout = "Graph View" ;
    max = 500; 
     cf.filterData();
  }
  else {
    layout = "orbital";
    visualisationLayout = "Orbital View" ;
    max = 1000; 
    cf.filterData();
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

void mousePressed() {
  // If compare button has been pressed then allow secondary selection of planet
  if (compare == true) {
    for (int i = 0; i < planets.size(); i++) {
      if (planets.get(i).overPlanet()) {
        selectedPlanetToCompare = planets.get(i); 
        selectedPlanetToCompare.feature = true; // Make it a feature planet
        selectedPlanetToCompare.label = "Compared: KOI- "+selectedPlanetToCompare.KOI; // update label
        setTextAreaText(textAreaToCompare, selectedPlanetToCompare); // Set second textarea text
        compareInfo.hide(); // hide compare button
        compare = false; // Reset compare
        break;
      }
    }
  }
  else {
    for (int i = 0; i < planets.size(); i++) {
      if (planets.get(i).overPlanet()) {
        selectedPlanet = planets.get(i);

        if (selectedPlanet.corePlanet) {
          setTextAreaText(textArea, selectedPlanet); // Planets in our solar system dont have the required info so specialised message requried
          return;
        }

        selectedPlanet.feature = true;
        selectedPlanet.label = "Selected: KOI- "+selectedPlanet.KOI;
        setTextAreaText(textArea, selectedPlanet);

        // Find all sister planets in the same solar system and make them a feature planet.     
        for (int j = 0; j < planets.size(); j++) {
          ExoPlanet p = planets.get(j);
          if (p != selectedPlanet) {
            if (p.sun_name!=null && p.sun_name.equals(selectedPlanet.sun_name)) {
              p.feature = true;
              p.label = "Same Star: KOI-"+p.KOI;
            }
            else { 
              p.feature = false;
            }
          }
        }
        break;
      }
    }
  }
}

/**      
 Set the appropriate text area to the correct information about the planet provided
 */
void setTextAreaText(Textarea area, ExoPlanet p) {

  // If planet is from our solar system, ie not an Exoplanet then print appropriate fields
  if (selectedPlanet.corePlanet) { 
    textArea.setText(
    "Planet Name: \t"+selectedPlanet.label 
      +"\nRadius: \t"+selectedPlanet.radius
      +"\nTemperature: \t"+selectedPlanet.temp
      +"\nPeriod (days/year): \t"+selectedPlanet.period
      +"\nESIg: \t"+selectedPlanet.ESIg
      +"\nESIi: \t"+selectedPlanet.ESIi
      +"\nESIs: \t"+selectedPlanet.ESIs
      );
  }
  // Else planet is outside our solar system so print appropriate fields
  else {
    area.setText(
    "Kepler Plantary Index (KOI): \t"+p.KOI 
      +"\nTemperature: \t"+p.temp
      +"\nGravity: \t"+p.KOI
      +"\nRadius: \t"+p.radius
      +"\nZone Class: \t"+p.zone_class
      +"\nMass Class: \t"+p.mass_class
      +"\nComposition Class: \t"+p.composition_class
      +"\nHabitable Class: \t"+p.habitable_class
      +"\nAtmosphere Class: \t"+p.atmosphere_class
      +"\nTechnology Discovered By: \t"+p.disc_tech
      +"\nYear Discovered: \t"+p.disc_year
      +"\nESIg: \t"+p.ESIg
      +"\nESIi: \t"+p.ESIi
      +"\nESIs: \t"+p.ESIs
      );
  }
}


void mouseWheel(MouseEvent event) {
  float delta = event.getAmount();
  if (delta==-1 && tzoom <=3)
    tzoom+=0.2;
  else if (delta == 1 && tzoom >= .1)
    tzoom-=0.2;
}

