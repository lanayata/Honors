public class ControlFrame extends PApplet {
  int w, h;
  int abc = 100;
    ControlP5 cp5;
int myColorBackground = color(0,0,0);
Range range;
  float minESL = 0;
  float maxESL = 1;
  float minKOI = 10000;
  float maxKOI = 0;

  Object parent;
  
  
  public void getMinMax(){
    for (int i = 0; i < allPlanets.size(); i++)
    {
   
      ExoPlanet p = allPlanets.get(i);
         if (p.corePlanet) continue;
      maxKOI = max(parseFloat(p.KOI), maxKOI);
      minKOI = min(parseFloat(p.KOI), minKOI);
    }
  
  }
  
  public void setup() {
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
           
              //Slider for KOI
              range = cp5.addRange("KOI Range")
             .setBroadcast(false) 
             .setPosition(300,0)
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
             .setPosition(300,50)
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
             .setPosition(300,100)
             .setSize(200,40)
             .setHandleSize(20)
             .setRange(globalMinSize,globalMaxSize)
             .setRangeValues(globalMinSize,globalMaxSize)
             // after the initialization we turn broadcast back on again
             .setBroadcast(true)
             .setColorForeground(color(255,40))
             .setColorBackground(color(255,40))  
             ;
             //Slider for ESL
              range = cp5.addRange("Earth Similarity Index Range")
             .setBroadcast(false) 
             .setPosition(300,150)
             .setSize(200,40)
             .setHandleSize(20)
             .setRange(0.0,1.0)
             .setRangeValues(0.0,1.0)
             // after the initialization we turn broadcast back on again
             .setBroadcast(true)
             .setColorForeground(color(255,40))
             .setColorBackground(color(255,40)) 
            ; 
              cp5.addButton("pause")
     .setValue(0)
     .setPosition(displayWidth-100, 0)
     .setSize(100,50)
     ;
                cp5.addButton("Grey out other planets")
     .setValue(0)
     .setPosition(displayWidth-100, 110)
     .setSize(100,50)
     ;
            filterData();
             //
               noStroke();        
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
    minESL = event.getController().getArrayValue(0);
    maxESL = event.getController().getArrayValue(1);
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
      
      if (!changedValue.equals("esi")){}
     
      if (!changedValue.equals("koi")){}
      
      filterData(); 
    }

  if (event.isFrom("pause")) {
  if (pausedVis) pausedVis = false;
  else pausedVis = true;
  }
  if (event.isFrom("Grey out other planets")) {
     if(greyOutPlanets) greyOutPlanets = false;
     else greyOutPlanets = true;
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
        if (p.ESLg >= minESL && p.ESLg <= maxESL){
                  if (parseFloat(p.KOI) >= minKOI && parseFloat(p.KOI) <= maxKOI){
                    planets.add(p);
                  }
      }
       }}
  }
  
  if (mode.equals("ESL")) sortByESL();
  else if (mode.equals("temp")) sortByTemp();
  else if (mode.equals("size")) sortBySize();
  else if (mode.equals("none")) unSort();
}  
}



