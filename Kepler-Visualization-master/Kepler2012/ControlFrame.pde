public class ControlFrame extends PApplet {
  int w, h;
  int abc = 100;
    ControlP5 cp5;
int myColorBackground = color(0,0,0);
Range range;
  float globalMinESI = 0;
  float globalMaxESI = 1;
  float minKOI = 10000;
  float maxKOI = 0;

       Button compareButton;
  Object parent;
  
  
  public void getMinMax(){
    for (int i = 0; i < allPlanets.size(); i++)
    {
   
      ExoPlanet p = allPlanets.get(i);
         if (p.corePlanet) continue;
      maxKOI = max(p.KOI, maxKOI);
      minKOI = min(p.KOI, minKOI);
    }
  
  }
  
  public void setup() {
    int initialY = 10;
    int initialX = 300;
    int buttonInitialY = 0;
    int buttonInitialX =300;
    int componentHeight = 40;
    int gap = 10;
    getMinMax();
    size(w, h);
    frameRate(25);
    cp5 = new ControlP5(this);
      textArea = cp5.addTextarea("txt")
                  .setPosition(0,0)
                  .setSize(250,500)                 
                  .setFont(createFont("arial",12))
                  .setLineHeight(14)
                  //.setColor(color(128))
                  .setColorBackground(color(255,100))
                  .setColorForeground(color(255,100));
                  ;
                  textArea.setText("No Planet Selected");
                  
           textAreaToCompare = cp5.addTextarea("txtCompare")
                  .setPosition(1000,0)
                  .setSize(250,500)                 
                  .setFont(createFont("arial",12))
                  .setLineHeight(14)
                  //.setColor(color(128))
                  .setColorBackground(color(255,100))
                  .setColorForeground(color(255,100));
                  ;
                  textAreaToCompare.setText("No Planet Selected To Compare");
                  
                compareInfo =  cp5.addTextarea("compareInfo")
                  .setPosition(85,200)
                  .setSize(160,20)                 
                  .setFont(createFont("arial",12))
                  .setLineHeight(14)
                  //.setColor(color(128))
                  .setColorBackground(color(0,100,0))
                  .setColorForeground(color(0,100,0));
                  ;
                  compareInfo.setText("Select Planet to Compare");
                   compareInfo.hide();
                  
              //Slider for KOI
              range = cp5.addRange("KOI Range")
             .setBroadcast(false) 
             .setPosition(initialX+120,initialY)
             .setSize(200,40)
             .setHandleSize(20)
             .setRange(minKOI,maxKOI)
             .setRangeValues(minKOI,maxKOI)
             // after the initialization we turn broadcast back on again
             .setBroadcast(true)
             .setColorForeground(color(255,40))
             .setColorBackground(color(255,40))  
             ;
             //
              //Slider for temperature
              range = cp5.addRange("Temperature Range")
             .setBroadcast(false) 
              .setPosition(initialX+120,initialY+componentHeight+gap)
             .setSize(200,40)
             .setHandleSize(20)
             .setRange(globalMinTemp,globalMaxTemp)
             .setRangeValues(globalMinTemp,globalMaxTemp)
             // after the initialization we turn broadcast back on again
             .setBroadcast(true)
             .setColorForeground(color(255,40))
             .setColorBackground(color(255,40))  
             ;
             //
              //Slider for size
              range = cp5.addRange("Size Range")
             .setBroadcast(false) 
               .setPosition(initialX+120,initialY+(componentHeight*2)+(gap*2))
             .setSize(200,40)
             .setHandleSize(20)
             .setRange(globalMinSize,globalMaxSize)
             .setRangeValues(globalMinSize,globalMaxSize)
             // after the initialization we turn broadcast back on again
             .setBroadcast(true)
             .setColorForeground(color(255,40))
             .setColorBackground(color(255,40))  
             ;
             //Slider for ESI
              range = cp5.addRange("Earth Similarity Index Range")
             .setBroadcast(false) 
              .setPosition(initialX+120,initialY+(componentHeight*3)+(gap*3))
             .setSize(200,40)
             .setHandleSize(20)
             .setRange(0.0,1.0)
             .setRangeValues(0.0,1.0)
             // after the initialization we turn broadcast back on again
             .setBroadcast(true)
             .setColorForeground(color(255,40))
             .setColorBackground(color(255,40)) 
            ; 
            
            // Buttons for changing visualisation state
               cp5.addButton("Change View")
              .setPosition(initialX+500,initialY)
             .setSize(100,40)
            ;
                 cp5.addButton("Grey out other planets")
           .setValue(0)
            .setPosition(initialX+500,initialY+componentHeight+gap)
           .setSize(100,40)
           ;
           cp5.addButton("Pause")
           .setValue(0)
                    .setPosition(initialX+500,initialY+(componentHeight*2)+(gap*2))
           .setSize(100,40)
           ;
                cp5.addButton("Unsort")
           .setValue(0)
                    .setPosition(initialX+500,initialY+(componentHeight*3)+(gap*3))
           .setSize(100,40)
           ;
      
         
     // Main buttons for sorting data
     cp5.addButton("Sort by KOI")
      .setPosition(initialX,initialY)
     .setSize(100,40)
     ;
           cp5.addButton("Sort by Temp")
    .setPosition(initialX,initialY+componentHeight+gap)
     .setSize(100,40)
     ;
      cp5.addButton("Sort by Size")
      .setPosition(initialX,initialY+(componentHeight*2)+(gap*2))
     .setSize(100,40)
     ;

      cp5.addButton("Sort by ESI")
      .setPosition(initialX,initialY+(componentHeight*3)+(gap*3))
     .setSize(100,40)
     ;
     
      compareButton = cp5.addButton("Compare")
      .setPosition(0,200)
     .setSize(80,20)
     ;
     //////////////////////////
     //SAVED HORIZONTAL ASPECT RATIO
     ///////////////////////////
//     textArea = cp5.addTextarea("txt")
//                  .setPosition(0,0)
//                  .setSize(250,500)                 
//                  .setFont(createFont("arial",12))
//                  .setLineHeight(14)
//                  //.setColor(color(128))
//                  .setColorBackground(color(255,100))
//                  .setColorForeground(color(255,100));
//                  ;
//                  textArea.setText("No Planet Selected");
//                  
//           textAreaToCompare = cp5.addTextarea("txtCompare")
//                  .setPosition(1000,0)
//                  .setSize(250,500)                 
//                  .setFont(createFont("arial",12))
//                  .setLineHeight(14)
//                  //.setColor(color(128))
//                  .setColorBackground(color(255,100))
//                  .setColorForeground(color(255,100));
//                  ;
//                  textAreaToCompare.setText("No Planet Selected To Compare");
//                  
//                compareInfo =  cp5.addTextarea("compareInfo")
//                  .setPosition(85,200)
//                  .setSize(160,20)                 
//                  .setFont(createFont("arial",12))
//                  .setLineHeight(14)
//                  //.setColor(color(128))
//                  .setColorBackground(color(0,100,0))
//                  .setColorForeground(color(0,100,0));
//                  ;
//                  compareInfo.setText("Select Planet to Compare");
//                   compareInfo.hide();
//                  
//              //Slider for KOI
//              range = cp5.addRange("KOI Range")
//             .setBroadcast(false) 
//             .setPosition(initialX+120,initialY)
//             .setSize(200,40)
//             .setHandleSize(20)
//             .setRange(minKOI,maxKOI)
//             .setRangeValues(minKOI,maxKOI)
//             // after the initialization we turn broadcast back on again
//             .setBroadcast(true)
//             .setColorForeground(color(255,40))
//             .setColorBackground(color(255,40))  
//             ;
//             //
//              //Slider for temperature
//              range = cp5.addRange("Temperature Range")
//             .setBroadcast(false) 
//              .setPosition(initialX+120,initialY+componentHeight+gap)
//             .setSize(200,40)
//             .setHandleSize(20)
//             .setRange(globalMinTemp,globalMaxTemp)
//             .setRangeValues(globalMinTemp,globalMaxTemp)
//             // after the initialization we turn broadcast back on again
//             .setBroadcast(true)
//             .setColorForeground(color(255,40))
//             .setColorBackground(color(255,40))  
//             ;
//             //
//              //Slider for size
//              range = cp5.addRange("Size Range")
//             .setBroadcast(false) 
//               .setPosition(initialX+120,initialY+(componentHeight*2)+(gap*2))
//             .setSize(200,40)
//             .setHandleSize(20)
//             .setRange(globalMinSize,globalMaxSize)
//             .setRangeValues(globalMinSize,globalMaxSize)
//             // after the initialization we turn broadcast back on again
//             .setBroadcast(true)
//             .setColorForeground(color(255,40))
//             .setColorBackground(color(255,40))  
//             ;
//             //Slider for ESI
//              range = cp5.addRange("Earth Similarity Index Range")
//             .setBroadcast(false) 
//              .setPosition(initialX+120,initialY+(componentHeight*3)+(gap*3))
//             .setSize(200,40)
//             .setHandleSize(20)
//             .setRange(0.0,1.0)
//             .setRangeValues(0.0,1.0)
//             // after the initialization we turn broadcast back on again
//             .setBroadcast(true)
//             .setColorForeground(color(255,40))
//             .setColorBackground(color(255,40)) 
//            ; 
//            
//            // Buttons for changing visualisation state
//               cp5.addButton("Change View")
//              .setPosition(initialX+500,initialY)
//             .setSize(100,40)
//            ;
//                 cp5.addButton("Grey out other planets")
//           .setValue(0)
//            .setPosition(initialX+500,initialY+componentHeight+gap)
//           .setSize(100,40)
//           ;
//           cp5.addButton("Pause")
//           .setValue(0)
//                    .setPosition(initialX+500,initialY+(componentHeight*2)+(gap*2))
//           .setSize(100,40)
//           ;
//                cp5.addButton("Unsort")
//           .setValue(0)
//                    .setPosition(initialX+500,initialY+(componentHeight*3)+(gap*3))
//           .setSize(100,40)
//           ;
//      
//         
//     // Main buttons for sorting data
//     cp5.addButton("Sort by KOI")
//      .setPosition(initialX,initialY)
//     .setSize(100,40)
//     ;
//           cp5.addButton("Sort by Temp")
//    .setPosition(initialX,initialY+componentHeight+gap)
//     .setSize(100,40)
//     ;
//      cp5.addButton("Sort by Size")
//      .setPosition(initialX,initialY+(componentHeight*2)+(gap*2))
//     .setSize(100,40)
//     ;
//
//      cp5.addButton("Sort by ESI")
//      .setPosition(initialX,initialY+(componentHeight*3)+(gap*3))
//     .setSize(100,40)
//     ;
//     
//      compareButton = cp5.addButton("Compare")
//      .setPosition(0,200)
//     .setSize(80,20)
//     ;
            filterData();
             //
               noStroke();  
           addMouseWheelListener(new java.awt.event.MouseWheelListener() { 
    public void mouseWheelMoved(java.awt.event.MouseWheelEvent mwe) { 
      mouseWheel(mwe.getWheelRotation());
  }}); 
      
  }

  
  void controlEvent(ControlEvent event) {
      boolean hasChanged = false; // only dilter at end of method if ranges have changed
      String changedValue = ""; // need to set max of other values when a range has been changed
    try{
  if(event.isFrom("Temperature Range")) {
    hasChanged = true; changedValue = "temp";
    globalMinTemp = event.getController().getArrayValue(0);
    globalMaxTemp = event.getController().getArrayValue(1);
    planetMinTemp = event.getController().getArrayValue(0);
    planetMaxTemp = event.getController().getArrayValue(1);
  }
    else if(event.isFrom("Size Range")) {
          hasChanged = true; changedValue = "size";
    globalMinSize = event.getController().getArrayValue(0);
    globalMaxSize = event.getController().getArrayValue(1);
    planetMinSize = event.getController().getArrayValue(0);
    planetMaxSize = event.getController().getArrayValue(1);
  }
     else if(event.isFrom("Earth Similarity Index Range")) {
           hasChanged = true; changedValue = "esi";
    globalMinESI = event.getController().getArrayValue(0);
    globalMaxESI = event.getController().getArrayValue(1);
    planetMinESI = event.getController().getArrayValue(0);
    planetMaxESI = event.getController().getArrayValue(1);
  }
     else if(event.isFrom("KOI Range")) {
           hasChanged = true; changedValue = "koi";
    minKOI = event.getController().getArrayValue(0);
    maxKOI = event.getController().getArrayValue(1);
  }
    if (hasChanged){
      // Set Temp ranges to rescale planets
      if (!changedValue.equals("temp")){
        planetMinTemp = 3867;
        planetMaxTemp = 83;
       for (ExoPlanet p: planets){
         if (planetMinTemp > p.temp) {planetMinTemp = p.temp;}
         if (planetMaxTemp < p.temp) {planetMaxTemp = p.temp;}
       }
      }
      // Set Size ranges to rescale planets
      if (!changedValue.equals("size")){        
        planetMinSize = 58.06;
        planetMaxSize =  0.33;
       for (ExoPlanet p: planets){
         if (planetMinSize > p.radius) {planetMinSize = p.radius;}
         if (planetMaxSize < p.radius) {planetMaxSize = p.radius;}
       }}
      
      if (!changedValue.equals("esi")){  
        planetMinESI = 1;
        planetMaxESI = 0;
       for (ExoPlanet p: planets){
         if (planetMinESI > p.ESIg) {planetMinESI = p.ESIg;}
         if (planetMaxESI < p.ESIg) {planetMaxESI = p.ESIg;}
       }}
     
      if (!changedValue.equals("koi")){ 
        planetMinKOI = 2771;
        planetMaxKOI = 1;
       for (ExoPlanet p: planets){
         float koi =p.KOI;
        // if (planetMinKOI > koi) {planetMinKOI = koi;}
         //if (planetMaxKOI < koi) {planetMaxKOI = koi;}
       }
    }
      
      filterData(); 
    }

  if (event.isFrom("Pause")) {
    if (pausedVis) pausedVis = false;
    else pausedVis = true;
  }
   else if (event.isFrom("Grey out other planets")) {
     if(greyOutPlanets) greyOutPlanets = false;
     else greyOutPlanets = true;
  } 
    else if (event.isFrom("Sort by KOI")) {
      sortByKOI();
  } 
    else if (event.isFrom("Sort by Temp")) {
      sortByTemp();
  } 
    else if (event.isFrom("Sort by Size")) {
      sortBySize();
  } 
    else if (event.isFrom("Sort by ESI")) {
      sortByESI();
  } 
    else if (event.isFrom("Change View")) {
        tflatness = (tflatness == 1) ? (0):(1);
    toggleFlatness(tflatness);
  } 
    else if (event.isFrom("Unsort")) {
         unSort();
  } 
    else if (event.isFrom("Compare")) {
         compare = true;
          compareInfo.show();
  } 
    }
    catch(Exception e){e.printStackTrace();}
}


void keyPressed() {
//  switch(key) {
//    case('1'):rankepler.ge.setLowValue(0);break;
//    case('2'):range.setLowValue(100);break;
//    case('3'):range.setHighValue(120);break;
//    case('4'):range.setHighValue(200)//;break;
//    case('5'):range.setRangeValues(40,6;break;
//  }
}
  
  public void draw() {
    if (selectedPlanet == null || selectedPlanet.corePlanet){cp5.controller("Compare").hide();}
    else {cp5.controller("Compare").show();}
      background(abc);
  
  }
  private ControlFrame() {
  }
  public ControlFrame(Object theParent, int theWidth, int theHeight) {
    parent = theParent;
    w = theWidth;
    h = theHeight;
  }
  public ControlP5 control() {
    return cp5;
  }

/** Filter Planets according to filter sliders**/
public void filterData(){
  planets.clear();
  for (int i = 0; i < allPlanets.size(); i++){
   ExoPlanet p = allPlanets.get(i);
    
   if (p.feature || p.corePlanet) {  
   planets.add(p);
   continue;
   }
   //Apply filters
    if (p.temp >= globalMinTemp && p.temp <= globalMaxTemp){
      if (p.radius >= globalMinSize && p.radius <= globalMaxSize){
        if (p.ESIg >= globalMinESI && p.ESIg <= globalMaxESI){
                  if (p.KOI >= minKOI && p.KOI <= maxKOI){
                    planets.add(p);
                  }
      }
       }}
  }
  
  if (mode.equals("ESI")) sortByESI();
  else if (mode.equals("temp")) sortByTemp();
  else if (mode.equals("size")) sortBySize();
  else if (mode.equals("none")) unSort();
}  
void mouseWheel(int delta) {

  if (delta==-1 && tzoom <=3)
  tzoom+=0.2;
  else if (delta == 1 && tzoom >= .1)
  tzoom-=0.2;
}
}



